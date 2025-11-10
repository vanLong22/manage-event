package com.example.demo.service;

import com.example.demo.model.ActivityHistory;
import com.example.demo.repository.ActivityHistoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActivityHistoryService {
    @Autowired
    private ActivityHistoryRepository historyRepository;

    public List<ActivityHistory> getHistoryByUser(Long userId) {
        return historyRepository.findByUserId(userId);
    }
}