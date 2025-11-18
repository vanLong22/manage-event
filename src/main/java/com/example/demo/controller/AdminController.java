package com.example.demo.controller;

import com.example.demo.model.Event;
import com.example.demo.model.Registration;
import com.example.demo.model.User;
import com.example.demo.service.EventService;
import com.example.demo.service.RegistrationService;
import com.example.demo.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Collections;
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

    @Autowired
    private RegistrationService registrationService;

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
        model.addAttribute("violationEvents", 0);
        model.addAttribute("notificationCount", 5);

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
        
        // Recent events (last 3) với thông tin người tổ chức
        List<Map<String, Object>> recentEvents = allEvents.stream()
            .limit(4)
            .map(event -> {
                Map<String, Object> eventData = new HashMap<>();
                eventData.put("suKienId", event.getSuKienId());
                eventData.put("tenSuKien", event.getTenSuKien());
                eventData.put("moTa", event.getMoTa());
                eventData.put("thoiGianBatDau", event.getThoiGianBatDau());
                eventData.put("thoiGianKetThuc", event.getThoiGianKetThuc());
                eventData.put("diaDiem", event.getDiaDiem());
                eventData.put("loaiSuKien", event.getLoaiSuKien());
                eventData.put("trangThai", event.getTrangThai());
                eventData.put("soLuongToiDa", event.getSoLuongToiDa());
                eventData.put("soLuongDaDangKy", event.getSoLuongDaDangKy());
                
                // Lấy thông tin người tổ chức
                User organizer = userService.findById(event.getNguoiToChucId());
                eventData.put("organizerName", organizer != null ? organizer.getHoTen() : "N/A");
                
                return eventData;
            })
            .collect(Collectors.toList());
        data.put("recentEvents", recentEvents);
        
        return data;
    }

    // Get users with filtering
    @GetMapping("/api/users")
    @ResponseBody
    public List<Map<String, Object>> getUsers(
            @RequestParam(required = false) String role,
            @RequestParam(required = false) String status) {
        
        List<User> allUsers = userService.findAll();
        
        // Filter by role
        if (role != null && !role.isEmpty()) {
            allUsers = allUsers.stream()
                .filter(user -> role.equals(user.getVaiTro()))
                .collect(Collectors.toList());
        }
        
        // Map users to include status (giả sử status được lưu trong User)
        return allUsers.stream().map(user -> {
            Map<String, Object> userData = new HashMap<>();
            userData.put("nguoiDungId", user.getNguoiDungId());
            userData.put("hoTen", user.getHoTen());
            userData.put("email", user.getEmail());
            userData.put("soDienThoai", user.getSoDienThoai());
            userData.put("vaiTro", user.getVaiTro());
            userData.put("ngayTao", user.getNgayTao());
            userData.put("diaChi", user.getDiaChi());
            return userData;
        }).collect(Collectors.toList());
    }

    // Get user by ID
    @GetMapping("/api/users/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getUser(@PathVariable Long id) {
        User user = userService.findById(id);
        if (user != null) {
            Map<String, Object> userData = new HashMap<>();
            userData.put("nguoiDungId", user.getNguoiDungId());
            userData.put("hoTen", user.getHoTen());
            userData.put("email", user.getEmail());
            userData.put("soDienThoai", user.getSoDienThoai());
            userData.put("vaiTro", user.getVaiTro());
            userData.put("ngayTao", user.getNgayTao());
            userData.put("diaChi", user.getDiaChi());
            return ResponseEntity.ok(userData);
        }
        return ResponseEntity.notFound().build();
    }

    // Get events with filtering
    @GetMapping("/api/events")
    @ResponseBody
    public List<Map<String, Object>> getEvents(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String type) {
        
        List<Event> allEvents = eventService.getAllEvents();
        
        // Filter by status
        if (status != null && !status.isEmpty()) {
            allEvents = allEvents.stream()
                .filter(event -> status.equals(event.getTrangThai()))
                .collect(Collectors.toList());
        }
        
        // Filter by type
        if (type != null && !type.isEmpty()) {
            allEvents = allEvents.stream()
                .filter(event -> type.equals(event.getLoaiSuKien()))
                .collect(Collectors.toList());
        }
        
        // Map events to include organizer name
        return allEvents.stream().map(event -> {
            Map<String, Object> eventData = new HashMap<>();
            eventData.put("suKienId", event.getSuKienId());
            eventData.put("tenSuKien", event.getTenSuKien());
            eventData.put("moTa", event.getMoTa());
            eventData.put("thoiGianBatDau", event.getThoiGianBatDau());
            eventData.put("thoiGianKetThuc", event.getThoiGianKetThuc());
            eventData.put("diaDiem", event.getDiaDiem());
            eventData.put("loaiSuKien", event.getLoaiSuKien());
            eventData.put("trangThai", event.getTrangThai());
            eventData.put("soLuongToiDa", event.getSoLuongToiDa());
            eventData.put("soLuongDaDangKy", event.getSoLuongDaDangKy());
            eventData.put("nguoiToChucId", event.getNguoiToChucId());
            
            // Lấy thông tin người tổ chức
            User organizer = userService.findById(event.getNguoiToChucId());
            eventData.put("organizerName", organizer != null ? organizer.getHoTen() : "N/A");
            
            return eventData;
        }).collect(Collectors.toList());
    }

    // Get pending events
    @GetMapping("/api/events/pending")
    @ResponseBody
    public List<Map<String, Object>> getPendingEvents() {
        List<Event> allEvents = eventService.getAllEvents();
        List<Event> pendingEvents = allEvents.stream()
            .filter(event -> "SapDienRa".equals(event.getTrangThai()))
            .collect(Collectors.toList());
        
        return pendingEvents.stream().map(event -> {
            Map<String, Object> eventData = new HashMap<>();
            eventData.put("suKienId", event.getSuKienId());
            eventData.put("tenSuKien", event.getTenSuKien());
            eventData.put("moTa", event.getMoTa());
            eventData.put("thoiGianBatDau", event.getThoiGianBatDau());
            eventData.put("thoiGianKetThuc", event.getThoiGianKetThuc());
            eventData.put("diaDiem", event.getDiaDiem());
            eventData.put("loaiSuKien", event.getLoaiSuKien());
            eventData.put("trangThai", event.getTrangThai());
            eventData.put("soLuongToiDa", event.getSoLuongToiDa());
            eventData.put("soLuongDaDangKy", event.getSoLuongDaDangKy());
            eventData.put("nguoiToChucId", event.getNguoiToChucId());
            
            User organizer = userService.findById(event.getNguoiToChucId());
            eventData.put("organizerName", organizer != null ? organizer.getHoTen() : "N/A");
            
            return eventData;
        }).collect(Collectors.toList());
    }

    // Get event by ID
    @GetMapping("/api/events/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getEvent(@PathVariable Long id) {
        Event event = eventService.getEventById(id);
        if (event != null) {
            Map<String, Object> eventData = new HashMap<>();
            eventData.put("suKienId", event.getSuKienId());
            eventData.put("tenSuKien", event.getTenSuKien());
            eventData.put("moTa", event.getMoTa());
            eventData.put("thoiGianBatDau", event.getThoiGianBatDau());
            eventData.put("thoiGianKetThuc", event.getThoiGianKetThuc());
            eventData.put("diaDiem", event.getDiaDiem());
            eventData.put("loaiSuKien", event.getLoaiSuKien());
            eventData.put("trangThai", event.getTrangThai());
            eventData.put("soLuongToiDa", event.getSoLuongToiDa());
            eventData.put("soLuongDaDangKy", event.getSoLuongDaDangKy());
            eventData.put("nguoiToChucId", event.getNguoiToChucId());
            
            // Lấy thông tin người tổ chức
            User organizer = userService.findById(event.getNguoiToChucId());
            eventData.put("organizerName", organizer != null ? organizer.getHoTen() : "N/A");
            
            return ResponseEntity.ok(eventData);
        }
        return ResponseEntity.notFound().build();
    }

    // Các phương thức còn lại giữ nguyên...
    // ... (approveEvent, rejectEvent, deleteEvent, getAnalytics, etc.)
    
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
        
        try {
            System.out.println("=== REJECT EVENT DEBUG ===");
            System.out.println("Event ID: " + id);
            
            Event event = eventService.getEventById(id);
            System.out.println("Event found: " + (event != null));
            
            if (event != null) {
                System.out.println("Current status: " + event.getTrangThai());
                System.out.println("Event name: " + event.getTenSuKien());
                
                event.setTrangThai("Huy");
                System.out.println("New status: " + event.getTrangThai());
                
                //update trạng thái sự kiện là từ chối
                eventService.updateSuKien(event);
                System.out.println("Update successful");
                
                response.put("success", true);
                response.put("message", "Đã từ chối sự kiện");
            } else {
                System.out.println("Event not found");
                response.put("success", false);
                response.put("message", "Không tìm thấy sự kiện");
            }
            
        } catch (Exception e) {
            System.err.println("ERROR in rejectEvent:");
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi server: " + e.getMessage());
        }
        
        return response;
    }

    // API xóa sự kiện 
    @DeleteMapping("/api/events/{id}")
    @ResponseBody
    public Map<String, Object> deleteEvent(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Event eventToDelete = eventService.getEventById(id);
            if (eventToDelete != null) {
                eventService.deleteSuKien(id);
                response.put("success", true);
                response.put("message", "Đã xóa sự kiện thành công");
                response.put("deletedEventId", id);
                response.put("eventStatus", eventToDelete.getTrangThai());
            } else {
                response.put("success", false);
                response.put("message", "Không tìm thấy sự kiện");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi xóa sự kiện: " + e.getMessage());
        }
        
        return response;
    }

    // API để lấy sự kiện thay thế khi xóa sự kiện gần đây
    @GetMapping("/api/events/recent-replacement")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getRecentReplacementEvent() {
        try {
            List<Event> allEvents = eventService.getAllEvents();
            
            // Lọc các sự kiện có trạng thái phù hợp và sắp xếp theo thời gian mới nhất
            List<Event> availableEvents = allEvents.stream()
                .filter(event -> !"Huy".equals(event.getTrangThai())) // Loại bỏ sự kiện đã hủy
                .sorted((e1, e2) -> e2.getThoiGianBatDau().compareTo(e1.getThoiGianBatDau())) // Sắp xếp mới nhất đầu tiên
                .collect(Collectors.toList());
            
            // Bỏ qua 3 sự kiện đầu tiên (đã hiển thị) và lấy sự kiện tiếp theo
            Event replacementEvent = null;
            if (availableEvents.size() > 3) {
                replacementEvent = availableEvents.get(3); // Sự kiện thứ 4
            }
            
            if (replacementEvent != null) {
                Map<String, Object> eventData = new HashMap<>();
                eventData.put("suKienId", replacementEvent.getSuKienId());
                eventData.put("tenSuKien", replacementEvent.getTenSuKien());
                eventData.put("moTa", replacementEvent.getMoTa());
                eventData.put("thoiGianBatDau", replacementEvent.getThoiGianBatDau());
                eventData.put("thoiGianKetThuc", replacementEvent.getThoiGianKetThuc());
                eventData.put("diaDiem", replacementEvent.getDiaDiem());
                eventData.put("loaiSuKien", replacementEvent.getLoaiSuKien());
                eventData.put("trangThai", replacementEvent.getTrangThai());
                eventData.put("soLuongToiDa", replacementEvent.getSoLuongToiDa());
                eventData.put("soLuongDaDangKy", replacementEvent.getSoLuongDaDangKy());
                
                User organizer = userService.findById(replacementEvent.getNguoiToChucId());
                eventData.put("organizerName", organizer != null ? organizer.getHoTen() : "N/A");
                
                return ResponseEntity.ok(eventData);
            }
            
            return ResponseEntity.ok(Collections.emptyMap());
            
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(Collections.emptyMap());
        }
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
        data.put("avgParticipation", 85); // Placeholder - calculate real average (tỷ lệ tham gia trung bình)
        
        // Lấy dữ liệu cho charts
        List<Event> events = eventService.getAllEvents(); // Dữ liệu sự kiện
        List<Registration> registrations = registrationService.getAllRegistrations(); // Dữ liệu đăng ký (giả định service tồn tại)
        List<Event> popularEvents = eventService.getPopularEvents(5); // Giả định method get popular events (top 5 by soLuongDaDangKy)

        // Generate charts và thêm vào data
        data.put("eventsByStatusChart", generateChart("events_by_status", events));
        data.put("registrationsByEventChart", generateChart("registrations_by_event", popularEvents));
        data.put("registrationsOverTimeChart", generateChart("registrations_over_time", registrations));

        return data;
    }

    // Method mới: Generate chart base64 (copy và điều chỉnh từ mã cũ)
    private String generateChart(String chartType, List<?> data) {
        try {
            // Đường dẫn relative đến script Python (dễ deploy hơn absolute path)
            String scriptPath = "src/main/resources/scripts/chart.py"; // Thay nếu khác
            ProcessBuilder pb = new ProcessBuilder("python", scriptPath, chartType);
            Process p = pb.start();

            // Gửi JSON data qua stdin
            try (OutputStream os = p.getOutputStream()) {
                ObjectMapper mapper = new ObjectMapper();
                os.write(mapper.writeValueAsBytes(data));
                os.flush();
            }

            // Đọc stdout (base64)
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            try (InputStream is = p.getInputStream()) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    baos.write(buffer, 0, bytesRead);
                }
            }

            // Đọc stderr cho debug
            ByteArrayOutputStream errorBaos = new ByteArrayOutputStream();
            try (InputStream errorIs = p.getErrorStream()) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = errorIs.read(buffer)) != -1) {
                    errorBaos.write(buffer, 0, bytesRead);
                }
            }
            String errorOutput = errorBaos.toString("UTF-8").trim();
            if (!errorOutput.isEmpty()) {
                System.out.println("Python stderr: " + errorOutput);
            }

            int exitCode = p.waitFor();
            String result = baos.toString("UTF-8").trim();

            // Debug log
            System.out.println("=== CHART DEBUG ===");
            System.out.println("Chart type: " + chartType);
            System.out.println("Exit code: " + exitCode);
            System.out.println("Output length: " + result.length() + " chars");
            System.out.println("===================");

            if (exitCode != 0 || result.isEmpty() || result.length() < 5000) {
                System.err.println("Python failed or base64 too short for chart: " + chartType);
                return null; // Fallback: null nếu fail
            }

            return result;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
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