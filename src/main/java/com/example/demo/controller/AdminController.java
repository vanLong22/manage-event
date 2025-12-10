package com.example.demo.controller;

import com.example.demo.model.Event;
import com.example.demo.model.User;
import com.example.demo.service.EventService;
import com.example.demo.service.EventSuggestionService;
import com.example.demo.service.RegistrationService;
import com.example.demo.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
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
    private EventSuggestionService eventSuggestionService;

    @Autowired
    private RegistrationService registrationService;

    @GetMapping("/admin")
    public String showAdminDashboard(Model model, HttpSession session) {
        // Kiểm tra đăng nhập
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            return "redirect:/login";
        }
        
        // Lấy danh sách người dùng
        List<User> allUsers = userService.findAll();
        model.addAttribute("totalUsers", allUsers.size());

        // Lấy danh sách sự kiện
        List<Event> allEvents = eventService.getAllEvents();
        long activeEvents = allEvents.stream()
            .filter(e -> "DangDienRa".equals(e.getTrangThaiThoiGian()))
            .count();
        long pendingEvents = allEvents.stream()
            .filter(e -> "ChoDuyet".equals(e.getTrangThaiPheDuyet()))
            .count();

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
    public Map<String, Object> getDashboardData(HttpSession session) {
        Map<String, Object> data = new HashMap<>();
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            data.put("error", "Unauthorized");
            return data;
        }
        
        List<User> allUsers = userService.findAll();
        List<Event> allEvents = eventService.getAllEvents();
        
        long activeEvents = allEvents.stream()
            .filter(e -> "DangDienRa".equals(e.getTrangThaiThoiGian()))
            .count();
        long pendingEvents = allEvents.stream()
            .filter(e -> "ChoDuyet".equals(e.getTrangThaiPheDuyet()))
            .count();
            
        data.put("totalUsers", allUsers.size());
        data.put("activeEvents", activeEvents);
        data.put("pendingEvents", pendingEvents);
        data.put("violationEvents", 0);
        data.put("notificationCount", 5);
        
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
                eventData.put("trangThai", event.getTrangThaiThoiGian());
                eventData.put("trangThaiPheDuyet", event.getTrangThaiPheDuyet());
                eventData.put("soLuongToiDa", event.getSoLuongToiDa());
                eventData.put("soLuongDaDangKy", event.getSoLuongDaDangKy());
                
                User organizer = userService.findById(event.getNguoiToChucId());
                eventData.put("organizerName", organizer != null ? organizer.getHoTen() : "N/A");
                
                return eventData;
            })
            .collect(Collectors.toList());
        data.put("recentEvents", recentEvents);
        
        return data;
    }

    // Get users với lọc giới tính
    @GetMapping("/api/users")
    @ResponseBody
    public List<Map<String, Object>> getUsers(
            @RequestParam(required = false) String role,
            @RequestParam(required = false) String gender,
            HttpSession session) {
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            return Collections.emptyList();
        }
        
        List<User> allUsers;
        
        // Lọc theo giới tính nếu có
        if (gender != null && !gender.isEmpty()) {
            allUsers = userService.findByGender(gender);
        } else {
            allUsers = userService.findAll();
        }
        
        // Lọc theo vai trò
        if (role != null && !role.isEmpty()) {
            allUsers = allUsers.stream()
                .filter(user -> role.equals(user.getVaiTro()))
                .collect(Collectors.toList());
        }
        
        return allUsers.stream().map(user -> {
            Map<String, Object> userData = new HashMap<>();
            userData.put("nguoiDungId", user.getNguoiDungId());
            userData.put("hoTen", user.getHoTen());
            userData.put("email", user.getEmail());
            userData.put("soDienThoai", user.getSoDienThoai());
            userData.put("vaiTro", user.getVaiTro());
            userData.put("gioiTinh", user.getGioiTinh());
            userData.put("ngayTao", user.getNgayTao());
            userData.put("diaChi", user.getDiaChi());
            userData.put("trangThai", user.getTrangThai());
            return userData;
        }).collect(Collectors.toList());
    }

    // API đăng xuất
    @PostMapping("/api/logout")
    @ResponseBody
    public Map<String, Object> logout(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId != null) {
                userService.logout(userId);
            }
            
            session.invalidate();
            response.put("success", true);
            response.put("message", "Đăng xuất thành công");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi đăng xuất: " + e.getMessage());
        }
        
        return response;
    }

    // API phê duyệt sự kiện (cả từ organizer và joiner)
    @PostMapping("/api/events/{id}/approve")
    @ResponseBody
    public Map<String, Object> approveEvent(@PathVariable Long id, 
                                           @RequestParam(required = false) String source,
                                           @RequestParam(required = false) String reason,
                                           HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            response.put("success", false);
            response.put("message", "Unauthorized");
            return response;
        }
        
        try {
            if ("suggestion".equals(source)) {
                // Phê duyệt đề xuất sự kiện từ joiner
                boolean result = eventSuggestionService.processSuggestion(id, "accept", reason, adminId);
                response.put("success", result);
                response.put("message", result ? "Đã phê duyệt đề xuất sự kiện" : "Lỗi phê duyệt đề xuất");
            } else {
                // Phê duyệt sự kiện từ organizer
                Map<String, Object> result = eventService.processEventApproval(id, "accept", reason, adminId);
                response.putAll(result);
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi phê duyệt: " + e.getMessage());
        }
        
        return response;
    }

    // API từ chối sự kiện
    @PostMapping("/api/events/{id}/reject")
    @ResponseBody
    public Map<String, Object> rejectEvent(@PathVariable Long id,
                                          @RequestParam(required = false) String source,
                                          @RequestParam(required = false) String reason,
                                          HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            response.put("success", false);
            response.put("message", "Unauthorized");
            return response;
        }
        
        try {
            if ("suggestion".equals(source)) {
                // Từ chối đề xuất sự kiện từ joiner
                boolean result = eventSuggestionService.processSuggestion(id, "reject", reason, adminId);
                response.put("success", result);
                response.put("message", result ? "Đã từ chối đề xuất sự kiện" : "Lỗi từ chối đề xuất");
            } else {
                // Từ chối sự kiện từ organizer
                Map<String, Object> result = eventService.processEventApproval(id, "reject", reason, adminId);
                response.putAll(result);
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi từ chối: " + e.getMessage());
        }
        
        return response;
    }

    // Các API khác giữ nguyên...
    @GetMapping("/api/users/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getUser(@PathVariable Long id, HttpSession session) {
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            return ResponseEntity.status(401).build();
        }
        
        User user = userService.findById(id);
        if (user != null) {
            Map<String, Object> userData = new HashMap<>();
            userData.put("nguoiDungId", user.getNguoiDungId());
            userData.put("hoTen", user.getHoTen());
            userData.put("email", user.getEmail());
            userData.put("soDienThoai", user.getSoDienThoai());
            userData.put("vaiTro", user.getVaiTro());
            userData.put("gioiTinh", user.getGioiTinh());
            userData.put("ngayTao", user.getNgayTao());
            userData.put("diaChi", user.getDiaChi());
            userData.put("trangThai", user.getTrangThai());
            return ResponseEntity.ok(userData);
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/api/events")
    @ResponseBody
    public List<Map<String, Object>> getEvents(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String type,
            HttpSession session) {
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            return Collections.emptyList();
        }
        
        List<Event> allEvents = eventService.getAllEvents();
        Date now = new Date();
        
        if (status != null && !status.isEmpty()) {
            switch (status) {
                case "SapDienRa":
                    allEvents = allEvents.stream()
                        .filter(event -> {
                            Date startDate = event.getThoiGianBatDau();
                            return startDate.after(now) && !"Huy".equals(event.getTrangThaiThoiGian());
                        })
                        .collect(Collectors.toList());
                    break;
                    
                case "DangDienRa":
                    allEvents = allEvents.stream()
                        .filter(event -> {
                            Date startDate = event.getThoiGianBatDau();
                            Date endDate = event.getThoiGianKetThuc();
                            return (startDate.before(now) || startDate.equals(now)) &&
                                (endDate.after(now) || endDate.equals(now)) &&
                                !"Huy".equals(event.getTrangThaiThoiGian());
                        })
                        .collect(Collectors.toList());
                    break;
                    
                case "DaKetThuc":
                    allEvents = allEvents.stream()
                        .filter(event -> {
                            Date endDate = event.getThoiGianKetThuc();
                            return endDate.before(now) && !"Huy".equals(event.getTrangThaiThoiGian());
                        })
                        .collect(Collectors.toList());
                    break;
                    
                case "Huy":
                    allEvents = allEvents.stream()
                        .filter(event -> "Huy".equals(event.getTrangThaiThoiGian()))
                        .collect(Collectors.toList());
                    break;
            }
        }
        
        if (type != null && !type.isEmpty()) {
            allEvents = allEvents.stream()
                .filter(event -> type.equals(event.getLoaiSuKien()))
                .collect(Collectors.toList());
        }
        
        return allEvents.stream().map(event -> {
            Map<String, Object> eventData = new HashMap<>();
            eventData.put("suKienId", event.getSuKienId());
            eventData.put("tenSuKien", event.getTenSuKien());
            eventData.put("moTa", event.getMoTa());
            eventData.put("thoiGianBatDau", event.getThoiGianBatDau());
            eventData.put("thoiGianKetThuc", event.getThoiGianKetThuc());
            eventData.put("diaDiem", event.getDiaDiem());
            eventData.put("loaiSuKien", event.getLoaiSuKien());
            eventData.put("trangThaiPheDuyet", event.getTrangThaiPheDuyet());
            eventData.put("soLuongToiDa", event.getSoLuongToiDa());
            eventData.put("soLuongDaDangKy", event.getSoLuongDaDangKy());
            eventData.put("nguoiToChucId", event.getNguoiToChucId());
            
            String realTimeStatus = calculateRealTimeStatus(event, now);
            eventData.put("realTimeStatus", realTimeStatus);
            eventData.put("needsStatusUpdate", !realTimeStatus.equals(event.getTrangThaiThoiGian()));
            
            User organizer = userService.findById(event.getNguoiToChucId());
            eventData.put("organizerName", organizer != null ? organizer.getHoTen() : "N/A");
            
            return eventData;
        }).collect(Collectors.toList());
    }

    private String calculateRealTimeStatus(Event event, Date now) {
        if ("Huy".equals(event.getTrangThaiThoiGian())) {
            return "Huy";
        }
        
        Date startDate = event.getThoiGianBatDau();
        Date endDate = event.getThoiGianKetThuc();
        
        if ((startDate.before(now) || startDate.equals(now)) && 
            (endDate.after(now) || endDate.equals(now))) {
            return "DangDienRa";
        }
        
        if (endDate.before(now)) {
            return "DaKetThuc";
        }
        
        if (startDate.after(now)) {
            return "SapDienRa";
        }
        
        return event.getTrangThaiThoiGian();
    }

    @PostMapping("/api/events/{id}/sync-status")
    @ResponseBody
    public Map<String, Object> syncEventStatus(@PathVariable Long id, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            response.put("success", false);
            response.put("message", "Unauthorized");
            return response;
        }
        
        try {
            Event event = eventService.getEventById(id);
            if (event != null) {
                Date now = new Date();
                String realTimeStatus = calculateRealTimeStatus(event, now);
                
                if (!realTimeStatus.equals(event.getTrangThaiThoiGian())) {
                    event.setTrangThaiThoiGian(realTimeStatus);
                    eventService.updateSuKien(event);
                    response.put("success", true);
                    response.put("message", "Đã đồng bộ trạng thái sự kiện: " + realTimeStatus);
                    response.put("newStatus", realTimeStatus);
                } else {
                    response.put("success", true);
                    response.put("message", "Trạng thái sự kiện đã được cập nhật");
                    response.put("newStatus", realTimeStatus);
                }
            } else {
                response.put("success", false);
                response.put("message", "Không tìm thấy sự kiện");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi đồng bộ trạng thái: " + e.getMessage());
        }
        
        return response;
    }

    @GetMapping("/api/events/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getEvent(@PathVariable Long id, HttpSession session) {
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            return ResponseEntity.status(401).build();
        }
        
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
            eventData.put("trangThai", event.getTrangThaiThoiGian());
            eventData.put("trangThaiPheDuyet", event.getTrangThaiPheDuyet());
            eventData.put("soLuongToiDa", event.getSoLuongToiDa());
            eventData.put("soLuongDaDangKy", event.getSoLuongDaDangKy());
            eventData.put("nguoiToChucId", event.getNguoiToChucId());
            
            User organizer = userService.findById(event.getNguoiToChucId());
            eventData.put("organizerName", organizer != null ? organizer.getHoTen() : "N/A");
            
            return ResponseEntity.ok(eventData);
        }
        return ResponseEntity.notFound().build();
    }

    // Thêm vào AdminController
    @GetMapping("/api/suggestions/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getSuggestion(@PathVariable Long id, HttpSession session) {
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            return ResponseEntity.status(401).build();
        }
        
        try {
            // Lấy chi tiết đề xuất từ service
            Map<String, Object> suggestionDetail = eventSuggestionService.getSuggestionDetail(id);
            
            if (suggestionDetail == null) {
                return ResponseEntity.notFound().build();
            }
            
            return ResponseEntity.ok(suggestionDetail);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }

    @DeleteMapping("/api/events/{id}")
    @ResponseBody
    public Map<String, Object> deleteEvent(@PathVariable Long id, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            response.put("success", false);
            response.put("message", "Unauthorized");
            return response;
        }
        
        try {
            Event eventToDelete = eventService.getEventById(id);
            if (eventToDelete != null) {
                eventService.deleteSuKien(id);
                response.put("success", true);
                response.put("message", "Đã xóa sự kiện thành công");
                response.put("deletedEventId", id);
                response.put("eventStatus", eventToDelete.getTrangThaiThoiGian());
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

    @GetMapping("/api/events/recent-replacement")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getRecentReplacementEvent(HttpSession session) {
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            return ResponseEntity.status(401).build();
        }
        
        try {
            List<Event> allEvents = eventService.getAllEvents();
            
            List<Event> availableEvents = allEvents.stream()
                .filter(event -> !"Huy".equals(event.getTrangThaiThoiGian()))
                .sorted((e1, e2) -> e2.getThoiGianBatDau().compareTo(e1.getThoiGianBatDau()))
                .collect(Collectors.toList());
            
            Event replacementEvent = null;
            if (availableEvents.size() > 3) {
                replacementEvent = availableEvents.get(3);
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
                eventData.put("trangThai", replacementEvent.getTrangThaiThoiGian());
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

    @PutMapping("/api/events/{id}")
    @ResponseBody
    public Map<String, Object> updateEvent(@PathVariable Long id, @RequestBody Map<String, Object> eventData, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            response.put("success", false);
            response.put("message", "Unauthorized");
            return response;
        }
        
        try {
            Event existingEvent = eventService.getEventById(id);
            if (existingEvent != null) {
                boolean hasChanges = false;
                
                // Chỉ cập nhật các trường có trong request
                if (eventData.containsKey("tenSuKien")) {
                    String newName = (String) eventData.get("tenSuKien");
                    if (!newName.equals(existingEvent.getTenSuKien())) {
                        existingEvent.setTenSuKien(newName);
                        hasChanges = true;
                    }
                }
                
                if (eventData.containsKey("moTa")) {
                    String newDescription = (String) eventData.get("moTa");
                    if (newDescription != null && !newDescription.equals(existingEvent.getMoTa())) {
                        existingEvent.setMoTa(newDescription);
                        hasChanges = true;
                    }
                }
                
                if (eventData.containsKey("thoiGianBatDau")) {
                    String startTimeStr = (String) eventData.get("thoiGianBatDau");
                    startTimeStr = startTimeStr.replace("T", " ") + ":00";
                    Date newStartTime = java.sql.Timestamp.valueOf(startTimeStr);
                    if (!newStartTime.equals(existingEvent.getThoiGianBatDau())) {
                        existingEvent.setThoiGianBatDau(newStartTime);
                        hasChanges = true;
                    }
                }
                
                if (eventData.containsKey("thoiGianKetThuc")) {
                    String endTimeStr = (String) eventData.get("thoiGianKetThuc");
                    endTimeStr = endTimeStr.replace("T", " ") + ":00";
                    Date newEndTime = java.sql.Timestamp.valueOf(endTimeStr);
                    if (!newEndTime.equals(existingEvent.getThoiGianKetThuc())) {
                        existingEvent.setThoiGianKetThuc(newEndTime);
                        hasChanges = true;
                    }
                }
                
                if (eventData.containsKey("diaDiem")) {
                    String newLocation = (String) eventData.get("diaDiem");
                    if (!newLocation.equals(existingEvent.getDiaDiem())) {
                        existingEvent.setDiaDiem(newLocation);
                        hasChanges = true;
                    }
                }
                
                if (eventData.containsKey("trangThai")) {
                    String newStatus = (String) eventData.get("trangThai");
                    if (!newStatus.equals(existingEvent.getTrangThaiThoiGian())) {
                        existingEvent.setTrangThaiThoiGian(newStatus);
                        hasChanges = true;
                    }
                }
                
                if (eventData.containsKey("soLuongToiDa")) {
                    Integer newMaxAttendees = Integer.parseInt(eventData.get("soLuongToiDa").toString());
                    if (!newMaxAttendees.equals(existingEvent.getSoLuongToiDa())) {
                        existingEvent.setSoLuongToiDa(newMaxAttendees);
                        hasChanges = true;
                    }
                }
                
                if (hasChanges) {
                    eventService.updateSuKien(existingEvent);
                    response.put("success", true);
                    response.put("message", "Đã cập nhật sự kiện thành công");
                    response.put("event", existingEvent);
                } else {
                    response.put("success", true);
                    response.put("message", "Không có thay đổi nào để cập nhật");
                }
            } else {
                response.put("success", false);
                response.put("message", "Không tìm thấy sự kiện");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi cập nhật sự kiện: " + e.getMessage());
        }
        
        return response;
    }
    
    @PostMapping("/api/users/{id}/status")
    @ResponseBody
    public Map<String, Object> updateUserStatus(@PathVariable Long id, @RequestBody Map<String, String> request, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            response.put("success", false);
            response.put("message", "Unauthorized");
            return response;
        }
        
        try {
            String action = request.get("action");
            User user = userService.findById(id);
            
            if (user != null) {
                if ("lock".equals(action)) {
                    user.setTrangThai(0);
                    userService.update(user);
                    response.put("success", true);
                    response.put("message", "Đã khóa tài khoản thành công");
                } else if ("unlock".equals(action)) {
                    user.setTrangThai(1);
                    userService.update(user);
                    response.put("success", true);
                    response.put("message", "Đã mở khóa tài khoản thành công");
                } else {
                    response.put("success", false);
                    response.put("message", "Hành động không hợp lệ");
                }
            } else {
                response.put("success", false);
                response.put("message", "Không tìm thấy người dùng");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi cập nhật trạng thái: " + e.getMessage());
        }
        
        return response;
    }
    
    // Các API khác...
    @GetMapping("/api/analytics/stats")
    public ResponseEntity<Map<String, Object>> getStats(@RequestParam(defaultValue = "month") String period, HttpSession session) {
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            return ResponseEntity.status(401).build();
        }
        
        Map<String, Object> stats = new HashMap<>();
        
        List<User> allUsers = userService.findAll();
        List<Event> allEvents = eventService.getAllEvents();
        
        stats.put("totalUsers", allUsers.size());
        stats.put("activeEvents", allEvents.stream()
            .filter(e -> "DangDienRa".equals(e.getTrangThaiThoiGian()))
            .count());
        stats.put("pendingEvents", allEvents.stream()
            .filter(e -> "ChoDuyet".equals(e.getTrangThaiPheDuyet()))
            .count());
        stats.put("avgParticipation", 85);

        // Các biểu đồ...
        List<Map<String, Object>> eventsByTypeData = eventService.countEventsByType();
        stats.put("eventsByTypeChart", generateChart("events_by_type", eventsByTypeData));

        List<Map<String, Object>> usersByRoleData = userService.getUsersByRole();
        stats.put("usersByRoleChart", generateChart("users_by_role", usersByRoleData));

        List<Map<String, Object>> genderData = userService.getGenderDistribution();
        stats.put("genderPieChart", generateChart("gender_pie", genderData));

        List<Map<String, Object>> requestStatusData = registrationService.getRequestStatusDistribution();
        stats.put("requestStatusPieChart", generateChart("request_status_pie", requestStatusData));

        List<Map<String, Object>> registrationsLineData = registrationService.getRegistrationsOverTime(period);
        stats.put("registrationsLineChart", generateChart("registrations_line", registrationsLineData));

        return ResponseEntity.ok(stats);
    }

    private String generateChart(String chartType, List<Map<String, Object>> data) {
        // Giữ nguyên phương thức generateChart
        try {
            ProcessBuilder pb = new ProcessBuilder("python", "D:/2022-2026/HOC KI 7/XD HTTT/quanLySuKien/demo/src/main/resources/scripts/chart.py", chartType);
            pb.redirectErrorStream(true);
            Process p = pb.start();

            try (OutputStream os = p.getOutputStream()) {
                ObjectMapper mapper = new ObjectMapper();
                os.write(mapper.writeValueAsBytes(data));
                os.flush();
            }

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            try (InputStream is = p.getInputStream()) {
                byte[] buffer = new byte[16384];
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    baos.write(buffer, 0, bytesRead);
                }
            }

            int exitCode = p.waitFor();
            String base64 = baos.toString("UTF-8").trim();

            if (exitCode != 0 || base64.length() < 10000) {
                System.err.println("Python error: " + base64);
                return null;
            }

            return base64;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @PostMapping("/api/suggestions/config")
    @ResponseBody
    public Map<String, Object> saveSuggestionConfig(@RequestBody Map<String, Object> config, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            response.put("success", false);
            response.put("message", "Unauthorized");
            return response;
        }
        
        response.put("success", true);
        response.put("message", "Đã lưu cấu hình gợi ý");
        return response;
    }

    @PostMapping("/api/settings")
    @ResponseBody
    public Map<String, Object> saveSystemSettings(@RequestBody Map<String, String> settings, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            response.put("success", false);
            response.put("message", "Unauthorized");
            return response;
        }
        
        response.put("success", true);
        response.put("message", "Đã lưu cài đặt hệ thống");
        return response;
    }

    @GetMapping("/api/users/export")
    public void exportUsers(HttpSession session) {
        // Implement CSV export logic
    }

    @GetMapping("/api/events/export")
    public void exportEvents(HttpSession session) {
        // Implement CSV export logic
    }

    @GetMapping("/api/analytics/report")
    public void downloadReport(HttpSession session) {
        // Implement report download logic
    }

    // API lấy sự kiện chờ duyệt với lọc
    @GetMapping("/api/events/pending")
    @ResponseBody
    public Map<String, Object> getPendingEvents(
            @RequestParam(required = false) String source,
            @RequestParam(required = false) String status,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            response.put("error", "Unauthorized");
            return response;
        }
        
        try {
            List<Map<String, Object>> organizerEventsList = new ArrayList<>();
            List<Map<String, Object>> suggestionEventsList = new ArrayList<>();
            
            // Lấy sự kiện từ organizer nếu source là "organizer" hoặc không có source
            if (source == null || source.isEmpty() || "organizer".equals(source)) {
                // Lấy tất cả sự kiện từ organizer
                List<Event> organizerEvents = eventService.getAllEvents();
                
                // Lọc theo trạng thái nếu có
                if (status != null && !status.isEmpty()) {
                    organizerEvents = organizerEvents.stream()
                        .filter(event -> {
                            String eventStatus = event.getTrangThaiPheDuyet();
                            if ("CHO_DUYET".equals(status)) {
                                return "ChoDuyet".equals(eventStatus);
                            }
                            return status.equals(eventStatus);
                        })
                        .collect(Collectors.toList());
                } else {
                    // Mặc định chỉ lấy sự kiện chờ duyệt
                    organizerEvents = organizerEvents.stream()
                        .filter(event -> "ChoDuyet".equals(event.getTrangThaiPheDuyet()))
                        .collect(Collectors.toList());
                }
                
                // Chuyển đổi sang Map
                organizerEventsList = organizerEvents.stream().map(event -> {
                    Map<String, Object> eventData = new HashMap<>();
                    eventData.put("suKienId", event.getSuKienId());
                    eventData.put("tenSuKien", event.getTenSuKien());
                    eventData.put("moTa", event.getMoTa());
                    eventData.put("thoiGianBatDau", event.getThoiGianBatDau());
                    eventData.put("thoiGianKetThuc", event.getThoiGianKetThuc());
                    eventData.put("diaDiem", event.getDiaDiem());
                    eventData.put("loaiSuKien", event.getLoaiSuKien());
                    eventData.put("trangThai", event.getTrangThaiPheDuyet());
                    eventData.put("soLuongToiDa", event.getSoLuongToiDa());
                    eventData.put("soLuongDaDangKy", event.getSoLuongDaDangKy());
                    eventData.put("nguoiToChucId", event.getNguoiToChucId());
                    eventData.put("source", "organizer");
                    
                    User organizer = userService.findById(event.getNguoiToChucId());
                    eventData.put("organizerName", organizer != null ? organizer.getHoTen() : "N/A");
                    
                    return eventData;
                }).collect(Collectors.toList());
            }
            
            // Lấy sự kiện từ suggestion nếu source là "suggestion" hoặc không có source
            if (source == null || source.isEmpty() || "suggestion".equals(source)) {
                // Xác định trạng thái lọc cho suggestion
                String suggestionStatus = null;
                if (status != null && !status.isEmpty()) {
                    if ("ChoDuyet".equals(status)) {
                        suggestionStatus = "ChoDuyet";
                    } else if ("DaDuyet".equals(status)) {
                        suggestionStatus = "DaDuyet";
                    } else if ("TuChoi".equals(status)) {
                        suggestionStatus = "TuChoi";
                    }
                }
                
                // Lấy suggestion events với bộ lọc
                List<Map<String, Object>> suggestionEvents = eventSuggestionService.getSuggestionsWithFilters(
                    null, null, null, suggestionStatus);
                
                // Chuyển đổi sang định dạng thống nhất
                suggestionEventsList = suggestionEvents.stream().map(suggestion -> {
                    Map<String, Object> eventData = new HashMap<>();
                    eventData.put("suKienId", suggestion.get("dangSuKienId"));
                    eventData.put("tieuDe", suggestion.get("tieuDe"));
                    eventData.put("moTaNhuCau", suggestion.get("moTaNhuCau"));
                    eventData.put("thoiGianDuKien", suggestion.get("thoiGianDuKien"));
                    eventData.put("diaDiem", suggestion.get("diaDiem"));
                    eventData.put("soLuongKhach", suggestion.get("soLuongKhach"));
                    eventData.put("trangThai", suggestion.get("trangThai"));
                    eventData.put("source", "suggestion");
                    
                    // Thông tin user
                    Map<String, Object> userInfo = (Map<String, Object>) suggestion.get("user");
                    if (userInfo != null) {
                        eventData.put("joinerName", userInfo.get("hoTen"));
                        eventData.put("joinerEmail", userInfo.get("email"));
                        eventData.put("joinerPhone", userInfo.get("soDienThoai"));
                    }
                    
                    return eventData;
                }).collect(Collectors.toList());
            }
            
            response.put("organizerEvents", organizerEventsList);
            response.put("suggestionEvents", suggestionEventsList);
            response.put("total", organizerEventsList.size() + suggestionEventsList.size());
            
        } catch (Exception e) {
            response.put("error", "Lỗi lấy dữ liệu: " + e.getMessage());
            e.printStackTrace();
        }
        
        return response;
    }

    // Thêm vào AdminController
    @PostMapping("/api/suggestions/{id}/approve")
    @ResponseBody
    public Map<String, Object> approveSuggestion(@PathVariable Long id, 
                                                @RequestBody Map<String, String> request,
                                                HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            response.put("success", false);
            response.put("message", "Unauthorized");
            return response;
        }
        
        try {
            String reason = request.get("reason");
            boolean result = eventSuggestionService.processSuggestion(id, "accept", reason, adminId);
            response.put("success", result);
            response.put("message", result ? "Đã phê duyệt đề xuất sự kiện" : "Lỗi phê duyệt đề xuất");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi phê duyệt: " + e.getMessage());
            e.printStackTrace();
        }
        
        return response;
    }

    @PostMapping("/api/suggestions/{id}/reject")
    @ResponseBody
    public Map<String, Object> rejectSuggestion(@PathVariable Long id, 
                                            @RequestBody Map<String, String> request,
                                            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        Long adminId = (Long) session.getAttribute("userId");
        if (adminId == null) {
            response.put("success", false);
            response.put("message", "Unauthorized");
            return response;
        }
        
        try {
            String reason = request.get("reason");
            boolean result = eventSuggestionService.processSuggestion(id, "reject", reason, adminId);
            response.put("success", result);
            response.put("message", result ? "Đã từ chối đề xuất sự kiện" : "Lỗi từ chối đề xuất");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi từ chối: " + e.getMessage());
            e.printStackTrace();
        }
        
        return response;
    }


}