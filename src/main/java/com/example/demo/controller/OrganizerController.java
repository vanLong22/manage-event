// // package com.example.demo.controller;

// // import org.springframework.stereotype.Controller;
// // import org.springframework.web.bind.annotation.GetMapping;


// // import com.example.demo.model.Event;
// // import com.example.demo.model.User;
// // import com.example.demo.service.eventService;
// // import com.example.demo.service.UserService;
// // import org.springframework.beans.factory.annotation.Autowired;
// // import org.springframework.ui.Model;
// // import org.springframework.web.bind.annotation.*;

// // import java.security.Principal;
// // import java.util.HashMap;
// // import java.util.List;
// // import java.util.Map;

// // @Controller
// // @RequestMapping("/organizer")
// // public class OrganizerController {

// //     @Autowired
// //     private eventService eventService;

// //     @Autowired
// //     private UserService userService;

// //     //@Autowired
// //     //private FileStorageService fileStorageService;

// //     @GetMapping("/")
// //     public String showOrganizerPage() {
// //         return "organizer/organize";   
// //     }

// //     @GetMapping("/dashboard")
// //     public String dashboard(Model model, Principal principal) {
// //         //User organizer = userService.findByUsername(principal.getName());
        
// //         // Thống kê
// //         Map<String, Object> stats = new HashMap<>();
// //         stats.put("activeEvents", 12);
// //         stats.put("totalParticipants", 342);
// //         stats.put("upcomingEvents", 5);
// //         stats.put("attentionEvents", 2);
// //         model.addAttribute("stats", stats);
// // /* 
// //         // Sự kiện sắp tới
// //         List<SuKien> upcomingEvents = eventService.getSuKienByOrganizer(organizer.getNguoiDungId());
// //         model.addAttribute("upcomingEvents", upcomingEvents);
// // */
// //         return "organizer/organize";
// //     }

// //     @GetMapping("/events")
// //     public String eventsManagement(Model model, Principal principal) {
// //         User organizer = userService.findByUsername(principal.getName());
// //         List<Event> events = eventService.getSuKienByOrganizer(organizer.getNguoiDungId());
// //         model.addAttribute("events", events);
// //         return "organizer/events";
// //     }

// //     @GetMapping("/events/create")
// //     public String createEventForm(Model model) {
// //         model.addAttribute("suKien", new Event());
// //         return "organizer/create-event";
// //     }
// // /*
// //     @PostMapping("/events/create")
// //     public String createEvent(@ModelAttribute SuKien suKien, 
// //                             @RequestParam("anhBiaFile") MultipartFile file,
// //                             Principal principal) {
// //         User organizer = userService.findByUsername(principal.getName());
        
// //         // Xử lý upload ảnh
// //         if (!file.isEmpty()) {
// //             String filename = System.currentTimeMillis() + "_" + file.getOriginalFilename();
// //             fileStorageService.store(file, filename);
// //             suKien.setAnhBia(filename);
// //         }
        
// //         suKien.setNguoiToChucId(organizer.getNguoiDungId());
// //         eventService.createSuKien(suKien);
        
// //         return "redirect:/organizer/events";
// //     }
// // */
// // }





// // Controller: OrganizerController
// package com.example.demo.controller;

// import com.example.demo.model.Event;
// import com.example.demo.model.Registration;
// import com.example.demo.model.User;
// import com.example.demo.service.OrganizerService;
// import com.example.demo.service.UserService;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.http.ResponseEntity;
// import org.springframework.stereotype.Controller;
// import org.springframework.ui.Model;
// import org.springframework.web.bind.annotation.*;

// import java.util.List;
// import java.util.Map;

// @Controller
// @RequestMapping("/organizer")
// public class OrganizerController {

//     @Autowired
//     private OrganizerService organizerService;
//     @Autowired
//     private UserService userService;

//     @GetMapping("/dashboard")
//     public String dashboard(Model model) {
//         Long userId = 1L; // Từ session
//         User user = userService.findById(userId);
//         model.addAttribute("user", user);
//         return "organizer/dashboard";
//     }

//     @GetMapping("/api/events")
//     public ResponseEntity<List<Event>> getEvents() {
//         Long organizerId = 1L;
//         return ResponseEntity.ok(organizerService.getEventsByOrganizer(organizerId));
//     }

//     @GetMapping("/api/events/upcoming")
//     public ResponseEntity<List<Event>> getUpcomingEvents() {
//         Long organizerId = 1L;
//         return ResponseEntity.ok(organizerService.getUpcomingEvents(organizerId)); // Thêm method
//     }

//     @PostMapping("/api/events/create")
//     public ResponseEntity<Map<String, Object>> createEvent(@RequestBody Event event) {
//         event.setNguoiToChucId(1L); // Từ session
//         organizerService.createEvent(event);
//         return ResponseEntity.ok(Map.of("success", true));
//     }

//     @PostMapping("/api/events/update")
//     public ResponseEntity<Map<String, Object>> updateEvent(@RequestBody Event event) {
//         organizerService.updateEvent(event);
//         return ResponseEntity.ok(Map.of("success", true));
//     }

