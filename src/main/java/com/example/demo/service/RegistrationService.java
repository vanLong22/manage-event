package com.example.demo.service;

import com.example.demo.model.ActivityHistory;
import com.example.demo.model.Registration;
import com.example.demo.repository.ActivityHistoryRepository;
import com.example.demo.repository.RegistrationRepository;
import org.springframework.beans.factory.annotation.Autowired;
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

    public List<Registration> getRegistrationsByUser(Long userId) {
        return registrationRepository.findByUserId(userId);
    }

    public void registerEvent(Long userId, Long suKienId, String ghiChu, String maSuKien)  {
        // Tạo đối tượng Registration
        Registration registration = new Registration();
        registration.setNguoiDungId(userId);
        registration.setSuKienId(suKienId);
        registration.setGhiChu(ghiChu);
        registration.setThoiGianDangKy(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        // Mặc định trạng thái là "DaDuyet"
        registration.setTrangThai("DaDuyet");

        // Lưu vào DB
        registrationRepository.save(registration);

        // Ghi log lịch sử hoạt động
        ActivityHistory history = new ActivityHistory();
        history.setNguoiDungId(userId);
        history.setLoaiHoatDong("DangKy");
        history.setSuKienId(suKienId);
        history.setChiTiet("Đăng ký sự kiện: " + suKienId + 
                          (ghiChu != null && !ghiChu.isEmpty() ? " - Ghi chú: " + ghiChu : ""));
        history.setThoiGian(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        historyRepository.save(history);
    }

    public void cancelRegistration(Long dangKyId, Long userId) {
        registrationRepository.cancel(dangKyId);

        // Log lịch sử
        ActivityHistory history = new ActivityHistory();
        history.setNguoiDungId(userId);
        history.setLoaiHoatDong("HUY_DANG_KY");
        history.setChiTiet("Hủy đăng ký ID: " + dangKyId);
        history.setThoiGian(
            Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant())
        );
        historyRepository.save(history);
    }

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
}