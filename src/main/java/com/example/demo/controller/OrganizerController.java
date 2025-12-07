package com.example.demo.controller;

import com.example.demo.model.Event;
import com.example.demo.model.LoaiSuKien;
import com.example.demo.model.Registration;
import com.example.demo.model.User;
import com.example.demo.service.EventService;
import com.example.demo.service.EventSuggestionService;
import com.example.demo.service.LoaiSuKienService;
import com.example.demo.service.RegistrationService;
import com.example.demo.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.io.*;

@Controller
@RequestMapping("/organizer")
public class OrganizerController {

    @Autowired
    private EventService eventService;

    @Autowired
    private UserService userService;

    @Autowired
    private RegistrationService registrationService;

    @Autowired
    private LoaiSuKienService loaiSuKienService;

    @Autowired
    private EventSuggestionService eventSuggestionService;

    //@Autowired
    //private FileStorageService fileStorageService; // Để handle upload anhBia

    // Trang chính organizer
    @GetMapping("/organizer/organize")
    public String dashboard(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        User user = userService.findById(userId);
        if (user == null || !"ToChuc".equals(user.getVaiTro())) {
            session.invalidate();
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        Map<String, Object> stats = registrationService.getAnalyticsStats(userId);
        model.addAttribute("stats", stats);
        List<Event> upcomingEvents = eventService.getUpcomingEvents(userId);
        model.addAttribute("upcomingEvents", upcomingEvents);
        List<Event> popularEvents = eventService.getPopularEvents(userId);
        model.addAttribute("popularEvents", popularEvents);
        List<LoaiSuKien> eventTypes = loaiSuKienService.findAll();
        model.addAttribute("eventTypes", eventTypes);
        List<Event> allEvents = eventService.getSuKienByOrganizer(userId);
        model.addAttribute("allEvents", allEvents);
        return "organizer/organize";
    }

    // API create event 
    @PostMapping(value = "/api/events/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, Object>> createEvent(
            @RequestParam("event") String eventJson, 
            @RequestParam(value = "anhBiaFile", required = false) MultipartFile anhBiaFile,
            HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        
        try {
            // Convert JSON string to Event object
            ObjectMapper objectMapper = new ObjectMapper();
            Event event = objectMapper.readValue(eventJson, Event.class);
            
            event.setNguoiToChucId(organizerId);
            if (anhBiaFile != null && !anhBiaFile.isEmpty()) {
                String fileName = "C:/Users/longl/OneDrive/Pictures/Modern_14-15_GG_Wallpaper_preload_3840x2160.jpg";
                event.setAnhBia(fileName);
            }
            
            eventService.createSuKien(event);
            return ResponseEntity.ok(new HashMap<>() {{
                put("success", true);
                put("message", "Tạo sự kiện thành công!");
            }});
            
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(400).body(new HashMap<>() {{
                put("success", false);
                put("message", "Lỗi khi xử lý dữ liệu: " + e.getMessage());
            }});
        }
    }

    // API lấy tất cả events của organizer
    @GetMapping("/api/events")
    public ResponseEntity<List<Event>> getEvents(HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(eventService.getSuKienByOrganizer(organizerId));
    }

    // API upcoming events
    @GetMapping("/api/events/upcoming")
    public ResponseEntity<List<Event>> getUpcomingEvents(HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(eventService.getUpcomingEvents(organizerId));
    }

    // API get event by id
    @GetMapping("/api/events/{id}")
    public ResponseEntity<Event> getEvent(@PathVariable Long id, HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        Event event = eventService.getSuKienById(id);
        if (event != null && event.getNguoiToChucId().equals(organizerId)) {
            return ResponseEntity.ok(event);
        }
        return ResponseEntity.notFound().build();
    }

    // // API create event
    // @PostMapping("/api/events/create")
    // public ResponseEntity<Map<String, Object>> createEvent(
    //         @RequestPart("event") Event event,
    //         @RequestPart(value = "anhBiaFile", required = false) MultipartFile anhBiaFile,
    //         HttpSession session) {
    //     Long organizerId = (Long) session.getAttribute("userId");
    //     if (organizerId == null) {
    //         return ResponseEntity.status(401).build();
    //     }
    //     event.setNguoiToChucId(organizerId);
    //     if (anhBiaFile != null && !anhBiaFile.isEmpty()) {
    //         String fileName = "C:/Users/longl/OneDrive/Pictures/Modern_14-15_GG_Wallpaper_preload_3840x2160.jpg";
    //         event.setAnhBia(fileName);
    //     }
    //     eventService.createSuKien(event);
    //     return ResponseEntity.ok(new HashMap<>() {{
    //         put("success", true);
    //         put("message", "Tạo sự kiện thành công!");
    //     }});
    // }

    // API update event
    @PostMapping(value = "/api/events/update/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, Object>> updateEvent(
            @PathVariable Long id,
            @RequestParam("event") String eventJson, 
            @RequestParam(value = "anhBiaFile", required = false) MultipartFile anhBiaFile,
            HttpSession session) {
        
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Event event = objectMapper.readValue(eventJson, Event.class);
            
            // Đảm bảo ID trong path khớp với ID trong event object
            if (!id.equals(event.getSuKienId())) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "ID trong URL không khớp với ID trong dữ liệu"
                ));
            }
            
            // Đảm bảo event thuộc về organizer
            Event existing = eventService.getSuKienById(id);
            if (existing == null || !existing.getNguoiToChucId().equals(organizerId)) {
                return ResponseEntity.notFound().build();
            }
            
            // Set lại organizerId từ session để đảm bảo an toàn
            event.setNguoiToChucId(organizerId);
            
            if (anhBiaFile != null && !anhBiaFile.isEmpty()) {
                String fileName = "C:/Users/longl/OneDrive/Pictures/Modern_14-15_GG_Wallpaper_preload_3840x2160.jpg";
                event.setAnhBia(fileName);
            } else {
                event.setAnhBia(existing.getAnhBia());
            }
            
            eventService.updateSuKien(event);
            return ResponseEntity.ok(new HashMap<>() {{
                put("success", true);
                put("message", "Cập nhật sự kiện thành công!");
            }});
            
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(400).body(new HashMap<>() {{
                put("success", false);
                put("message", "Lỗi khi xử lý dữ liệu: " + e.getMessage());
            }});
        }
    }

    // API delete event
    @PostMapping("/api/events/delete")
    public ResponseEntity<Map<String, Object>> deleteEvent(@RequestBody Map<String, Long> request, HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        Long suKienId = request.get("suKienId");
        Event event = eventService.getSuKienById(suKienId);
        if (event != null && event.getNguoiToChucId().equals(organizerId)) {
            eventService.deleteSuKien(suKienId);
            return ResponseEntity.ok(new HashMap<>() {{
                put("success", true);
                put("message", "Xóa sự kiện thành công!");
            }});
        }
        return ResponseEntity.notFound().build();
    }

    // API registrations
    @GetMapping("/api/registrations")
    public ResponseEntity<List<Registration>> getRegistrations(
            @RequestParam(required = false) Long suKienId,
            HttpSession session) {
        System.out.println("sukienID là  : " +suKienId);
        Long organizerId = (Long) session.getAttribute("userId");
        System.out.println("organizerId là  : " +organizerId);

        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        if (suKienId != null) {
            return ResponseEntity.ok(registrationService.getRegistrationsByEvent(suKienId));
        } else {
            return ResponseEntity.ok(registrationService.getAllRegistrationsForOrganizer(organizerId));
        }
    }

    @GetMapping("/api/registrations/{id}")
    public ResponseEntity<List<Registration>> getRegistrationsDetail(
            @RequestParam(required = false) Long suKienId,
            HttpSession session) {
        System.out.println("sukienID là  : " +suKienId);
        Long organizerId = (Long) session.getAttribute("userId");
        System.out.println("organizerId là  : " +organizerId);

        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        if (suKienId != null) {
            return ResponseEntity.ok(registrationService.getRegistrationsByEvent(suKienId));
        } else {
            return ResponseEntity.ok(registrationService.getAllRegistrationsForOrganizer(organizerId));
        }
    }

    // Thêm phương thức GET để tránh lỗi 405
    @GetMapping("/api/attendance/update")
    public ResponseEntity<Map<String, Object>> attendanceUpdateGet(HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).body(Map.of(
                "success", false,
                "message", "Unauthorized"
            ));
        }
        return ResponseEntity.status(405).body(Map.of(
            "success", false,
            "message", "Method Not Allowed. Please use POST method."
        ));
    }

    // API update attendance
    @PostMapping("/api/attendance/update")
    public ResponseEntity<Map<String, Object>> updateAttendance(@RequestBody Map<String, Object> request, HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        Long dangKyId = Long.parseLong(request.get("dangKyId").toString());
        boolean trangThaiDiemDanh = Boolean.parseBoolean(request.get("trangThaiDiemDanh").toString());
        // Kiểm tra quyền (dangKyId thuộc event của organizer)
        // Giả sử service handle
        registrationService.updateAttendance(dangKyId, trangThaiDiemDanh);
        return ResponseEntity.ok(new HashMap<>() {{
            put("success", true);
            put("message", "Cập nhật điểm danh thành công!");
        }});
    }
    /*
    // API analytics stats
    @GetMapping("/api/analytics/stats")
    public ResponseEntity<Map<String, Object>> getStats(HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(registrationService.getAnalyticsStats(organizerId));
    }
    */
    // API popular events
    @GetMapping("/api/analytics/popular")
    public ResponseEntity<List<Event>> getPopularEvents(HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(eventService.getPopularEvents(organizerId));
    }

    // API get account
    @GetMapping("/api/account")
    public ResponseEntity<User> getAccount(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(userService.findById(userId));
    }

    // API update account
    @PostMapping("/api/account/update")
    public ResponseEntity<Map<String, Object>> updateAccount(@RequestBody User user, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null || !userId.equals(user.getNguoiDungId())) {
            return ResponseEntity.status(401).build();
        }
        user.setTrangThai(1);
        userService.update(user);
        return ResponseEntity.ok(new HashMap<>() {{
            put("success", true);
            put("message", "Cập nhật tài khoản thành công!");
        }});
    }
    /*
    // Export event list as CSV
    @GetMapping("/api/events/export")
    public ResponseEntity<byte[]> exportEvent(@RequestParam Long suKienId, HttpSession session) throws IOException {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        // Get registrations for event
        List<Registration> registrations = registrationService.getRegistrationsByEvent(suKienId);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        CSVWriter writer = new CSVWriter(new OutputStreamWriter(baos, StandardCharsets.UTF_8));
        // Header
        writer.writeNext(new String[]{"Họ tên", "Email", "Số điện thoại", "Thời gian đăng ký", "Trạng thái"});
        for (Registration reg : registrations) {
            writer.writeNext(new String[]{
                    reg.getUser().getHoTen(), // Giả sử Registration có field user hoặc fetch
                    reg.getUser().getEmail(),
                    reg.getUser().getSoDienThoai(),
                    reg.getThoiGianDangKy().toString(),
                    reg.getTrangThai()
            });
        }
        writer.close();
        byte[] csvData = baos.toByteArray();
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=event_" + suKienId + ".csv")
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(csvData);
    }
    

    // Export attendance as CSV
    @GetMapping("/api/attendance/export")
    public ResponseEntity<byte[]> exportAttendance(@RequestParam Long suKienId, HttpSession session) throws IOException {
        // Tương tự exportEvent, nhưng thêm trạng thái điểm danh
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        List<Registration> registrations = registrationService.getRegistrationsByEvent(suKienId);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        CSVWriter writer = new CSVWriter(new OutputStreamWriter(baos, StandardCharsets.UTF_8));
        writer.writeNext(new String[]{"Họ tên", "Email", "Số điện thoại", "Trạng thái điểm danh"});
        for (Registration reg : registrations) {
            writer.writeNext(new String[]{
                    reg.getUser().getHoTen(),
                    reg.getUser().getEmail(),
                    reg.getUser().getSoDienThoai(),
                    reg.getTrangThai() // Hoặc field điểm danh riêng
            });
        }
        writer.close();
        byte[] csvData = baos.toByteArray();
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=attendance_" + suKienId + ".csv")
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(csvData);
    }

    // Export participants as CSV
    @GetMapping("/api/participants/export")
    public ResponseEntity<byte[]> exportParticipants(@RequestParam(required = false) Long suKienId, HttpSession session) throws IOException {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        List<Registration> registrations;
        if (suKienId != null) {
            registrations = registrationService.getRegistrationsByEvent(suKienId);
        } else {
            registrations = registrationService.getAllRegistrationsForOrganizer(organizerId);
        }
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        CSVWriter writer = new CSVWriter(new OutputStreamWriter(baos, StandardCharsets.UTF_8));
        writer.writeNext(new String[]{"Họ tên", "Email", "Số điện thoại", "Sự kiện", "Trạng thái"});
        for (Registration reg : registrations) {
            writer.writeNext(new String[]{
                    reg.getUser().getHoTen(),
                    reg.getUser().getEmail(),
                    reg.getUser().getSoDienThoai(),
                    reg.getSuKien().getTenSuKien(),
                    reg.getTrangThai()
            });
        }
        writer.close();
        byte[] csvData = baos.toByteArray();
        String fileName = "participants" + (suKienId != null ? "_" + suKienId : "") + ".csv";
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + fileName)
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(csvData);
    }
    */

    @GetMapping("/api/analytics/stats")
    public ResponseEntity<Map<String, Object>> getStats(@RequestParam(defaultValue = "month") String period, HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        Map<String, Object> stats = registrationService.getAnalyticsStats(organizerId);

        // Thêm biểu đồ
        List<Map<String, Object>> eventsByTypeData = eventService.getEventsByType(organizerId);
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
        try {
            ProcessBuilder pb = new ProcessBuilder("python", "D:/2022-2026/HOC KI 7/XD HTTT/quanLySuKien/demo/src/main/resources/scripts/chart.py", chartType);  // Thay path thực
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
            //String token = request.get("token");
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


    // API lấy danh sách đề xuất sự kiện
    @GetMapping("/api/event-suggestions")
    public ResponseEntity<List<Map<String, Object>>> getEventSuggestions(
            @RequestParam(required = false) Integer loaiSuKienId,
            @RequestParam(required = false) String diaDiem,
            @RequestParam(required = false) String soLuongKhach,
            @RequestParam(required = false) String trangThai,
            HttpSession session) {
        
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        
        List<Map<String, Object>> suggestions = eventSuggestionService.getSuggestionsWithFilters(
            loaiSuKienId, diaDiem, soLuongKhach, trangThai);
        
        return ResponseEntity.ok(suggestions);
    }

    // API lấy chi tiết đề xuất
    @GetMapping("/api/event-suggestions/{id}")
    public ResponseEntity<Map<String, Object>> getEventSuggestionDetail(@PathVariable Long id, HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        
        Map<String, Object> suggestionDetail = eventSuggestionService.getSuggestionDetail(id);
        if (suggestionDetail != null) {
            return ResponseEntity.ok(suggestionDetail);
        }
        
        return ResponseEntity.notFound().build();
    }

    // API xử lý đề xuất (chấp nhận/từ chối)
    @PostMapping("/api/event-suggestions/process")
    public ResponseEntity<Map<String, Object>> processEventSuggestion(@RequestBody Map<String, Object> request, HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        
        Long dangSuKienId = Long.parseLong(request.get("dangSuKienId").toString());
        String action = (String) request.get("action");
        String message = (String) request.get("message");
        
        boolean success = eventSuggestionService.processSuggestion(dangSuKienId, action, message, organizerId);
        
        if (success) {
            return ResponseEntity.ok(new HashMap<>() {{
                put("success", true);
                put("message", "Xử lý đề xuất thành công!");
            }});
        } else {
            return ResponseEntity.badRequest().body(new HashMap<>() {{
                put("success", false);
                put("message", "Xử lý đề xuất thất bại!");
            }});
        }
    }



    

}