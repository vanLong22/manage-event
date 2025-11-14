package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.service.*;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/participant")
public class ParticipantController {

    @Autowired
    private UserService userService;
    @Autowired
    private EventService eventService;
    @Autowired
    private RegistrationService registrationService;
    @Autowired
    private NotificationService notificationService;
    @Autowired
    private EventSuggestionService suggestionService;
    @Autowired
    private ActivityHistoryService historyService;
    @Autowired
    private LoaiSuKienService loaiSuKienService;

    @GetMapping("/renter/join")
    public String dashboard(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        User user = userService.findById(userId);
        if (user == null) { session.invalidate(); return "redirect:/login"; }
        model.addAttribute("user", user);

        // Thống kê
        model.addAttribute("stats", Map.of(
            "eventsAttended", registrationService.countAttendedEvents(userId),
            "upcomingEvents", registrationService.countUpcomingEvents(userId),
            "pendingEvents", registrationService.countPendingRegistrations(userId),
            "suggestionsSent", 5
        ));

        model.addAttribute("featuredEvents", eventService.getFeaturedEvents());
        model.addAttribute("allEvents", eventService.getPublicAvailableEvents());

        // SỬA: Lấy đăng ký kèm sự kiện đầy đủ
        List<Registration> myEvents = registrationService.getRegistrationsByUserWithEvent(userId);
        model.addAttribute("myEvents", myEvents);

        model.addAttribute("eventTypes", loaiSuKienService.findAll());

        List<Notification> notifications = notificationService.getNotificationsByUser(userId);
        long unreadCount = notifications.stream()
            .filter(n -> n.getDaDoc() == 0)  // 0 = chưa đọc
            .count();        
        model.addAttribute("notifications", notifications);
        model.addAttribute("unreadNotificationCount", unreadCount);

        model.addAttribute("suggestions", suggestionService.getSuggestionsByUser(userId));
        model.addAttribute("histories", historyService.getHistoryByUser(userId));

        return "renter/join";
    }

    // API: Xem chi tiết sự kiện
    @GetMapping("/api/events/{id}")
    @ResponseBody
    public ResponseEntity<Event> getEventDetail(@PathVariable Long id) {
        Event event = eventService.getEventById(id);
        if (event == null) {
            System.out.println("Event not found for ID: " + id); // Debug
            return ResponseEntity.notFound().build();
        }
        System.out.println("Returning event: " + event.getTenSuKien()); // Debug
        return ResponseEntity.ok(event);
    }


