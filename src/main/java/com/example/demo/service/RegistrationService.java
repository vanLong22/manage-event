package com.example.demo.service;

import com.example.demo.model.ActivityHistory;
import com.example.demo.model.Event;
import com.example.demo.model.Registration;
import com.example.demo.repository.ActivityHistoryRepository;
import com.example.demo.repository.RegistrationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    
        // Kiểm tra xem người dùng đã đăng ký sự kiện này chưa
        String checkSql = "SELECT COUNT(*) FROM dang_ky_su_kien WHERE nguoi_dung_id = ? AND su_kien_id = ? AND trang_thai != 'DaHuy'";
        Integer existingCount = jdbcTemplate.queryForObject(checkSql, Integer.class, userId, suKienId);
        
        if (existingCount != null && existingCount > 0) {
            throw new RuntimeException("Bạn đã đăng ký sự kiện này rồi!");
        }

        // Kiểm tra sự kiện có tồn tại và còn chỗ không
        Event eventInfor = eventService.getEventById(suKienId);
        if (eventInfor == null) {
            throw new RuntimeException("Sự kiện không tồn tại");
        }
        
        if (eventInfor.getSoLuongDaDangKy() >= eventInfor.getSoLuongToiDa()) {
            throw new RuntimeException("Sự kiện đã đủ số lượng tham gia");
        }

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

    // Thêm vào RegistrationService.java
    @Transactional
    public Map<String, Object> updateRegistrationStatus(Long dangKyId, String trangThai, Long organizerId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Lấy thông tin đăng ký
            Registration registration = registrationRepository.findRegistrationWithEvent(dangKyId);
            if (registration == null) {
                result.put("success", false);
                result.put("message", "Không tìm thấy đăng ký");
                return result;
            }
            
            // Kiểm tra quyền (sự kiện thuộc về organizer)
            if (!registration.getEvent().getNguoiToChucId().equals(organizerId)) {
                result.put("success", false);
                result.put("message", "Bạn không có quyền thực hiện hành động này");
                return result;
            }
            
            String oldStatus = registration.getTrangThai();
            
            // Kiểm tra nếu đang phê duyệt và sự kiện đã đủ người
            if ("DaDuyet".equals(trangThai)) {
                Event event = eventService.getEventById(registration.getSuKienId());
                if (event.getSoLuongDaDangKy() >= event.getSoLuongToiDa()) {
                    result.put("success", false);
                    result.put("message", "Sự kiện đã đủ số lượng tham gia");
                    return result;
                }
            }
            
            // Cập nhật trạng thái
            boolean updated = registrationRepository.updateRegistrationStatus(dangKyId, trangThai);
            
            if (updated) {
                // Cập nhật số lượng tham gia nếu trạng thái thay đổi từ/tới DaDuyet
                if ("DaDuyet".equals(oldStatus) && !"DaDuyet".equals(trangThai)) {
                    // Từ DaDuyet sang trạng thái khác -> giảm số lượng
                    registrationRepository.decreaseEventRegistrationCount(registration.getSuKienId());
                } else if (!"DaDuyet".equals(oldStatus) && "DaDuyet".equals(trangThai)) {
                    // Từ trạng thái khác sang DaDuyet -> tăng số lượng
                    String updateSql = "UPDATE su_kien SET so_luong_da_dang_ky = so_luong_da_dang_ky + 1 WHERE su_kien_id = ?";
                    jdbcTemplate.update(updateSql, registration.getSuKienId());
                }
                
                // Gửi thông báo cho người dùng
                sendRegistrationNotification(registration, trangThai);
                
                // Ghi log
                ActivityHistory history = new ActivityHistory();
                history.setNguoiDungId(organizerId);
                history.setLoaiHoatDong("PheDuyetDangKy");
                history.setSuKienId(registration.getSuKienId());
                history.setChiTiet("Cập nhật trạng thái đăng ký ID " + dangKyId + " thành: " + trangThai);
                history.setThoiGian(new Date());
                historyRepository.save(history);
                
                result.put("success", true);
                result.put("message", "Cập nhật trạng thái thành công");
            } else {
                result.put("success", false);
                result.put("message", "Cập nhật trạng thái thất bại");
            }
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi hệ thống: " + e.getMessage());
        }
        
        return result;
    }

    private void sendRegistrationNotification(Registration registration, String trangThai) {
        String title = "";
        String content = "";
        
        switch (trangThai) {
            case "DaDuyet":
                title = "Đăng ký sự kiện được phê duyệt";
                content = "Đăng ký tham gia sự kiện '" + registration.getEvent().getTenSuKien() + "' của bạn đã được phê duyệt.";
                break;
            case "TuChoi":
                title = "Đăng ký sự kiện bị từ chối";
                content = "Đăng ký tham gia sự kiện '" + registration.getEvent().getTenSuKien() + "' của bạn đã bị từ chối.";
                break;
            case "ChoDuyet":
                title = "Đăng ký sự kiện đang chờ duyệt";
                content = "Đăng ký tham gia sự kiện '" + registration.getEvent().getTenSuKien() + "' của bạn đang chờ duyệt.";
                break;
        }
        
        if (!title.isEmpty()) {
            notificationService.createNotification(
                registration.getNguoiDungId(),
                title,
                content,
                "SuKien",
                registration.getSuKienId()
            );
        }
    }


}