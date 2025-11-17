package com.example.demo.service;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Đăng ký người dùng mới
    public User register(User user) {
        // Kiểm tra username đã tồn tại
        if (userRepository.findByUsername(user.getTenDangNhap()) != null) {
            throw new RuntimeException("Tên đăng nhập đã tồn tại!");
        }

        // Kiểm tra email đã tồn tại
        if (isEmailExists(user.getEmail())) {
            throw new RuntimeException("Email đã được sử dụng!");
        }

        // Kiểm tra số điện thoại đã tồn tại
        if (isPhoneExists(user.getSoDienThoai())) {
            throw new RuntimeException("Số điện thoại đã được sử dụng!");
        }

        // Thiết lập ngày tạo
        user.setNgayTao(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));

        // Lưu vào DB
        userRepository.save(user);
        return user;
    }

    // Tìm người dùng theo tên đăng nhập
    public User findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public List<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public User login(String tenDangNhap, String matKhau) {
        return userRepository.findByTenDangNhapAndMatKhau(tenDangNhap, matKhau);
    }

    public void save(User user) {
        userRepository.save(user);
    }

    public void update(User user) {
        userRepository.update(user);
    }

    // Xóa người dùng theo ID
    public void delete(Long id) {
        String sql = "DELETE FROM nguoi_dung WHERE nguoi_dung_id = ?";
        int rowsAffected = jdbcTemplate.update(sql, id);
        if (rowsAffected == 0) {
            throw new RuntimeException("Không tìm thấy người dùng với ID: " + id);
        }
    }

    // Lấy tất cả người dùng
    public List<User> findAll() {
        String sql = "SELECT * FROM nguoi_dung";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class));
    }

    // Kiểm tra email đã tồn tại
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM nguoi_dung WHERE email = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, email);
        return count != null && count > 0;
    }

    // Kiểm tra số điện thoại đã tồn tại
    public boolean isPhoneExists(String soDienThoai) {
        String sql = "SELECT COUNT(*) FROM nguoi_dung WHERE so_dien_thoai = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, soDienThoai);
        return count != null && count > 0;
    }

    // Tìm người dùng theo ID
    public User findById(Long id) {
        String sql = "SELECT * FROM nguoi_dung WHERE nguoi_dung_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(User.class), id);
        } catch (Exception e) {
            return null;
        }
    }

    public boolean changePassword(Long userId, String currentPassword, String newPassword) {
        return userRepository.updatePassword(userId, currentPassword, newPassword);
    }

    public void resetPassword(Long userId, String newPassword) {
        userRepository.updatePasswordDirect(userId, newPassword);
    }

    public boolean verifyCurrentPassword(Long userId, String currentPassword) {
        try {
            String sql = "SELECT mat_khau FROM nguoi_dung WHERE nguoi_dung_id = ?";
            String storedPassword = jdbcTemplate.queryForObject(sql, String.class, userId);
            return storedPassword.equals(currentPassword);
        } catch (Exception e) {
            return false;
        }
    }
}