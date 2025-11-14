package com.example.demo.controller;

import com.example.demo.model.Event;
import com.example.demo.model.User;
import com.example.demo.service.EventService;
import com.example.demo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private EventService eventService;

    @GetMapping("/admin")
    public String showAdminDashboard(Model model) {
        // Lấy danh sách người dùng
        List<User> allUsers = userService.findAll();
        model.addAttribute("totalUsers", allUsers.size());

        // Lấy danh sách sự kiện
        List<Event> allEvents = eventService.getAllEvents();
        long activeEvents = allEvents.stream()
            .filter(e -> "DangDienRa".equals(e.getTrangThai()))
            .count();
        long pendingEvents = allEvents.stream()
            .filter(e -> "SapDienRa".equals(e.getTrangThai()))
            .count();

        // Gửi dữ liệu sang view
        model.addAttribute("activeEvents", activeEvents);
        model.addAttribute("pendingEvents", pendingEvents);
        model.addAttribute("violationEvents", 0); // Dữ liệu tạm
        model.addAttribute("notificationCount", 5); // Dữ liệu tạm

        // Lấy 3 sự kiện gần nhất
        List<Event> recentEvents = allEvents.stream()
            .limit(3)
            .collect(Collectors.toList());
        model.addAttribute("recentEvents", recentEvents);

        return "admin/admin";
    }

    // API Dashboard data
    @GetMapping("/api/dashboard")
    @ResponseBody
    public Map<String, Object> getDashboardData() {
        Map<String, Object> data = new HashMap<>();
        
        List<User> allUsers = userService.findAll();
        List<Event> allEvents = eventService.getAllEvents();
        
        long activeEvents = allEvents.stream()
            .filter(e -> "DangDienRa".equals(e.getTrangThai()))
            .count();
        long pendingEvents = allEvents.stream()
            .filter(e -> "SapDienRa".equals(e.getTrangThai()))
            .count();
            
        data.put("totalUsers", allUsers.size());
        data.put("activeEvents", activeEvents);
        data.put("pendingEvents", pendingEvents);
        data.put("violationEvents", 0);
        data.put("notificationCount", 5);
        
        // Recent events (last 3)
        List<Event> recentEvents = allEvents.stream()
            .limit(3)
            .collect(Collectors.toList());
        data.put("recentEvents", recentEvents);
        
        return data;
    }

    // Get users with filtering
    @GetMapping("/api/users")
    public ResponseEntity<List<User>> getUsers(
            @RequestParam(required = false) String role,
            @RequestParam(required = false) String status) {
        
        List<User> allUsers = userService.findAll();
        
        // Filter by role
        if (role != null && !role.isEmpty()) {
            allUsers = allUsers.stream()
                .filter(user -> role.equals(user.getVaiTro()))
                .toList();
        }
        
        // Note: User model doesn't have status field, so we'll return all
        // You might need to add status field to User model
        
        return ResponseEntity.ok(allUsers);
    }

    // Get user by ID
    @GetMapping("/api/users/{id}")
    public ResponseEntity<User> getUser(@PathVariable Long id) {
        User user = userService.findById(id);
        if (user != null) {
            return ResponseEntity.ok(user);
        }
        return ResponseEntity.notFound().build();
    }

    // Toggle user status
    @PostMapping("/api/users/{id}/status")
    public ResponseEntity<Map<String, Object>> toggleUserStatus(
            @PathVariable Long id,
            @RequestParam String action) {
        
        Map<String, Object> response = new HashMap<>();
        // Note: User model doesn't have status field
        // You'll need to implement this functionality
        
        response.put("success", true);
        response.put("message", "Cập nhật trạng thái thành công");
        return ResponseEntity.ok(response);
    }

    // Get events with filtering
    @GetMapping("/api/events")
    public ResponseEntity<List<Event>> getEvents(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String type) {
        
        List<Event> allEvents = eventService.getAllEvents();
        
        // Filter by status
        if (status != null && !status.isEmpty()) {
            allEvents = allEvents.stream()
                .filter(event -> status.equals(event.getTrangThai()))
                .toList();
        }
        
        // Filter by type
        if (type != null && !type.isEmpty()) {
            allEvents = allEvents.stream()
                .filter(event -> type.equals(event.getLoaiSuKien()))
                .toList();
        }
        
        // Add organizer names (you might need to fetch this from user service)
        allEvents.forEach(event -> {
            User organizer = userService.findById(event.getNguoiToChucId());
            if (organizer != null) {
                // We'll add organizer name as a transient field or handle in frontend
            }
        });
        
        return ResponseEntity.ok(allEvents);
    }

    // Get pending events
    @GetMapping("/api/events/pending")
    public ResponseEntity<List<Event>> getPendingEvents() {
        List<Event> allEvents = eventService.getAllEvents();
        List<Event> pendingEvents = allEvents.stream()
            .filter(event -> "SapDienRa".equals(event.getTrangThai()))
            .toList();
        
        return ResponseEntity.ok(pendingEvents);
    }

    // Get event by ID
    @GetMapping("/api/events/{id}")
    public ResponseEntity<Event> getEvent(@PathVariable Long id) {
        Event event = eventService.getEventById(id);
        if (event != null) {
            return ResponseEntity.ok(event);
        }
        return ResponseEntity.notFound().build();
    }



    // API Approve event
    @PostMapping("/api/events/{id}/approve")
    @ResponseBody
    public Map<String, Object> approveEvent(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        Event event = eventService.getEventById(id);
        if (event != null) {
            event.setTrangThai("DangDienRa");
            eventService.updateSuKien(event);
            response.put("success", true);
            response.put("message", "Đã phê duyệt sự kiện");
        } else {
            response.put("success", false);
            response.put("message", "Không tìm thấy sự kiện");
        }
        
        return response;
    }

    // API Reject event
    @PostMapping("/api/events/{id}/reject")
    @ResponseBody
    public Map<String, Object> rejectEvent(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        Event event = eventService.getEventById(id);
        if (event != null) {
            event.setTrangThai("Huy");
            eventService.updateSuKien(event);
            response.put("success", true);
            response.put("message", "Đã từ chối sự kiện");
        } else {
            response.put("success", false);
            response.put("message", "Không tìm thấy sự kiện");
        }
        
        return response;
    }

    // API Delete event
    @DeleteMapping("/api/events/{id}")
    @ResponseBody
    public Map<String, Object> deleteEvent(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            eventService.deleteSuKien(id);
            response.put("success", true);
            response.put("message", "Đã xóa sự kiện");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi xóa sự kiện: " + e.getMessage());
        }
        
        return response;
    }

    // API Analytics data
    @GetMapping("/api/analytics")
    @ResponseBody
    public Map<String, Object> getAnalytics() {
        Map<String, Object> data = new HashMap<>();
        
        List<User> allUsers = userService.findAll();
        List<Event> allEvents = eventService.getAllEvents();
        
        data.put("totalUsers", allUsers.size());
        data.put("activeEvents", allEvents.stream()
            .filter(e -> "DangDienRa".equals(e.getTrangThai()))
            .count());
        data.put("pendingEvents", allEvents.stream()
            .filter(e -> "SapDienRa".equals(e.getTrangThai()))
            .count());
        data.put("avgParticipation", 85); // Placeholder - calculate real average
        
        return data;
    }

    // API Save suggestion configuration
    @PostMapping("/api/suggestions/config")
    @ResponseBody
    public Map<String, Object> saveSuggestionConfig(@RequestBody Map<String, Object> config) {
        Map<String, Object> response = new HashMap<>();
        // In real application, save to database
        response.put("success", true);
        response.put("message", "Đã lưu cấu hình gợi ý");
        return response;
    }

    // API Save system settings
    @PostMapping("/api/settings")
    @ResponseBody
    public Map<String, Object> saveSystemSettings(@RequestBody Map<String, String> settings) {
        Map<String, Object> response = new HashMap<>();
        // In real application, save to database
        response.put("success", true);
        response.put("message", "Đã lưu cài đặt hệ thống");
        return response;
    }

    // API Export users
    @GetMapping("/api/users/export")
    public void exportUsers() {
        // Implement CSV export logic
        // This would typically return a file download
    }

    // API Export events
    @GetMapping("/api/events/export")
    public void exportEvents() {
        // Implement CSV export logic
    }

    // API Download report
    @GetMapping("/api/analytics/report")
    public void downloadReport() {
        // Implement report download logic
    }
}