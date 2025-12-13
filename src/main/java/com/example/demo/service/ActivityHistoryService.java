package com.example.demo.service;

import com.example.demo.model.ActivityHistory;
import com.example.demo.repository.ActivityHistoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class ActivityHistoryService {
    @Autowired
    private ActivityHistoryRepository historyRepository;

    public List<ActivityHistory> getHistoryByUser(Long userId) {
        return historyRepository.findByUserId(userId);
    }

    public void logActivity(Long userId, String activityType, Long eventId, String details) {
        ActivityHistory history = new ActivityHistory();
        history.setNguoiDungId(userId);
        history.setLoaiHoatDong(activityType);
        history.setSuKienId(eventId);
        history.setChiTiet(details);
        history.setThoiGian(new Date());
        historyRepository.save(history);
    }
}