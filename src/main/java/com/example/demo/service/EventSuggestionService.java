package com.example.demo.service;

import com.example.demo.model.ActivityHistory;
import com.example.demo.model.EventSuggestion;
import com.example.demo.model.Notification;
import com.example.demo.repository.ActivityHistoryRepository;
import com.example.demo.repository.EventSuggestionRepository;
import com.example.demo.repository.NotificationRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class EventSuggestionService {

    @Autowired
    private EventSuggestionRepository suggestionRepository;

    @Autowired
    private ActivityHistoryRepository historyRepository;

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired EventSuggestionRepository eventSuggestionRepository;

    // Lấy danh sách đề xuất theo người dùng
    public List<EventSuggestion> getSuggestionsByUser(Long userId) {
        return suggestionRepository.findByUserId(userId);
    }

    // Gửi đề xuất mới
    public void submitSuggestion(EventSuggestion suggestion) {
        suggestion.setThoiGianTao(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        suggestion.setTrangThai("ChoDuyet");

        suggestionRepository.save(suggestion);

        // Ghi lịch sử hoạt động
        ActivityHistory history = new ActivityHistory();
        history.setNguoiDungId(suggestion.getNguoiDungId());
        history.setLoaiHoatDong("DangSuKien");
        history.setChiTiet("Đề xuất sự kiện: " + suggestion.getTieuDe());
        history.setThoiGian(new Date());
        historyRepository.save(history);
    }

    // Lưu và trả về ID của đề xuất
    public Long submitSuggestionAndReturnId(EventSuggestion suggestion) {
        suggestion.setThoiGianTao(new Date());
        suggestion.setTrangThai("CHO_DUYET");
        Long id = suggestionRepository.saveAndReturnId(suggestion);

        // Lưu lịch sử
        ActivityHistory history = new ActivityHistory();
        history.setNguoiDungId(suggestion.getNguoiDungId());
        history.setLoaiHoatDong("DangSuKien");
        history.setChiTiet("Đề xuất sự kiện (ID: " + id + "): " + suggestion.getTieuDe());
        history.setThoiGian(new Date());
        historyRepository.save(history);

        return id;
    }

    // Lấy chi tiết đề xuất theo ID
    public EventSuggestion getSuggestionById(Long id) {
        return suggestionRepository.findById(id);
    }

    // Lấy chi tiết đề xuất theo ID và user
    public Optional<EventSuggestion> getSuggestionByIdAndUser(Long id, Long userId) {
        return suggestionRepository.findByIdAndUserId(id, userId);
    }

    // Xóa đề xuất
    public boolean deleteSuggestion(Long suggestionId, Long userId) {
        boolean result = suggestionRepository.deleteSuggestion(suggestionId, userId);
        if (result) {
            ActivityHistory history = new ActivityHistory();
            history.setNguoiDungId(userId);
            history.setLoaiHoatDong("XoaSuKien");
            history.setChiTiet("Xóa đề xuất sự kiện ID: " + suggestionId);
            history.setThoiGian(new Date());
            historyRepository.save(history);
        }
        return result;
    }

    // Cập nhật đề xuất
    public boolean updateSuggestion(EventSuggestion suggestion) {
        boolean result = suggestionRepository.updateSuggestion(suggestion);
        if (result) {
            ActivityHistory history = new ActivityHistory();
            history.setNguoiDungId(suggestion.getNguoiDungId());
            history.setLoaiHoatDong("CapNhatSuKien");
            history.setChiTiet("Cập nhật đề xuất sự kiện: " + suggestion.getTieuDe());
            history.setThoiGian(new Date());
            historyRepository.save(history);
        }
        return result;
    }

    // Cập nhật trạng thái đề xuất (duyệt, từ chối, v.v.)
    public boolean updateSuggestionStatus(Long suggestionId, String status, Long adminId) {
        boolean result = suggestionRepository.updateSuggestionStatus(suggestionId, status);
        if (result) {
            ActivityHistory history = new ActivityHistory();
            history.setNguoiDungId(adminId);
            history.setLoaiHoatDong("CapNhatTrangThaiSuKien");
            history.setChiTiet("Cập nhật trạng thái sự kiện ID: " + suggestionId + " -> " + status);
            history.setThoiGian(new Date());
            historyRepository.save(history);
        }
        return result;
    }

    // Lấy danh sách đề xuất theo trạng thái
    public List<EventSuggestion> getSuggestionsByStatus(String status) {
        return suggestionRepository.findByStatus(status);
    }


    // Lấy danh sách đề xuất với các bộ lọc
    public List<Map<String, Object>> getSuggestionsWithFilters(Integer loaiSuKienId, String diaDiem, String soLuongKhachRange, String trangThai) {
        return eventSuggestionRepository.findSuggestionsWithFilters(loaiSuKienId, diaDiem, soLuongKhachRange, trangThai);
    }

    public Map<String, Object> getSuggestionDetail(Long suggestionId) {
        return eventSuggestionRepository.findSuggestionDetailById(suggestionId);
    }

    public boolean processSuggestion(Long dangSuKienId, String action, String message, Long organizerId) {
        try {
            Map<String, Object> suggestionDetail = eventSuggestionRepository.findSuggestionDetailById(dangSuKienId);
            if (suggestionDetail == null) return false;

            String newStatus = "accept".equals(action) ? "DaDuyet" : "TuChoi";
            boolean updateSuccess = eventSuggestionRepository.updateSuggestionStatus(dangSuKienId, newStatus);
            if (!updateSuccess) return false;

            sendSuggestionNotification(dangSuKienId, action, message, suggestionDetail, organizerId);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createSuggestion(EventSuggestion suggestion) {
        try {
            if (suggestion.getThoiGianTao() == null) {
                suggestion.setThoiGianTao(new Date());
            }
            if (suggestion.getTrangThai() == null) {
                suggestion.setTrangThai("CHO_DUYET");
            }

            eventSuggestionRepository.save(suggestion);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, Integer> getSuggestionStats() {
        return Map.of(
            "total", eventSuggestionRepository.findSuggestionsWithFilters(null, null, null, null).size(),
            "pending", eventSuggestionRepository.findByStatus("CHO_DUYET").size(),
            "approved", eventSuggestionRepository.findByStatus("DaDuyet").size(),
            "rejected", eventSuggestionRepository.findByStatus("TuChoi").size()
        );
    }

    // Gửi thông báo cho người đề xuất
    private void sendSuggestionNotification(Long dangSuKienId, String action, String message, 
                                        Map<String, Object> suggestionDetail, Long organizerId) {
        try {
            Long nguoiDungId = (Long) suggestionDetail.get("nguoiDungId");
            String tieuDeSuKien = (String) suggestionDetail.get("tieuDe");
            
            String tieuDeThongBao = "";
            String noiDungThongBao = "";
            
            if ("accept".equals(action)) {
                tieuDeThongBao = "Đề xuất sự kiện được chấp nhận";
                noiDungThongBao = String.format(
                    "Đề xuất sự kiện '%s' của bạn đã được chấp nhận. %s",
                    tieuDeSuKien,
                    message != null ? message : "Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất!"
                );
            } else {
                tieuDeThongBao = "Đề xuất sự kiện bị từ chối";
                noiDungThongBao = String.format(
                    "Đề xuất sự kiện '%s' của bạn đã bị từ chối. Lý do: %s",
                    tieuDeSuKien,
                    message != null ? message : "Không phù hợp với nhu cầu hiện tại."
                );
            }

            // Tạo thông báo
            Notification notification = new Notification();
            notification.setTieuDe(tieuDeThongBao);
            notification.setNoiDung(noiDungThongBao);
            notification.setLoaiThongBao("SuKien");
            notification.setNguoiDungId(nguoiDungId);
            notification.setSuKienId(dangSuKienId);
            notification.setDaDoc(0L); // Chưa đọc
            notification.setThoiGian(new Date());

            // Lưu thông báo
            notificationRepository.save(notification);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