    // API: Tham gia sự kiện
    @PostMapping(value = "/api/register-event", consumes = "application/json")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> registerEvent(@RequestBody Map<String, Object> payload, HttpSession session) {
        System.out.println("Received registration payload: " + payload);

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return ResponseEntity.status(401).body(Map.of("success", false, "message", "Chưa đăng nhập"));

        try {
            Long suKienId = Long.valueOf(payload.get("suKienId").toString());
            String ghiChu = (String) payload.get("ghiChu");
            String maSuKien = (String) payload.get("maSuKien"); 

            // Lấy thông tin sự kiện để kiểm tra
            Event event = eventService.getEventById(suKienId);
            if (event == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Sự kiện không tồn tại"));
            }

            // Kiểm tra nếu sự kiện là riêng tư
            boolean isPrivate = "RiengTu".equals(event.getLoaiSuKien()); 
            if (isPrivate) {
                // Nếu riêng tư, yêu cầu mã và kiểm tra tính hợp lệ
                if (maSuKien == null || maSuKien.trim().isEmpty()) {
                    return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Mã sự kiện là bắt buộc cho sự kiện riêng tư"));
                }
                if (!maSuKien.equals(event.getMatKhauSuKienRiengTu())) {  
                    return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Mã sự kiện không đúng"));
                }
            } else {
                // Nếu công khai, không cần mã (có thể bỏ qua nếu được gửi)
                maSuKien = null; // Đặt null để không sử dụng
            }

            // Gọi service để đăng ký (giữ nguyên)
            registrationService.registerEvent(userId, suKienId, ghiChu, maSuKien);
            return ResponseEntity.ok(Map.of("success", true, "message", "Đăng ký thành công!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }
    
    // API: Hủy đăng ký
    @PostMapping("/api/cancel-registration")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> cancelRegistration(@RequestBody Map<String, Long> payload, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return ResponseEntity.status(401).body(Map.of("success", false));

        Long dangKyId = payload.get("dangKyId");
        try {
            registrationService.cancelRegistration(dangKyId, userId);
            return ResponseEntity.ok(Map.of("success", true, "message", "Hủy thành công!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }


    // AJAX: Load sự kiện nổi bật
    @GetMapping("/api/events/featured")
    public ResponseEntity<List<Event>> getFeaturedEvents() {
        return ResponseEntity.ok(eventService.getFeaturedEvents());
    }
    /* 
    // AJAX: Load tất cả sự kiện
    @GetMapping("/api/events")
    public ResponseEntity<List<Event>> getEvents(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String privacy,  // New: for loaiSuKien (CongKhai/RiengTu)
            @RequestParam(required = false) Long categoryId  // New: for loaiSuKienId
    ) {

        System.out.println("Filters - keyword: " + keyword + ", status: " + status + ", privacy: " + privacy + ", categoryId: " + categoryId); // Debug

        // Call the rewritten searchEvents method
        List<Event> events = eventService.searchEventsWithFilters(keyword, status, privacy, categoryId);

        // Optional: Add organizer names or other processing if needed
        events.forEach(event -> {
            User organizer = userService.findById(event.getNguoiToChucId());
            if (organizer != null) {
                // Handle in frontend or add transient field
            }
        });

        return ResponseEntity.ok(events);
    }
    */
    // AJAX: Load sự kiện của tôi
    @GetMapping("/api/my-events")
    public ResponseEntity<List<Registration>> getMyEvents() {
        Long userId = 1001L; // Từ session
        return ResponseEntity.ok(registrationService.getRegistrationsByUser(userId));
    }

    // AJAX: Load thông báo
    @GetMapping("/api/notifications")
    public ResponseEntity<List<Notification>> getNotifications() {
        Long userId = 1001L;
        return ResponseEntity.ok(notificationService.getNotificationsByUser(userId));
    }

    // AJAX: Đánh dấu đọc thông báo
    @PostMapping("/api/notifications/mark-read")
    public ResponseEntity<Map<String, Object>> markNotificationRead(@RequestBody Map<String, Long> request) {
        Long thongBaoId = request.get("thongBaoId");
        notificationService.markAsRead(thongBaoId);
        return ResponseEntity.ok(Map.of("success", true));
    }

    // AJAX: Đánh dấu tất cả đọc
    @PostMapping("/api/notifications/mark-all-read")
    public ResponseEntity<Map<String, Object>> markAllRead() {
        Long userId = 1001L;
        notificationService.markAllAsRead(userId);
        return ResponseEntity.ok(Map.of("success", true));
    }

    // AJAX: Gửi đề xuất sự kiện
    @PostMapping("/api/suggestions")
    public ResponseEntity<Map<String, Object>> submitSuggestion(@RequestBody EventSuggestion suggestion) {
        Long userId = 1001L;
        suggestion.setNguoiDungId(userId);
        suggestionService.submitSuggestion(suggestion);
        return ResponseEntity.ok(Map.of("success", true, "message", "Đề xuất đã gửi!"));
    }

    // AJAX: Load đề xuất đã gửi
    @GetMapping("/api/suggestions")
    public ResponseEntity<List<EventSuggestion>> getSuggestions() {
        Long userId = 1001L;
        return ResponseEntity.ok(suggestionService.getSuggestionsByUser(userId));
    }

    // AJAX: Load lịch sử hoạt động
    @GetMapping("/api/history")
    public ResponseEntity<List<ActivityHistory>> getHistory() {
        Long userId = 1001L;
        return ResponseEntity.ok(historyService.getHistoryByUser(userId));
    }

    // AJAX: Cập nhật tài khoản
    @PostMapping("/api/account/update")
    public ResponseEntity<Map<String, Object>> updateAccount(@RequestBody User user) {
        userService.update(user);
        return ResponseEntity.ok(Map.of("success", true, "message", "Cập nhật thành công!"));
    }

    @GetMapping("/api/events/search")
    @ResponseBody
    public ResponseEntity<List<Event>> searchEvents(@RequestParam String q) {
        List<Event> results = eventService.searchEvents(q);
        System.out.println("Search query: " + q + ", Results found: " + results.size()); // Debug
        return ResponseEntity.ok(results);
    }
    
    // API: Xem chi tiết đề xuất
    @GetMapping("/api/suggestions/{id}")
    @ResponseBody
    public ResponseEntity<EventSuggestion> getSuggestionDetail(@PathVariable Long id) {
        EventSuggestion suggestion = suggestionService.getSuggestionById(id);
        if (suggestion == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(suggestion);
    }

    // API: Xóa đề xuất
    @DeleteMapping("/api/suggestions/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteSuggestion(@PathVariable Long id, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return ResponseEntity.status(401).body(Map.of("success", false));
        
        try {
            suggestionService.deleteSuggestion(id, userId);
            return ResponseEntity.ok(Map.of("success", true, "message", "Xóa đề xuất thành công!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // API: Xem chi tiết thông báo
    @GetMapping("/api/notifications/{id}")
    @ResponseBody
    public ResponseEntity<Notification> getNotificationDetail(@PathVariable Long id) {
        Notification notification = notificationService.getNotificationById(id);
        if (notification == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(notification);
    }

    // API: Xóa thông báo
    @DeleteMapping("/api/notifications/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteNotification(@PathVariable Long id, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return ResponseEntity.status(401).body(Map.of("success", false));
        
        try {
            notificationService.deleteNotification(id, userId);
            return ResponseEntity.ok(Map.of("success", true, "message", "Xóa thông báo thành công!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // API: Xử lý thông báo (chấp nhận/từ chối)
    @PostMapping("/api/notifications/{id}/action")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> processNotificationAction(
            @PathVariable Long id, 
            @RequestBody Map<String, String> request, 
            HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return ResponseEntity.status(401).body(Map.of("success", false));
        
        String action = request.get("action");
        try {
            notificationService.processNotificationAction(id, userId, action);
            return ResponseEntity.ok(Map.of("success", true, "message", "Xử lý thông báo thành công!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }



    // API lọc sự kiện nâng cao
    @GetMapping("/api/events/filter")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> filterEvents(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String eventType,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String status) {

        try {
            List<Event> events = eventService.filterEvents(keyword, eventType, startDate, endDate, location, categoryId, status);
            List<Map<String, Object>> eventsWithVietnameseInfo = eventService.getEventsWithVietnameseInfo(events);
            
            return ResponseEntity.ok(Map.of(
                "success", true, 
                "data", eventsWithVietnameseInfo,
                "total", events.size()
            ));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Lỗi khi lọc sự kiện: " + e.getMessage()));
        }
    }

    // API lấy danh sách loại sự kiện
    @GetMapping("/api/event-types")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getEventTypes() {
        try {
            List<Map<String, Object>> eventTypes = eventService.getAllEventTypes();
            return ResponseEntity.ok(Map.of("success", true, "data", eventTypes));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Lỗi khi tải danh mục sự kiện"));
        }
    }

    // Cập nhật API getEvents hiện tại để hỗ trợ tham số mới
    @GetMapping("/api/events")
    @ResponseBody
    public ResponseEntity<List<Event>> getEvents(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String privacy,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate,
            @RequestParam(required = false) String location) {

        System.out.println("Filters - keyword: " + keyword + ", status: " + status + ", privacy: " + privacy + 
                        ", categoryId: " + categoryId + ", startDate: " + startDate + ", endDate: " + endDate + 
                        ", location: " + location);

        // Sử dụng phương thức lọc nâng cao
        List<Event> events = eventService.filterEvents(keyword, privacy, startDate, endDate, location, categoryId, status);

        // Optional: Add organizer names or other processing if needed
        events.forEach(event -> {
            User organizer = userService.findById(event.getNguoiToChucId());
            if (organizer != null) {
                // Handle in frontend or add transient field
            }
        });

        return ResponseEntity.ok(events);
    }
}