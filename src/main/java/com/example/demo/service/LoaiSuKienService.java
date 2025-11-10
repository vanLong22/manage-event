package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.demo.model.LoaiSuKien;
import com.example.demo.repository.LoaiSuKienRepository;


@Service
public class LoaiSuKienService {
    @Autowired private LoaiSuKienRepository loaiSuKienRepository;

    public List<LoaiSuKien> findAll() {
        return loaiSuKienRepository.findAll();
    }
}