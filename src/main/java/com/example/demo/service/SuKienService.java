package com.example.demo.service;

import com.example.demo.model.Event;
import com.example.demo.repository.SuKienRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

@Service
public class SuKienService {

    @Autowired
    private SuKienRepository suKienRepository;

    public List<Event> getSuKienByOrganizer(Long organizerId) {
        return suKienRepository.findByOrganizer(organizerId);
    }

    public void createSuKien(Event suKien) {
        suKien.setNgayTao(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        suKien.setTrangThaiThoigian("PENDING");
        suKienRepository.save(suKien);
    }

    public Event getSuKienById(Long id) {
        return suKienRepository.findById(id);
    }
}
