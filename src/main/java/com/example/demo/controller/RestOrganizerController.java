package com.example.demo.controller;

import com.example.demo.model.Event;
import com.example.demo.service.SuKienService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/organizer")
public class RestOrganizerController {

    @Autowired
    private SuKienService suKienService;

    @GetMapping("/events")
    public List<Event> getEvents(@RequestParam Long organizerId) {
        return suKienService.getSuKienByOrganizer(organizerId);
    }

    @GetMapping("/events/{id}")
    public Event getEvent(@PathVariable Long id) {
        return suKienService.getSuKienById(id);
    }

    @PostMapping("/events")
    public String createEvent(@RequestBody Event suKien) {
        suKienService.createSuKien(suKien);
        return "Success";
    }
}
