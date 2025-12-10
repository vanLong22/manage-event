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

    public User register(User user) {
        if (userRepository.findByUsername(user.getTenDangNhap()) != null) {
            throw new RuntimeException("Tên đăng nhập đã tồn tại!");
        }

        if (isEmailExists(user.getEmail())) {
            throw new RuntimeException("Email đã được sử dụng!");
        }

        if (isPhoneExists(user.getSoDienThoai())) {
            throw new RuntimeException("Số điện thoại đã được sử dụng!");
        }

        user.setNgayTao(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        user.setTrangThai(1);

        userRepository.save(user);
        return user;
    }

    public User findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public List<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public User login(String tenDangNhap, String matKhau) {
        User user = userRepository.findByTenDangNhapAndMatKhau(tenDangNhap, matKhau);
        
        if (user != null) {
            if (user.getTrangThai() == 0) {
                throw new RuntimeException("Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
            } else if (user.getTrangThai() == 2) {
                throw new RuntimeException("Tài khoản của bạn đang tạm ngừng hoạt động.");
            }
        }
        
        return user;
    }

    public void save(User user) {
        userRepository.save(user);
    }

    public void update(User user) {
        userRepository.update(user);
    }

    public void delete(Long id) {
        String sql = "UPDATE nguoi_dung SET trang_thai = 0 WHERE nguoi_dung_id = ?";
        int rowsAffected = jdbcTemplate.update(sql, id);
        if (rowsAffected == 0) {
            throw new RuntimeException("Không tìm thấy người dùng với ID: " + id);
        }
    }

    public void toggleUserStatus(Long id, Integer status) {
        String sql = "UPDATE nguoi_dung SET trang_thai = ? WHERE nguoi_dung_id = ?";
        int rowsAffected = jdbcTemplate.update(sql, status, id);
        if (rowsAffected == 0) {
            throw new RuntimeException("Không tìm thấy người dùng với ID: " + id);
        }
    }

    public List<User> findAll() {
        String sql = "SELECT * FROM nguoi_dung";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class));
    }

    // Phương thức mới: Lọc người dùng theo giới tính
    public List<User> findByGender(String gender) {
        String sql = "SELECT * FROM nguoi_dung WHERE gioi_tinh = ?";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class), gender);
    }

    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM nguoi_dung WHERE email = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, email);
        return count != null && count > 0;
    }

    public boolean isPhoneExists(String soDienThoai) {
        if (soDienThoai == null || soDienThoai.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM nguoi_dung WHERE so_dien_thoai = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, soDienThoai);
        return count != null && count > 0;
    }

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

    public Map<String, Object> getUserStatusStats() {
        String sql = "SELECT " +
                     "SUM(CASE WHEN trang_thai = 1 THEN 1 ELSE 0 END) as active, " +
                     "SUM(CASE WHEN trang_thai = 0 THEN 1 ELSE 0 END) as inactive, " +
                     "SUM(CASE WHEN trang_thai = 2 THEN 1 ELSE 0 END) as suspended, " +
                     "COUNT(*) as total " +
                     "FROM nguoi_dung";
        return jdbcTemplate.queryForMap(sql);
    }

    public boolean updateUserInfo(User user) {
        try {
            if (user == null || user.getNguoiDungId() == null) {
                throw new RuntimeException("Thông tin người dùng không hợp lệ!");
            }
            
            User existingUser = userRepository.findById(user.getNguoiDungId());
            if (existingUser == null) {
                throw new RuntimeException("Không tìm thấy người dùng!");
            }
            
            if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
                throw new RuntimeException("Email không được để trống!");
            }
            
            String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
            if (!user.getEmail().matches(emailRegex)) {
                throw new RuntimeException("Email không hợp lệ!");
            }
            
            if (!existingUser.getEmail().equals(user.getEmail()) && isEmailExists(user.getEmail())) {
                throw new RuntimeException("Email đã được sử dụng bởi tài khoản khác!");
            }
            
            if (user.getSoDienThoai() == null || user.getSoDienThoai().trim().isEmpty()) {
                throw new RuntimeException("Số điện thoại không được để trống!");
            }
            
            String phoneRegex = "^[0-9]{10,11}$";
            if (!user.getSoDienThoai().matches(phoneRegex)) {
                throw new RuntimeException("Số điện thoại không hợp lệ!");
            }
            
            if (!existingUser.getSoDienThoai().equals(user.getSoDienThoai()) && isPhoneExists(user.getSoDienThoai())) {
                throw new RuntimeException("Số điện thoại đã được sử dụng bởi tài khoản khác!");
            }
            
            if (user.getHoTen() == null || user.getHoTen().trim().isEmpty()) {
                throw new RuntimeException("Họ tên không được để trống!");
            }
            
            existingUser.setHoTen(user.getHoTen());
            existingUser.setEmail(user.getEmail());
            existingUser.setSoDienThoai(user.getSoDienThoai());
            existingUser.setDiaChi(user.getDiaChi());
            
            boolean updated = userRepository.updateInfo(existingUser);
            
            if (updated) {
                System.out.println("Cập nhật thông tin user ID: " + user.getNguoiDungId());
            }
            
            return updated;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
    }
    
    // Phương thức mới: Đăng xuất
    public void logout(Long userId) {
        try {
            // Ghi log lịch sử đăng xuất
            String sql = "INSERT INTO lich_su_hoat_dong (nguoi_dung_id, loai_hoat_dong, chi_tiet, thoi_gian) " +
                         "VALUES (?, 'DangXuat', 'Người dùng đã đăng xuất', NOW())";
            jdbcTemplate.update(sql, userId);
            
            System.out.println("Người dùng ID " + userId + " đã đăng xuất");
        } catch (Exception e) {
            System.err.println("Lỗi khi ghi log đăng xuất: " + e.getMessage());
        }
    }
}