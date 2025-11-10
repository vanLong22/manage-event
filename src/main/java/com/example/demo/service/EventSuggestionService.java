package com.example.demo.service;

import com.example.demo.model.ActivityHistory;
import com.example.demo.model.EventSuggestion;
import com.example.demo.repository.ActivityHistoryRepository;
import com.example.demo.repository.EventSuggestionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class EventSuggestionService {

    @Autowired
    private EventSuggestionRepository suggestionRepository;

    @Autowired
    private ActivityHistoryRepository historyRepository;

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
}
