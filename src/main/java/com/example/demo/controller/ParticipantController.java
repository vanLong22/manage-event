package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.service.*;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import org.springframework.core.ParameterizedTypeReference;


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

    private final RestTemplate restTemplate = new RestTemplate();
    private static final String PYTHON_API_URL = "http://127.0.0.1:5000/suggest"; // Thay bằng IP server nếu deploy


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
            "pendingEvents", registrationService.countPendingRegistrations(userId)
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

        // sự kiện mà người tham gia đã đề xuất cho người tổ chức
        model.addAttribute("suggestions", suggestionService.getSuggestionsByUser(userId));
        // lịch sử tương tác 
        model.addAttribute("histories", historyService.getHistoryByUser(userId));

        /*lấy sự kiện gợi ý từ mô hình đã huấn luyện */
        List<Long> suggestedIds = getSuggestedEventIdsFromPython(userId);
        List<Event> suggestedEvents = suggestedIds.isEmpty() 
        ? eventService.getFeaturedEvents() 
        : eventService.getEventsByIds(suggestedIds); 

        model.addAttribute("suggestedEvents", suggestedEvents);

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
    public ResponseEntity<List<Registration>> getMyEvents(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId"); 
        return ResponseEntity.ok(registrationService.getRegistrationsByUser(userId));
    }

    // AJAX: Load thông báo
    @GetMapping("/api/notifications")
    public ResponseEntity<List<Notification>> getNotifications(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
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
    public ResponseEntity<Map<String, Object>> markAllRead(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        notificationService.markAllAsRead(userId);
        return ResponseEntity.ok(Map.of("success", true));
    }

    // AJAX: Gửi đề xuất sự kiện
    @PostMapping("/api/suggestions")
    public ResponseEntity<Map<String, Object>> submitSuggestion(@RequestBody EventSuggestion suggestion, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        suggestion.setNguoiDungId(userId);
        suggestionService.submitSuggestion(suggestion);
        return ResponseEntity.ok(Map.of("success", true, "message", "Đề xuất đã gửi!"));
    }

    

    // AJAX: Load đề xuất đã gửi
    @GetMapping("/api/suggestions")
    public ResponseEntity<List<EventSuggestion>> getSuggestions(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        return ResponseEntity.ok(suggestionService.getSuggestionsByUser(userId));
    }

    // AJAX: Load lịch sử hoạt động
    @GetMapping("/api/history")
    public ResponseEntity<List<ActivityHistory>> getHistory(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
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

    // API: Đổi mật khẩu
    @PostMapping("/api/change-password")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> changePassword(@RequestBody Map<String, String> request, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "Chưa đăng nhập"));
        }

        try {
            String currentPassword = request.get("currentPassword");
            String newPassword = request.get("newPassword");
            String confirmPassword = request.get("confirmPassword");

            System.out.println("Thông tin nhận được từ fontend: " + currentPassword); // Debug
            System.out.println("Thông tin nhận được từ fontend: " + newPassword);
            System.out.println("Thông tin nhận được từ fontend: " + confirmPassword);

            // Validation
            if (currentPassword == null || currentPassword.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Vui lòng nhập mật khẩu hiện tại"));
            }

            if (newPassword == null || newPassword.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Vui lòng nhập mật khẩu mới"));
            }

            if (newPassword.length() < 6) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Mật khẩu mới phải có ít nhất 6 ký tự"));
            }

            if (!newPassword.equals(confirmPassword)) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Mật khẩu xác nhận không khớp"));
            }

            // Kiểm tra mật khẩu hiện tại
            if (!userService.verifyCurrentPassword(userId, currentPassword)) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Mật khẩu hiện tại không đúng"));
            }

            // Thực hiện đổi mật khẩu
            boolean success = userService.changePassword(userId, currentPassword, newPassword);
            
            if (success) {
                return ResponseEntity.ok(Map.of("success", true, "message", "Đổi mật khẩu thành công!"));
            } else {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Đổi mật khẩu thất bại"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of("success", false, "message", "Lỗi hệ thống: " + e.getMessage()));
        }
    }

    // API: Quên mật khẩu (cho chức năng mở rộng)
    @PostMapping("/api/forgot-password")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> forgotPassword(@RequestBody Map<String, String> request) {
        try {
            String email = request.get("email");
            String username = request.get("username");

            if ((email == null || email.trim().isEmpty()) && (username == null || username.trim().isEmpty())) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Vui lòng nhập email hoặc tên đăng nhập"));
            }

            // Tìm user theo email hoặc username
            User user = null;
            if (email != null && !email.trim().isEmpty()) {
                List<User> users = userService.findByEmail(email);
                if (!users.isEmpty()) {
                    user = users.get(0);
                }
            } else {
                user = userService.findByUsername(username);
            }

            if (user == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Không tìm thấy tài khoản với thông tin đã nhập"));
            }

            // TODO: Trong thực tế, gửi email reset mật khẩu
            // Ở đây chúng ta chỉ trả về thông báo thành công
            return ResponseEntity.ok(Map.of("success", true, "message", "Hướng dẫn reset mật khẩu đã được gửi đến email của bạn"));

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of("success", false, "message", "Lỗi hệ thống"));
        }
    }

    // API: Reset mật khẩu (cho admin hoặc qua email xác thực)
    @PostMapping("/api/reset-password")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> resetPassword(@RequestBody Map<String, String> request, HttpSession session) {
        try {
            String token = request.get("token");
            String newPassword = request.get("newPassword");
            String confirmPassword = request.get("confirmPassword");

            // Validation
            if (newPassword == null || newPassword.length() < 6) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Mật khẩu mới phải có ít nhất 6 ký tự"));
            }

            if (!newPassword.equals(confirmPassword)) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Mật khẩu xác nhận không khớp"));
            }

            // TODO: Xác thực token và lấy userId
            Long userId = (Long) session.getAttribute("userId");

            userService.resetPassword(userId, newPassword);
            
            return ResponseEntity.ok(Map.of("success", true, "message", "Reset mật khẩu thành công"));

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of("success", false, "message", "Lỗi hệ thống"));
        }
    }

    /**
     * Gọi API Python để lấy gợi ý sự kiện dựa trên mô hình ML
     */
    private List<Long> getSuggestedEventIdsFromPython(Long userId) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            var requestBody = Map.of("user_id", userId);
            HttpEntity<Map<String, Long>> entity = new HttpEntity<>(requestBody, headers);

            ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                PYTHON_API_URL,
                HttpMethod.POST,
                entity,
                new ParameterizedTypeReference<Map<String, Object>>() {}
            );

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                Object suggested = response.getBody().get("suggested_events");
                if (suggested instanceof List) {
                    return ((List<?>) suggested).stream()
                            .map(obj -> Long.valueOf(obj.toString()))
                            .limit(10) // lấy tối đa 10
                            .toList();
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi gọi API gợi ý Python: " + e.getMessage());
            // Không làm crash trang nếu ML server down
        }
        return List.of(); // trả về rỗng nếu lỗi
    }

}