package com.example.demo.repository;

import com.example.demo.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class UserRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public User findByUsername(String username) {
        System.out.println("Finding user by username: " + username);
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
                     "dia_chi, gioi_tinh, anh_dai_dien, vai_tro, ngay_tao, trang_thai) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, now(), 1)";
        
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
        String sql = "UPDATE nguoi_dung SET ho_ten = ?, email = ?, so_dien_thoai = ?, dia_chi = ?, anh_dai_dien = ?, trang_thai = ? WHERE nguoi_dung_id = ?";
        jdbcTemplate.update(sql, user.getHoTen(), user.getEmail(), user.getSoDienThoai(), user.getDiaChi(), user.getAnhDaiDien(), user.getTrangThai(), user.getNguoiDungId());
    }

    public boolean updateInfo(User user) {
        String sql = "UPDATE nguoi_dung SET ho_ten = ?, email = ?, so_dien_thoai = ?, dia_chi = ? WHERE nguoi_dung_id = ?";
        
        int rowsAffected = jdbcTemplate.update(sql,
            user.getHoTen(),
            user.getEmail(),
            user.getSoDienThoai(),
            user.getDiaChi(),
            user.getNguoiDungId()
        );
        
        return rowsAffected > 0;
    }

    public boolean updatePassword(Long userId, String currentPassword, String newPassword) {
        try {
            // Kiểm tra mật khẩu hiện tại
            String checkSql = "SELECT mat_khau FROM nguoi_dung WHERE nguoi_dung_id = ?";
            String currentHashedPassword = jdbcTemplate.queryForObject(checkSql, String.class, userId);
            
            // So sánh mật khẩu hiện tại (trong thực tế nên dùng BCrypt)
            if (!currentHashedPassword.equals(currentPassword)) {
                return false;
            }
            
            // Cập nhật mật khẩu mới
            String updateSql = "UPDATE nguoi_dung SET mat_khau = ? WHERE nguoi_dung_id = ?";
            int rowsAffected = jdbcTemplate.update(updateSql, newPassword, userId);
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void updatePasswordDirect(Long userId, String newPassword) {
        String sql = "UPDATE nguoi_dung SET mat_khau = ? WHERE nguoi_dung_id = ?";
        jdbcTemplate.update(sql, newPassword, userId);
    }

    // Cập nhật trạng thái người dùng
    public void updateStatus(Long userId, Integer status) {
        String sql = "UPDATE nguoi_dung SET trang_thai = ? WHERE nguoi_dung_id = ?";
        jdbcTemplate.update(sql, status, userId);
    }

    // Phương thức tạo biểu đồ: Số lượng người dùng theo vai trò (Bar Chart)
    public List<Map<String, Object>> getUsersByRole() {
        String sql = "SELECT vai_tro, COUNT(nguoi_dung_id) as count FROM nguoi_dung GROUP BY vai_tro";
        return jdbcTemplate.queryForList(sql);
    }

    // Phương thức tạo biểu đồ: Tỷ lệ giới tính người dùng (Pie Chart)
    public List<Map<String, Object>> getGenderDistribution() {
        String sql = "SELECT gioi_tinh, COUNT(nguoi_dung_id) as count FROM nguoi_dung GROUP BY gioi_tinh";
        return jdbcTemplate.queryForList(sql);
    }

    // Phương thức tạo biểu đồ: Số lượng người dùng theo trạng thái
    public List<Map<String, Object>> getUsersByStatus() {
        String sql = "SELECT trang_thai, COUNT(nguoi_dung_id) as count FROM nguoi_dung GROUP BY trang_thai";
        return jdbcTemplate.queryForList(sql);
    }
}