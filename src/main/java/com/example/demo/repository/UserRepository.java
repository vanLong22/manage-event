package com.example.demo.repository;

import com.example.demo.model.User;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

//import java.util.List;

@Repository
public class UserRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public User findByUsername(String username) {
        try {
            String sql = "SELECT * FROM nguoi_dung WHERE ten_dang_nhap = ?";
            return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(User.class), username);
        } catch (Exception e) {
            return null;
        }
    }

    public User findByTenDangNhapAndMatKhau(String tenDangNhap, String matKhau) {
        try {
            String sql = "SELECT * FROM nguoi_dung WHERE ten_dang_nhap = ? AND mat_khau = ?";
            return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(User.class), tenDangNhap, matKhau);
        } catch (Exception e) {
            return null;
        }
    }

    public List<User> findByEmail(String email) {
        try {
            String sql = "SELECT * FROM nguoi_dung WHERE email = ?";
            return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class), email);
        } catch (Exception e) {
            return List.of();
        }
    }

    public void save(User user) {
        String sql = "INSERT INTO nguoi_dung (ten_dang_nhap, mat_khau, email, so_dien_thoai, ho_ten, " +
                     "dia_chi, gioi_tinh, anh_dai_dien, vai_tro, ngay_tao) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, now())";
        
        jdbcTemplate.update(sql, 
            user.getTenDangNhap(),
            user.getMatKhau(),
            user.getEmail(),
            user.getSoDienThoai(),
            user.getHoTen(),
            user.getDiaChi(),
            user.getGioiTinh(),
            user.getAnhDaiDien(),
            user.getVaiTro()
        );
    }

    public User findById(Long id) {
        String sql = "SELECT * FROM nguoi_dung WHERE nguoi_dung_id = ?";
        return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(User.class), id);
    }

    

    public void update(User user) {
        String sql = "UPDATE nguoi_dung SET ho_ten = ?, email = ?, so_dien_thoai = ?, dia_chi = ?, gioi_tinh = ?, anh_dai_dien = ? WHERE nguoi_dung_id = ?";
        jdbcTemplate.update(sql, user.getHoTen(), user.getEmail(), user.getSoDienThoai(), user.getDiaChi(), user.getGioiTinh(), user.getAnhDaiDien(), user.getNguoiDungId());
    }
}
