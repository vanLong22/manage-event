package com.example.demo.service;

import com.example.demo.model.ActivityHistory;
import com.example.demo.model.Event;
import com.example.demo.model.Registration;
import com.example.demo.repository.ActivityHistoryRepository;
import com.example.demo.repository.RegistrationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class RegistrationService {
    @Autowired
    private RegistrationRepository registrationRepository;
    
    @Autowired
    private ActivityHistoryRepository historyRepository;
    
    @Autowired
    private NotificationService notificationService;

    @Autowired
    private EventService eventService;

    @Autowired
    private JdbcTemplate jdbcTemplate; // Đảm bảo đã có

    public List<Registration> getRegistrationsByUser(Long userId) {
        return registrationRepository.findByUserId(userId);
    }
    
    public void registerEvent(Long userId, Long suKienId, String ghiChu, String maSuKien) {

        Registration registration = new Registration();
        registration.setNguoiDungId(userId);
        registration.setSuKienId(suKienId);
        registration.setGhiChu(ghiChu);
        registration.setTrangThai("DaDuyet");
        registration.setThoiGianDangKy(
            Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant())
        );

        // Lưu (nếu full sẽ throw Exception)
        registrationRepository.save(registration);

        // Ghi lịch sử
        Event eventInfor = eventService.getEventById(suKienId);

        ActivityHistory history = new ActivityHistory();
        history.setNguoiDungId(userId);
        history.setLoaiHoatDong("DangKy");
        history.setSuKienId(suKienId);
        history.setChiTiet("Đăng ký sự kiện: " + eventInfor.getTenSuKien());
        history.setThoiGian(new Date());

        historyRepository.save(history);
    }


// public void cancelRegistration(Long dangKyId, Long userId) {
    //     registrationRepository.cancel(dangKyId);

    //     // Log lịch sử
    //     ActivityHistory history = new ActivityHistory();
    //     history.setNguoiDungId(userId);
    //     history.setLoaiHoatDong("HuyDangKy");
    //     history.setChiTiet("Hủy đăng ký ID: " + dangKyId);
    //     history.setThoiGian(
    //         Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant())
    //     );
    //     historyRepository.save(history);
    // }

    public int countAttendedEvents(Long userId) {
        return registrationRepository.countByUserIdAndStatus(userId, "DaDuyet");
    }

    public int countUpcomingEvents(Long userId) {
        return registrationRepository.countUpcomingByUser(userId);
    }

    public int countPendingRegistrations(Long userId) {
        return registrationRepository.countByUserIdAndStatus(userId, "ChoDuyet");
    }
    
    public List<Registration> getRegistrationsByUserWithEvent(Long userId) {
        return registrationRepository.findByUserIdWithEvent(userId);
    }

    public List<Registration> getRegistrationsByEvent(Long suKienId) {
        return registrationRepository.findByEventId(suKienId);
    }

    public List<Registration> getAllRegistrationsForOrganizer(Long organizerId) {
        return registrationRepository.findAllForOrganizer(organizerId);
    }

    public void updateAttendance(Long dangKyId, boolean trangThaiDiemDanh) {
        registrationRepository.updateAttendance(dangKyId, trangThaiDiemDanh ? "DaThamGia" : "ChuaThamGia");
    }

    public Map<String, Object> getAnalyticsStats(Long organizerId) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("activeEvents", registrationRepository.countActiveEvents(organizerId));
        stats.put("totalParticipants", registrationRepository.countTotalParticipants(organizerId));
        stats.put("upcomingEvents", registrationRepository.countUpcomingEvents(organizerId));
        stats.put("attentionEvents", registrationRepository.countAttentionEvents(organizerId));
        return stats;
    }

    public List<Registration> getAllRegistrations() {
        return registrationRepository.findAll();
    }

    public Registration getRegistrationById(Long id) {
        return registrationRepository.findById(id);
    }

    public List<Map<String, Object>> getRequestStatusDistribution() {
        return registrationRepository.getRequestStatusDistribution();
    }

    public List<Map<String, Object>> getRegistrationsOverTime(String period) {
        return registrationRepository.getRegistrationsOverTime(period);
    }
    
    // Phương thức mới: Gửi thông báo khi sự kiện được phê duyệt/từ chối
    public void sendEventApprovalNotification(Long eventId, String eventName, Long organizerId, String action, String reason) {
        String title = "";
        String content = "";
        
        if ("approve".equals(action)) {
            title = "Sự kiện được phê duyệt";
            content = "Sự kiện '" + eventName + "' của bạn đã được phê duyệt và hiện đang hiển thị trên hệ thống.";
        } else if ("reject".equals(action)) {
            title = "Sự kiện bị từ chối";
            content = "Sự kiện '" + eventName + "' của bạn đã bị từ chối. Lý do: " + reason;
        }
        
        notificationService.createNotification(organizerId, title, content, "SuKien", eventId);
    }


    public void cancelRegistration(Long dangKyId, Long userId) {
        try {
            // 1. Kiểm tra đăng ký tồn tại
            Registration registration = registrationRepository.findById(dangKyId);
            if (registration == null) {
                throw new RuntimeException("Không tìm thấy đăng ký với ID: " + dangKyId);
            }
            
            // 2. Kiểm tra quyền (người dùng có phải chủ đăng ký không)
            if (!registration.getNguoiDungId().equals(userId)) {
                throw new RuntimeException("Bạn không có quyền hủy đăng ký này");
            }
            
            // 3. Kiểm tra trạng thái hiện tại
            if ("DaHuy".equals(registration.getTrangThai())) {
                throw new RuntimeException("Đăng ký đã bị hủy trước đó");
            }
            
            // 4. Cập nhật trạng thái thay vì xóa
            String updateSql = "UPDATE dang_ky_su_kien SET trang_thai = 'DaHuy' WHERE dang_ky_su_kien_id = ?";
            jdbcTemplate.update(updateSql, dangKyId);
            
            // 5. Giảm số lượng đăng ký trong sự kiện
            String decreaseSql = "UPDATE su_kien SET so_luong_da_dang_ky = GREATEST(so_luong_da_dang_ky - 1, 0) WHERE su_kien_id = ?";
            jdbcTemplate.update(decreaseSql, registration.getSuKienId());
            
            // 6. Ghi log lịch sử hoạt động
            ActivityHistory history = new ActivityHistory();
            history.setNguoiDungId(userId);
            history.setLoaiHoatDong("HuyDangKy");
            history.setSuKienId(registration.getSuKienId());
            history.setChiTiet("Hủy đăng ký ID: " + dangKyId + " cho sự kiện ID: " + registration.getSuKienId());
            history.setThoiGian(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
            historyRepository.save(history);
            
        } catch (Exception e) {
            // Ném lại exception để controller xử lý
            throw new RuntimeException("Lỗi khi hủy đăng ký: " + e.getMessage());
        }
    }


}