//     @PostMapping("/api/events/delete")
//     public ResponseEntity<Map<String, Object>> deleteEvent(@RequestBody Map<String, Long> request) {
//         organizerService.deleteEvent(request.get("suKienId"));
//         return ResponseEntity.ok(Map.of("success", true));
//     }

//     @GetMapping("/api/events/{suKienId}")
//     public ResponseEntity<Event> getEvent(@PathVariable Long suKienId) {
//         return ResponseEntity.ok(organizerService.getEventById(suKienId)); // Thêm method
//     }

//     @GetMapping("/api/registrations")
//     public ResponseEntity<List<Registration>> getRegistrations(@RequestParam(required = false) Long suKienId) {
//         if (suKienId != null) {
//             return ResponseEntity.ok(organizerService.getRegistrationsByEvent(suKienId));
//         } else {
//             return ResponseEntity.ok(organizerService.getAllRegistrationsForOrganizer(1L)); // Thêm method
//         }
//     }

//     @PostMapping("/api/attendance/update")
//     public ResponseEntity<Map<String, Object>> updateAttendance(@RequestBody Map<String, Object> request) {
//         Long dangKyId = Long.parseLong(request.get("dangKyId").toString());
//         boolean trangThaiDiemDanh = (boolean) request.get("trangThaiDiemDanh");
//         organizerService.updateAttendance(dangKyId, trangThaiDiemDanh);
//         return ResponseEntity.ok(Map.of("success", true));
//     }

//     @GetMapping("/api/analytics/stats")
//     public ResponseEntity<Map<String, Object>> getStats() {
//         return ResponseEntity.ok(organizerService.getAnalytics(1L));
//     }

//     @GetMapping("/api/analytics/popular")
//     public ResponseEntity<List<Event>> getPopularEvents() {
//         return ResponseEntity.ok(organizerService.getPopularEvents(1L));
//     }

//     @GetMapping("/api/account")
//     public ResponseEntity<User> getAccount() {
//         return ResponseEntity.ok(userService.findById(1L));
//     }

//     @PostMapping("/api/account/update")
//     public ResponseEntity<Map<String, Object>> updateAccount(@RequestBody User user) {
//         userService.update(user);
//         return ResponseEntity.ok(Map.of("success", true));
//     }

//     // Export endpoints (return CSV or PDF, use library like iText or CSVWriter)
//     @GetMapping("/api/events/export")
//     public ResponseEntity<String> exportEvent(@RequestParam Long suKienId) {
//         // Logic export
//         return ResponseEntity.ok("Exported");
//     }

//     @GetMapping("/api/attendance/export")
//     public ResponseEntity<String> exportAttendance(@RequestParam Long suKienId) {
//         // Logic
//         return ResponseEntity.ok("Exported");
//     }

//     @GetMapping("/api/participants/export")
//     public ResponseEntity<String> exportParticipants(@RequestParam(required = false) Long suKienId) {
//         // Logic
//         return ResponseEntity.ok("Exported");
//     }
// }

package com.example.demo.controller;

