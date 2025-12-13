package com.example.demo.service;

import com.example.demo.model.Event;
import com.example.demo.model.User;
import com.example.demo.repository.CommentRepository;
import com.example.demo.repository.EventRepository;
import com.example.demo.repository.RatingRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class EventService {
    @Autowired
    private EventRepository eventRepository;

    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private NotificationService notificationService;
    
    @Autowired
    private EventSuggestionService eventSuggestionService;
    
    @Autowired
    private RatingRepository ratingRepository;
    
    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Event> getAllEvents() {
        return eventRepository.findAll();
    }

    public List<Event> getFeaturedEvents() {
        return eventRepository.findFeatured();
    }

    public List<Event> getEventsByUser(Long userId) {
        return eventRepository.findByUserId(userId);
    }

    public Event getEventById(Long id) {
        return eventRepository.findById(id);
    }

    public int getRegistrationCount(Long suKienId) {
        return eventRepository.countRegistrations(suKienId);
    }

    public List<Event> getPublicAvailableEvents() {
        return eventRepository.findPublicAvailable();
    }

    public List<Event> searchEvents(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return List.of();
        }
        return eventRepository.searchEvents(keyword.trim());
    }

    public List<Event> getSuKienByOrganizer(Long organizerId) {
        return eventRepository.findByOrganizer(organizerId);
    }

    public void createSuKien(Event suKien) {
        suKien.setNgayTao(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        eventRepository.save(suKien);
    }

    public Event getSuKienById(Long id) {
        return eventRepository.findById(id);
    }

    public List<Event> getUpcomingEvents(Long organizerId) {
        return eventRepository.findUpcomingByOrganizer(organizerId);
    }

    public List<Event> getPopularEvents(Long organizerId) {
        return eventRepository.findPopularByOrganizer(organizerId);
    }

    public List<Event> getPopularEvents(int limit) {
        return eventRepository.findPopularEvents(limit);
    }

    public void updateSuKien(Event suKien) {
        Event existingEvent = eventRepository.findById(suKien.getSuKienId());
        if (existingEvent != null) {
            if (suKien.getAnhBia() == null || suKien.getAnhBia().isEmpty()) {
                suKien.setAnhBia(existingEvent.getAnhBia());
            }
            suKien.setTrangThaiPheDuyet(existingEvent.getTrangThaiPheDuyet());
        }
        
        eventRepository.update(suKien);
    }

    public void deleteSuKien(Long id) {
        eventRepository.delete(id);
    }

    public List<Event> searchEventsWithFilters(String keyword, String status, String privacy, Long categoryId) {
        if ((keyword == null || keyword.trim().isEmpty()) && (status == null || status.trim().isEmpty()) 
                && (privacy == null || privacy.trim().isEmpty()) && categoryId == null) {
            return List.of();
        }

        return eventRepository.searchEventsWithFilters(keyword != null ? keyword.trim() : null, status, privacy, categoryId);
    }

    public List<Event> filterEvents(String keyword, String eventType, Date startDate, Date endDate,
                                String location, Long categoryId, String status) {
        return eventRepository.filterEvents(keyword, eventType, startDate, endDate, location, categoryId, status);
    }

    public String getEventTypeName(Long categoryId) {
        return eventRepository.getEventTypeName(categoryId);
    }

    public String getTimeStatusInVietnamese(String status) {
        if (status == null) return "Không xác định";
        
        switch (status) {
            case "SapDienRa":
                return "Sắp diễn ra";
            case "DangDienRa":
                return "Đang diễn ra";
            case "DaKetThuc":
                return "Đã kết thúc";
            default:
                return status;
        }
    }

    public String getApprovalStatusInVietnamese(String status) {
        if (status == null) return "Không xác định";
        
        switch (status) {
            case "ChoDuyet":
                return "Chờ duyệt";
            case "DaDuyet":
                return "Đã duyệt";
            case "TuChoi":
                return "Từ chối";
            default:
                return status;
        }
    }

    public String getEventTypeInVietnamese(String eventType) {
        if (eventType == null) return "Không xác định";
        
        switch (eventType) {
            case "CongKhai":
                return "Công khai";
            case "RiengTu":
                return "Riêng tư";
            default:
                return eventType;
        }
    }

    public List<Map<String, Object>> getAllEventTypes() {
        return eventRepository.getAllEventTypesWithNames();
    }

    public List<Map<String, Object>> getEventsWithVietnameseInfo(List<Event> events) {
        return events.stream().map(event -> {
            Map<String, Object> eventMap = new HashMap<>();
            eventMap.put("suKienId", event.getSuKienId());
            eventMap.put("tenSuKien", event.getTenSuKien());
            eventMap.put("moTa", event.getMoTa());
            eventMap.put("diaDiem", event.getDiaDiem());
            eventMap.put("anhBia", event.getAnhBia());
            eventMap.put("thoiGianBatDau", event.getThoiGianBatDau());
            eventMap.put("thoiGianKetThuc", event.getThoiGianKetThuc());
            eventMap.put("soLuongToiDa", event.getSoLuongToiDa());
            eventMap.put("soLuongDaDangKy", event.getSoLuongDaDangKy());
            eventMap.put("loaiSuKienId", event.getLoaiSuKienId());
            
            eventMap.put("trangThaiThoiGian", getTimeStatusInVietnamese(event.getTrangThaiThoiGian()));
            eventMap.put("trangThaiPheDuyet", getApprovalStatusInVietnamese(event.getTrangThaiPheDuyet()));
            eventMap.put("loaiSuKien", getEventTypeInVietnamese(event.getLoaiSuKien()));
            eventMap.put("loaiSuKienTen", getEventTypeName(event.getLoaiSuKienId()));
            
            return eventMap;
        }).collect(Collectors.toList());
    }

    public List<User> findAll() {
        String sql = "SELECT * FROM nguoi_dung";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class));
    }

    public List<Event> getRecentEvents(int limit) {
        return eventRepository.findAll().stream()
            .filter(event -> !"DaKetThuc".equals(event.getTrangThaiThoiGian()))
            .sorted((e1, e2) -> e2.getThoiGianBatDau().compareTo(e1.getThoiGianBatDau()))
            .limit(limit)
            .collect(Collectors.toList());
    }

    public Event getNextAvailableEvent(int currentCount) {
        List<Event> allEvents = eventRepository.findAll().stream()
            .filter(event -> !"DaKetThuc".equals(event.getTrangThaiThoiGian()))
            .sorted((e1, e2) -> e2.getThoiGianBatDau().compareTo(e1.getThoiGianBatDau()))
            .collect(Collectors.toList());
        
        if (allEvents.size() > currentCount) {
            return allEvents.get(currentCount);
        }
        return null;
    }

    public List<Map<String, Object>> getEventsByType(Long organizerId) {
        return eventRepository.getEventsByType(organizerId);
    }

    public List<Map<String, Object>> countEventsByType() {
        return eventRepository.countEventsByType();
    }

    public List<Event> getEventsByIds(List<Long> ids) {
        return eventRepository.getEventsByIds(ids);
    }
    
    public void updateAllTimeStatus() {
        eventRepository.updateAllTimeStatus();
    }
    
    // Phương thức mới: Phê duyệt/từ chối sự kiện và gửi thông báo
    public Map<String, Object> processEventApproval(Long eventId, String action, String reason, Long adminId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            Event event = eventRepository.findById(eventId);
            if (event == null) {
                result.put("success", false);
                result.put("message", "Không tìm thấy sự kiện");
                return result;
            }
            
            String newStatus = "accept".equals(action) ? "DaDuyet" : "TuChoi";
            String newTimeStatus = "accept".equals(action) ? "SapDienRa" : "Huy";
            
            // Cập nhật trạng thái sự kiện
            event.setTrangThaiPheDuyet(newStatus);
            event.setTrangThaiThoiGian(newTimeStatus);
            eventRepository.update(event);
            
            // Gửi thông báo cho người tổ chức
            notificationService.createNotification(
                event.getNguoiToChucId(),
                "Sự kiện được " + ("accept".equals(action) ? "phê duyệt" : "từ chối"),
                "Sự kiện '" + event.getTenSuKien() + "' của bạn đã được " + 
                ("accept".equals(action) ? "phê duyệt" : "từ chối") + 
                (reason != null ? ". Lý do: " + reason : ""),
                "SuKien",
                eventId
            );
            
            result.put("success", true);
            result.put("message", "Đã " + ("accept".equals(action) ? "phê duyệt" : "từ chối") + " sự kiện");
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi xử lý: " + e.getMessage());
        }
        
        return result;
    }
    
    // Phương thức mới: Lấy tất cả sự kiện chờ duyệt
    public List<Event> getPendingEvents() {
        return eventRepository.findAll().stream()
            .filter(event -> "ChoDuyet".equals(event.getTrangThaiPheDuyet()))
            .collect(Collectors.toList());
    }


    // Lấy chi tiết sự kiện với thông tin đầy đủ
    public Map<String, Object> getEventDetail(Long eventId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            Event event = eventRepository.findById(eventId);
            if (event == null) {
                result.put("success", false);
                result.put("message", "Sự kiện không tồn tại");
                return result;
            }
            
            // Lấy thông tin đánh giá
            Double averageRating = ratingRepository.getAverageRating(eventId);
            Integer totalRatings = ratingRepository.getTotalRatings(eventId);
            Integer totalComments = commentRepository.getTotalComments(eventId);
            
            Map<String, Object> eventDetail = new HashMap<>();
            eventDetail.put("suKienId", event.getSuKienId());
            eventDetail.put("tenSuKien", event.getTenSuKien());
            eventDetail.put("moTa", event.getMoTa());
            eventDetail.put("diaDiem", event.getDiaDiem());
            eventDetail.put("anhBia", event.getAnhBia());
            eventDetail.put("thoiGianBatDau", event.getThoiGianBatDau());
            eventDetail.put("thoiGianKetThuc", event.getThoiGianKetThuc());
            eventDetail.put("loaiSuKien", event.getLoaiSuKien());
            eventDetail.put("trangThaiThoiGian", event.getTrangThaiThoiGian());
            eventDetail.put("soLuongToiDa", event.getSoLuongToiDa());
            eventDetail.put("soLuongDaDangKy", event.getSoLuongDaDangKy());
            eventDetail.put("averageRating", averageRating != null ? averageRating : 0);
            eventDetail.put("totalRatings", totalRatings != null ? totalRatings : 0);
            eventDetail.put("totalComments", totalComments != null ? totalComments : 0);
            
            result.put("success", true);
            result.put("data", eventDetail);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi lấy thông tin sự kiện: " + e.getMessage());
        }
        
        return result;
    }

}