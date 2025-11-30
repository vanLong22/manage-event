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
import java.util.Map;

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

        // Thiết lập ngày tạo và trạng thái mặc định (1 - Hoạt động)
        user.setNgayTao(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        user.setTrangThai(1); // 1: Hoạt động, 0: Bị khóa

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
        User user = userRepository.findByTenDangNhapAndMatKhau(tenDangNhap, matKhau);
        
        // Kiểm tra trạng thái tài khoản
        if (user != null) {
            if (user.getTrangThai() == 0) {
                throw new RuntimeException("Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
            } else if (user.getTrangThai() == 2) {
                throw new RuntimeException("Tài khoản của bạn đang tạm ngừng hoạt động.");
            }
            // Trạng thái 1: Hoạt động - cho phép đăng nhập
        }
        
        return user;
    }

    public void save(User user) {
        userRepository.save(user);
    }

    public void update(User user) {
        userRepository.update(user);
    }

    // Xóa người dùng theo ID (soft delete - cập nhật trạng thái)
    public void delete(Long id) {
        String sql = "UPDATE nguoi_dung SET trang_thai = 0 WHERE nguoi_dung_id = ?";
        int rowsAffected = jdbcTemplate.update(sql, id);
        if (rowsAffected == 0) {
            throw new RuntimeException("Không tìm thấy người dùng với ID: " + id);
        }
    }

    // Khóa/Mở khóa người dùng
    public void toggleUserStatus(Long id, Integer status) {
        String sql = "UPDATE nguoi_dung SET trang_thai = ? WHERE nguoi_dung_id = ?";
        int rowsAffected = jdbcTemplate.update(sql, status, id);
        if (rowsAffected == 0) {
            throw new RuntimeException("Không tìm thấy người dùng với ID: " + id);
        }
    }

    // Lấy tất cả người dùng
    public List<User> findAll() {
        String sql = "SELECT * FROM nguoi_dung";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class));
    }

    // Lấy người dùng theo trạng thái
    public List<User> findByStatus(Integer status) {
        String sql = "SELECT * FROM nguoi_dung WHERE trang_thai = ?";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class), status);
    }

    // Kiểm tra email đã tồn tại
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM nguoi_dung WHERE email = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, email);
        return count != null && count > 0;
    }

    // Kiểm tra số điện thoại đã tồn tại
    public boolean isPhoneExists(String soDienThoai) {
        if (soDienThoai == null || soDienThoai.trim().isEmpty()) {
            return false;
        }
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

    public List<Map<String, Object>> getUsersByRole(){
        return userRepository.getUsersByRole();
    } 

    public List<Map<String, Object>> getGenderDistribution(){
        return userRepository.getGenderDistribution();
    }

    // Lấy số lượng người dùng theo trạng thái
    public Map<String, Object> getUserStatusStats() {
        String sql = "SELECT " +
                     "SUM(CASE WHEN trang_thai = 1 THEN 1 ELSE 0 END) as active, " +
                     "SUM(CASE WHEN trang_thai = 0 THEN 1 ELSE 0 END) as inactive, " +
                     "SUM(CASE WHEN trang_thai = 2 THEN 1 ELSE 0 END) as suspended, " +
                     "COUNT(*) as total " +
                     "FROM nguoi_dung";
        return jdbcTemplate.queryForMap(sql);
    }
}