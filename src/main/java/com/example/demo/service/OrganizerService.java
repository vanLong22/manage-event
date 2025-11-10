// package com.example.demo.service;

// import com.example.demo.model.Event;
// import com.example.demo.model.Registration;
// import com.example.demo.repository.EventRepository;
// import com.example.demo.repository.RegistrationRepository;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.stereotype.Service;

// import java.util.List;
// import java.util.Map;

// @Service
// public class OrganizerService {
//     @Autowired
//     private EventRepository eventRepository;
//     @Autowired
//     private RegistrationRepository registrationRepository;

//     public List<Event> getEventsByOrganizer(Long organizerId) {
//         return eventRepository.findByOrganizerId(organizerId); // Thêm method này trong repository: SELECT * FROM su_kien WHERE nguoi_to_chuc_id = ?
//     }

//     public void createEvent(Event event) {
//         eventRepository.save(event); // Thêm save method in repository
//     }

//     public void updateEvent(Event event) {
//         eventRepository.update(event); // Thêm update method
//     }

//     public void deleteEvent(Long suKienId) {
//         eventRepository.delete(suKienId); // Thêm delete method
//     }

//     public List<Registration> getRegistrationsByEvent(Long suKienId) {
//         return registrationRepository.findBySuKienId(suKienId); // Thêm method
//     }

//     public void updateAttendance(Long dangKyId, boolean trangThaiDiemDanh) {
//         registrationRepository.updateAttendance(dangKyId, trangThaiDiemDanh); // Thêm field trangThaiDiemDanh in Registration and method
//     }

//     public Map<String, Object> getAnalytics(Long organizerId) {
//         // Logic tính toán stats
//         return Map.of(
//             "activeEvents", 12,
//             "totalParticipants", 342,
//             "upcomingEvents", 5,
//             "attentionEvents", 2,
//             "avgAttendanceRate", 85,
//             "satisfactionRate", 72,
//             "estimatedRevenue", 25.5,
//             "cancellationRate", 12
//         );
//     }

//     public List<Event> getPopularEvents(Long organizerId) {
//         // Logic top events
//         return List.of(); // Sample
//     }
// }