import com.example.demo.model.Event;
import com.example.demo.model.Registration;
import com.example.demo.model.User;
import com.example.demo.service.EventService;
import com.example.demo.service.LoaiSuKienService;
import com.example.demo.service.RegistrationService;
import com.example.demo.service.UserService;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

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

    @GetMapping("/organizer/organize")
    public String dashboard(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        User user = userService.findById(userId);
        if (user == null) { session.invalidate(); return "redirect:/login"; }
        model.addAttribute("user", user);

        // Thống kê (tương tự như analytics stats)
        Map<String, Object> stats = registrationService.getAnalyticsStats(userId); // organizerId = userId
        model.addAttribute("stats", stats);

        // Upcoming events
        List<Event> upcomingEvents = eventService.getUpcomingEvents(userId);
        model.addAttribute("upcomingEvents", upcomingEvents);

        // Popular events
        List<Event> popularEvents = eventService.getPopularEvents(userId);
        model.addAttribute("popularEvents", popularEvents);

        // Event types (nếu cần cho form create)
        model.addAttribute("eventTypes", loaiSuKienService.findAll());

        // Các data khác nếu cần, ví dụ: all events, registrations
        List<Event> allEvents = eventService.getSuKienByOrganizer(userId);
        model.addAttribute("allEvents", allEvents);

        List<Registration> allRegistrations = registrationService.getAllRegistrationsForOrganizer(userId);
        model.addAttribute("allRegistrations", allRegistrations);

        return "organizer/organize"; // Giả sử file JSP là organizer/dashboard.jsp
    }

    @GetMapping("/events")
    public ResponseEntity<List<Event>> getEvents(@RequestParam Long organizerId) {
        return ResponseEntity.ok(eventService.getSuKienByOrganizer(organizerId));
    }

    @GetMapping("/api/events/upcoming")
    public ResponseEntity<List<Event>> getUpcomingEvents() {
        Long organizerId = 1L; // Từ session
        return ResponseEntity.ok(eventService.getUpcomingEvents(organizerId));
    }

    @GetMapping("/api/events")
    public ResponseEntity<List<Event>> getEvents() {
        Long organizerId = 1L; // Từ session
        return ResponseEntity.ok(eventService.getSuKienByOrganizer(organizerId));
    }

    @GetMapping("/api/events/{id}")
    public ResponseEntity<Event> getEvent(@PathVariable Long id) {
        return ResponseEntity.ok(eventService.getSuKienById(id));
    }

    @PostMapping("/api/events/create")
    public ResponseEntity<Map<String, Object>> createEvent(@RequestBody Event event, @RequestParam(required = false) MultipartFile anhBiaFile) {
        Long organizerId = 1L; // Từ session
        event.setNguoiToChucId(organizerId);
        // Xử lý upload file nếu có (giả sử lưu path)
        if (anhBiaFile != null && !anhBiaFile.isEmpty()) {
            // Logic lưu file, ví dụ: String fileName = fileStorageService.store(anhBiaFile); (nếu có service)
            event.setAnhBia("path/to/" + anhBiaFile.getOriginalFilename()); // Placeholder
        }
        eventService.createSuKien(event);
        return ResponseEntity.ok(Map.of("success", true, "message", "Tạo sự kiện thành công!"));
    }

    @PostMapping("/api/events/update")
    public ResponseEntity<Map<String, Object>> updateEvent(@RequestBody Event event, @RequestParam(required = false) MultipartFile anhBiaFile) {
        // Xử lý upload file nếu có
        if (anhBiaFile != null && !anhBiaFile.isEmpty()) {
            event.setAnhBia("path/to/" + anhBiaFile.getOriginalFilename()); // Placeholder
        }
        eventService.updateSuKien(event);
        return ResponseEntity.ok(Map.of("success", true, "message", "Cập nhật sự kiện thành công!"));
    }

    @PostMapping("/api/events/delete")
    public ResponseEntity<Map<String, Object>> deleteEvent(@RequestBody Map<String, Long> request) {
        eventService.deleteSuKien(request.get("suKienId"));
        return ResponseEntity.ok(Map.of("success", true, "message", "Xóa sự kiện thành công!"));
    }

    @GetMapping("/api/registrations")
    public ResponseEntity<List<Registration>> getRegistrations(@RequestParam(required = false) Long suKienId) {
        if (suKienId != null) {
            return ResponseEntity.ok(registrationService.getRegistrationsByEvent(suKienId));
        } else {
            Long organizerId = 1L;
            return ResponseEntity.ok(registrationService.getAllRegistrationsForOrganizer(organizerId));
        }
    }

    @PostMapping("/api/attendance/update")
    public ResponseEntity<Map<String, Object>> updateAttendance(@RequestBody Map<String, Object> request) {
        Long dangKyId = Long.parseLong(request.get("dangKyId").toString());
        boolean trangThaiDiemDanh = (boolean) request.get("trangThaiDiemDanh");
        registrationService.updateAttendance(dangKyId, trangThaiDiemDanh);
        return ResponseEntity.ok(Map.of("success", true, "message", "Cập nhật điểm danh thành công!"));
    }

    @GetMapping("/api/analytics/stats")
    public ResponseEntity<Map<String, Object>> getStats() {
        Long organizerId = 1L;
        return ResponseEntity.ok(registrationService.getAnalyticsStats(organizerId));
    }

    @GetMapping("/api/analytics/popular")
    public ResponseEntity<List<Event>> getPopularEvents() {
        Long organizerId = 1L;
        return ResponseEntity.ok(eventService.getPopularEvents(organizerId));
    }

    @GetMapping("/api/account")
    public ResponseEntity<User> getAccount(@RequestParam Long userId) {
        return ResponseEntity.ok(userService.findById(userId));
    }

    @PostMapping("/api/account/update")
    public ResponseEntity<Map<String, Object>> updateAccount(@RequestBody User user) {
        userService.update(user);
        return ResponseEntity.ok(Map.of("success", true, "message", "Cập nhật tài khoản thành công!"));
    }

    // Export endpoints (placeholder, trả về file giả định)
    @GetMapping("/api/events/export")
    public ResponseEntity<byte[]> exportEvent(@RequestParam Long suKienId) {
        // Logic export CSV/PDF (sử dụng library như OpenCSV hoặc iText)
        byte[] csvData = "Tên sự kiện,Ngày,Địa điểm\nEvent1,2025-11-03,Hanoi".getBytes(); // Placeholder
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=event_" + suKienId + ".csv")
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(csvData);
    }

    @GetMapping("/api/attendance/export")
    public ResponseEntity<byte[]> exportAttendance(@RequestParam Long suKienId) {
        byte[] csvData = "Họ tên,Email,Trạng thái\nUser1,user1@email.com,Đã tham gia".getBytes(); // Placeholder
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=attendance_" + suKienId + ".csv")
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(csvData);
    }

    @GetMapping("/api/participants/export")
    public ResponseEntity<byte[]> exportParticipants(@RequestParam(required = false) Long suKienId) {
        byte[] csvData = "Họ tên,Email,Sự kiện\nUser1,user1@email.com,Event1".getBytes(); // Placeholder
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=participants" + (suKienId != null ? "_" + suKienId : "") + ".csv")
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(csvData);
    }
}