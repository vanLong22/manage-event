package com.example.demo.repository;

import com.example.demo.model.LoaiSuKien;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class LoaiSuKienRepository {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<LoaiSuKien> findAll() {
        return jdbcTemplate.query("select * from loai_su_kien", 
                 new BeanPropertyRowMapper<>(LoaiSuKien.class));
    }
}
