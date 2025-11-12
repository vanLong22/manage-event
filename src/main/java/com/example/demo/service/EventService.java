package com.example.demo.service;

import com.example.demo.model.Event;
import com.example.demo.repository.EventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

@Service
public class EventService {
    @Autowired
    private EventRepository eventRepository;

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

    // Thêm mới: Update event
    public void updateSuKien(Event suKien) {
        eventRepository.update(suKien);
    }

    // Thêm mới: Delete event
    public void deleteSuKien(Long id) {
        eventRepository.delete(id);
    }
}