
package com.example.demo.service;

import com.example.demo.model.Event;
import com.example.demo.model.User;
import com.example.demo.repository.EventRepository;
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


    // Tất cả sự kiện công khai + còn chỗ
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
        suKien.setTrangThai("SapDienRa");
        eventRepository.save(suKien);
    }

    public Event getSuKienById(Long id) {
        return eventRepository.findById(id);
    }

    // Thêm mới: Upcoming events
    public List<Event> getUpcomingEvents(Long organizerId) {
        return eventRepository.findUpcomingByOrganizer(organizerId);
    }

    // Thêm mới: Popular events (dựa trên số đăng ký)
    public List<Event> getPopularEvents(Long organizerId) {
        return eventRepository.findPopularByOrganizer(organizerId);
    }

    // Thêm phương thức mới: Popular events toàn hệ thống (top N by registrations)
    public List<Event> getPopularEvents(int limit) {
        return eventRepository.findPopularEvents(limit);
    }

    // Thêm mới: Update event
    public void updateSuKien(Event suKien) {
        eventRepository.update(suKien);
    }

    // Thêm mới: Delete event
    public void deleteSuKien(Long id) {
        eventRepository.delete(id);
    }

    // Hàm đã viết lại để thực hiện chức năng filter (hỗ trợ lọc theo nhiều tiêu chí: keyword, status, privacy, categoryId)
    public List<Event> searchEventsWithFilters(String keyword, String status, String privacy, Long categoryId) {
        // Nếu không có tiêu chí lọc nào, trả về danh sách rỗng hoặc tất cả (tùy theo yêu cầu, ở đây giả sử trả về rỗng nếu không có keyword chính)
        if ((keyword == null || keyword.trim().isEmpty()) && (status == null || status.trim().isEmpty()) 
                && (privacy == null || privacy.trim().isEmpty()) && categoryId == null) {
            return List.of();
        }

        // Gọi repository để thực hiện filter ở mức SQL cho hiệu suất
        return eventRepository.searchEventsWithFilters(keyword != null ? keyword.trim() : null, status, privacy, categoryId);
    }

    // Thêm các phương thức mới vào EventService.java
    public List<Event> filterEvents(String keyword, String eventType, Date startDate, Date endDate,
                                String location, Long categoryId, String status) {
        return eventRepository.filterEvents(keyword, eventType, startDate, endDate, location, categoryId, status);
    }

    // Phương thức để lấy tên loại sự kiện bằng tiếng Việt
    public String getEventTypeName(Long categoryId) {
        return eventRepository.getEventTypeName(categoryId);
    }

    // Phương thức chuyển đổi trạng thái sang tiếng Việt
    public String getStatusInVietnamese(String status) {
        if (status == null) return "Không xác định";
        
        switch (status) {
            case "SapDienRa":
                return "Sắp diễn ra";
            case "DangDienRa":
                return "Đang diễn ra";
            case "DaKetThuc":
                return "Đã kết thúc";
            case "DaHuy":
                return "Đã hủy";
            default:
                return status;
        }
    }

    // Phương thức chuyển đổi loại sự kiện sang tiếng Việt
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

    // Phương thức lấy tất cả loại sự kiện
    public List<Map<String, Object>> getAllEventTypes() {
        return eventRepository.getAllEventTypesWithNames();
    }

    // Phương thức tạo DTO với thông tin đã dịch
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
            
            // Dịch sang tiếng Việt
            eventMap.put("trangThai", getStatusInVietnamese(event.getTrangThai()));
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
        // Lấy sự kiện mới nhất, loại trừ các sự kiện đã hủy
        return eventRepository.findAll().stream()
            .filter(event -> !"Huy".equals(event.getTrangThai()))
            .sorted((e1, e2) -> e2.getThoiGianBatDau().compareTo(e1.getThoiGianBatDau()))
            .limit(limit)
            .collect(Collectors.toList());
    }

    public Event getNextAvailableEvent(int currentCount) {
        List<Event> allEvents = eventRepository.findAll().stream()
            .filter(event -> !"Huy".equals(event.getTrangThai()))
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

    public List<Event> getEventsByIds(List<Long> ids) {
        return eventRepository.getEventsByIds(ids);
    }
}