package com.example.demo.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.model.Event;

import java.util.List;

@Repository
public class SuKienRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Event> findByOrganizer(Long organizerId) {
        String sql = "SELECT * FROM su_ken WHERE nguoi_to_chuc_id = ?";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Event.class), organizerId);
    }

    public void save(Event suKien) {
        String sql = "INSERT INTO su_ken (ten_su_ken, mo_ta, dia_diem, anh_bia, nguoi_to_chuc_id, " +
                     "thoi_gian_bat_dau, thoi_gian_ket_thuc, loai_su_ken, trang_thai, so_luong_toi_da, ngay_tao) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, suKien.getTenSuKien(), suKien.getMoTa(), suKien.getDiaDiem(), 
                suKien.getAnhBia(), suKien.getNguoiToChucId(), suKien.getThoiGianBatDau(), 
                suKien.getThoiGianKetThuc(), suKien.getLoaiSuKien(), suKien.getTrangThai(), 
                suKien.getSoLuongToiDa(), suKien.getNgayTao());
    }

    public Event findById(Long id) {
        String sql = "SELECT * FROM su_ken WHERE su_ken_id = ?";
        return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(Event.class), id);
    }
}
