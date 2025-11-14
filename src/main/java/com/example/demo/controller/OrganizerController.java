package com.example.demo.controller;

import com.example.demo.model.Event;
import com.example.demo.model.LoaiSuKien;
import com.example.demo.model.Registration;
import com.example.demo.model.User;
import com.example.demo.service.EventService;
import com.example.demo.service.LoaiSuKienService;
import com.example.demo.service.RegistrationService;
import com.example.demo.service.UserService;
//import com.example.demo.service.FileStorageService; 
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.io.*;
import com.fasterxml.jackson.databind.ObjectMapper;

//import com.opencsv.CSVWriter; // Cần add dependency OpenCSV nếu dùng, hoặc dùng simple string builder

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
        if (user == null || !"ToChuc".equals(user.getVaiTro())) { // Kiểm tra vai trò
            session.invalidate();
            return "redirect:/login";
        }
        model.addAttribute("user", user);

        // Thống kê
        Map<String, Object> stats = registrationService.getAnalyticsStats(userId);
        model.addAttribute("stats", stats);

        // Upcoming events
        List<Event> upcomingEvents = eventService.getUpcomingEvents(userId);
        model.addAttribute("upcomingEvents", upcomingEvents);

        // Popular events
        List<Event> popularEvents = eventService.getPopularEvents(userId);
        model.addAttribute("popularEvents", popularEvents);

        // Event types for create form
        List<LoaiSuKien> eventTypes = loaiSuKienService.findAll();
        model.addAttribute("eventTypes", eventTypes);

        // All events
        List<Event> allEvents = eventService.getSuKienByOrganizer(userId);
        model.addAttribute("allEvents", allEvents);

        // All registrations
        List<Registration> allRegistrations = registrationService.getAllRegistrationsForOrganizer(userId);
        model.addAttribute("allRegistrations", allRegistrations);

        return "organizer/organize";
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

    // API update event
    @PostMapping("/api/events/update")
    public ResponseEntity<Map<String, Object>> updateEvent(
            @RequestPart("event") Event event,
            @RequestPart(value = "anhBiaFile", required = false) MultipartFile anhBiaFile,
            HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        Event existing = eventService.getSuKienById(event.getSuKienId());
        if (existing == null || !existing.getNguoiToChucId().equals(organizerId)) {
            return ResponseEntity.notFound().build();
        }
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

    // API analytics stats (sửa để thêm charts)
    @GetMapping("/api/analytics/stats")
    public ResponseEntity<Map<String, Object>> getStats(@RequestParam(defaultValue = "month") String period, HttpSession session) {
        Long organizerId = (Long) session.getAttribute("userId");
        if (organizerId == null) {
            return ResponseEntity.status(401).build();
        }
        Map<String, Object> stats = registrationService.getAnalyticsStats(organizerId);  // Giữ nguyên

        // Lấy dữ liệu cho charts (tùy chỉnh theo service của bạn)
        List<Event> events = eventService.getSuKienByOrganizer(organizerId);  // Dữ liệu sự kiện
        List<Registration> registrations = registrationService.getAllRegistrationsForOrganizer(organizerId);  // Dữ liệu đăng ký

        // Thêm charts vào stats
        stats.put("eventsByStatusChart", generateChart("events_by_status", events));
        stats.put("registrationsByEventChart", generateChart("registrations_by_event", eventService.getPopularEvents(organizerId)));  // Popular events
        stats.put("registrationsOverTimeChart", generateChart("registrations_over_time", registrations));

        return ResponseEntity.ok(stats);
    }

    private String generateChart(String chartType, List<?> data) {
        try {
            ProcessBuilder pb = new ProcessBuilder("python", "D:\\2022-2026\\HOC KI 7\\XD HTTT\\quanLySuKien\\demo\\src\\main\\resources\\scripts\\chart.py", chartType);
            // Remove redirectErrorStream(true) to keep stdout and stderr separate
            Process p = pb.start();

            // Send JSON to stdin
            try (OutputStream os = p.getOutputStream()) {
                ObjectMapper mapper = new ObjectMapper();
                os.write(mapper.writeValueAsBytes(data));
                os.flush();
            }

            // Read stdout (base64) using ByteArrayOutputStream
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            try (InputStream is = p.getInputStream()) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    baos.write(buffer, 0, bytesRead);
                }
            }

            // Optionally read stderr for logging/debugging
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

            // Log details (now stderr is separate, so result is clean base64)
            System.out.println("=== CHART DEBUG ===");
            System.out.println("Exit code: " + exitCode);
            System.out.println("Output length: " + result.length() + " chars");
            System.out.println("First 50: " + result.substring(0, Math.min(50, result.length())));
            System.out.println("Last 50: " + result.substring(Math.max(0, result.length() - 50)));
            System.out.println("===================");

            if (exitCode != 0 || result.isEmpty() || result.length() < 5000) {
                System.err.println("Python failed or base64 too short");
                return null;
            }

            return result;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }



}