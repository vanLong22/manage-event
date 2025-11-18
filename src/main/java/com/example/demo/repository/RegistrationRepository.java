package com.example.demo.repository;

import com.example.demo.model.Event;
import com.example.demo.model.Registration;
import com.example.demo.model.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Repository
public class RegistrationRepository {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Registration> findByUserId(Long userId) {
        System.out.println("Id người dùng tham gia sự kiện:" + userId);
        return jdbcTemplate.query("SELECT * FROM dang_ky_su_kien WHERE nguoi_dung_id = ?", 
            new BeanPropertyRowMapper<>(Registration.class), userId);
    }

    @Transactional
    public void save(Registration registration) {
        // 1️⃣ Thêm bản ghi đăng ký sự kiện
        String insertSql = "INSERT INTO dang_ky_su_kien (nguoi_dung_id, su_kien_id, thoi_gian_dang_ky, trang_thai) VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(insertSql,
            registration.getNguoiDungId(),
            registration.getSuKienId(),
            registration.getThoiGianDangKy(),
            "DaDuyet" // tự động duyệt luôn
        );

        // 2️⃣ Tăng số lượng người tham gia trong bảng su_kien
        String updateSql = "UPDATE su_kien SET so_luong_da_dang_ky = so_luong_da_dang_ky + 1 WHERE su_kien_id = ?";
        jdbcTemplate.update(updateSql, registration.getSuKienId());
    }

    public void cancel(Long dangKyId) {
        jdbcTemplate.update("DELETE FROM dang_ky_su_kien WHERE dang_ky_su_kien_id = ?", dangKyId);
    }

    public int countByUserIdAndStatus(Long userId, String status) {
        String sql = "SELECT COUNT(*) FROM dang_ky_su_kien WHERE nguoi_dung_id = ? AND trang_thai = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, userId, status);
    }

    public int countUpcomingByUser(Long userId) {
        String sql = """
            SELECT COUNT(*) FROM dang_ky_su_kien dk
            JOIN su_kien sk ON dk.su_kien_id = sk.su_kien_id
            WHERE dk.nguoi_dung_id = ? AND sk.thoi_gian_bat_dau > NOW() AND dk.trang_thai = 'DaDuyet'
            """;
        return jdbcTemplate.queryForObject(sql, Integer.class, userId);
    }

    public List<Registration> findByUserIdWithEvent(Long userId) {
        String sql = """
            SELECT dk.*, sk.ten_su_kien, sk.dia_diem, sk.thoi_gian_bat_dau, sk.thoi_gian_ket_thuc,
                sk.anh_bia, sk.mo_ta, sk.trang_thai, sk.so_luong_da_dang_ky, sk.so_luong_toi_da
            FROM dang_ky_su_kien dk
            JOIN su_kien sk ON dk.su_kien_id = sk.su_kien_id
            WHERE dk.nguoi_dung_id = ?
            ORDER BY dk.thoi_gian_dang_ky DESC
            """;
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Registration reg = new Registration();
            reg.setDangKyId(rs.getLong("dang_ky_su_kien_id"));
            reg.setNguoiDungId(rs.getLong("nguoi_dung_id"));
            reg.setSuKienId(rs.getLong("su_kien_id"));
            reg.setThoiGianDangKy(rs.getTimestamp("thoi_gian_dang_ky"));
            reg.setTrangThai(rs.getString("trang_thai"));

            Event event = new Event();
            event.setSuKienId(rs.getLong("su_kien_id"));
            event.setTenSuKien(rs.getString("ten_su_kien"));
            event.setDiaDiem(rs.getString("dia_diem"));
            event.setThoiGianBatDau(rs.getTimestamp("thoi_gian_bat_dau"));
            event.setThoiGianKetThuc(rs.getTimestamp("thoi_gian_ket_thuc"));
            event.setAnhBia(rs.getString("anh_bia"));
            event.setMoTa(rs.getString("mo_ta"));
            event.setTrangThai(rs.getString("trang_thai"));
            event.setSoLuongDaDangKy(rs.getInt("so_luong_da_dang_ky"));
            event.setSoLuongToiDa(rs.getInt("so_luong_toi_da"));

            reg.setSuKien(event);
            return reg;
        }, userId);
    }

    //Find by event id (with user info)
    public List<Registration> findByEventId(Long suKienId) {
        String sql = """
            SELECT dk.*, 
                nd.ho_ten AS userHoTen,
                nd.email AS userEmail, 
                nd.gioi_tinh AS userGioiTinh,
                nd.dia_chi AS userDiaChi,
                nd.so_dien_thoai AS userSoDienThoai,
                sk.ten_su_kien AS tenSuKien
            FROM dang_ky_su_kien dk
            JOIN nguoi_dung nd ON dk.nguoi_dung_id = nd.nguoi_dung_id
            JOIN su_kien sk ON dk.su_kien_id = sk.su_kien_id
            WHERE dk.su_kien_id = ?
            """;

        return jdbcTemplate.query(sql, new RowMapper<Registration>() {
            @Override
            public Registration mapRow(ResultSet rs, int rowNum) throws SQLException {
                Registration reg = new Registration();
                reg.setDangKyId(rs.getLong("dang_ky_su_kien_id"));
                reg.setNguoiDungId(rs.getLong("nguoi_dung_id"));
                reg.setSuKienId(rs.getLong("su_kien_id"));
                reg.setThoiGianDangKy(rs.getTimestamp("thoi_gian_dang_ky"));
                reg.setTrangThai(rs.getString("trang_thai"));

                User user = new User();
                user.setHoTen(rs.getString("userHoTen"));
                user.setEmail(rs.getString("userEmail"));
                user.setSoDienThoai(rs.getString("userSoDienThoai"));
                user.setGioiTinh(rs.getString("userGioiTinh"));
                user.setDiaChi(rs.getString("userDiaChi"));

                Event event = new Event();
                event.setTenSuKien(rs.getString("tenSuKien"));

                reg.setEvent(event);
                reg.setUser(user);

                // ✅ Print toàn bộ thông tin (cập nhật thêm tên sự kiện)
                System.out.println("Đăng ký ID: " + reg.getDangKyId());
                System.out.println("Người dùng ID: " + reg.getNguoiDungId());
                System.out.println("Sự kiện ID: " + reg.getSuKienId());
                System.out.println("Tên sự kiện: " + event.getTenSuKien());
                System.out.println("Thời gian đăng ký: " + reg.getThoiGianDangKy());
                System.out.println("Trạng thái: " + reg.getTrangThai());

                System.out.println("Họ tên người dùng: " + user.getHoTen());
                System.out.println("Email người dùng: " + user.getEmail());
                System.out.println("Số điện thoại người dùng: " + user.getSoDienThoai());
                System.out.println("Giới tính người dùng: " + user.getGioiTinh());
                System.out.println("Địa chỉ người dùng: " + user.getDiaChi());
                System.out.println("--------------------------------------------------");

                return reg;
            }
        }, suKienId);
    }

    // Thêm mới: All for organizer (join with su_kien)
    public List<Registration> findAllForOrganizer(Long organizerId) {
        String sql = """
            SELECT dk.* FROM dang_ky_su_kien dk
            JOIN su_kien sk ON dk.su_kien_id = sk.su_kien_id
            WHERE sk.nguoi_to_chuc_id = ?
            """;
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Registration.class), organizerId);
    }

    // Thêm mới: Update attendance (giả sử có field trang_thai_diem_danh trong table)
    public void updateAttendance(Long dangKyId, String trangThai) {
        String sql = "UPDATE dang_ky_su_kien SET trang_thai = ? WHERE dang_ky_su_kien_id = ?";
        jdbcTemplate.update(sql, trangThai, dangKyId);
    }

    // Thêm mới: Count active events for organizer
    public int countActiveEvents(Long organizerId) {
        String sql = "SELECT COUNT(*) FROM su_kien WHERE nguoi_to_chuc_id = ? AND trang_thai = 'DangDienRa'";
        return jdbcTemplate.queryForObject(sql, Integer.class, organizerId);
    }

    // Thêm mới: Count total participants
    public int countTotalParticipants(Long organizerId) {
        String sql = """
            SELECT COUNT(*) FROM dang_ky_su_kien dk
            JOIN su_kien sk ON dk.su_kien_id = sk.su_kien_id
            WHERE sk.nguoi_to_chuc_id = ? AND dk.trang_thai = 'DaDuyet'
            """;
        return jdbcTemplate.queryForObject(sql, Integer.class, organizerId);
    }

    // Thêm mới: Count upcoming events
    public int countUpcomingEvents(Long organizerId) {
        String sql = "SELECT COUNT(*) FROM su_kien WHERE nguoi_to_chuc_id = ? AND thoi_gian_bat_dau > NOW()";
        return jdbcTemplate.queryForObject(sql, Integer.class, organizerId);
    }

    // Thêm mới: Count attention events (ví dụ: <50% đăng ký)
    public int countAttentionEvents(Long organizerId) {
        String sql = "SELECT COUNT(*) FROM su_kien WHERE nguoi_to_chuc_id = ? AND so_luong_da_dang_ky < so_luong_toi_da * 0.5";
        return jdbcTemplate.queryForObject(sql, Integer.class, organizerId);
    }

    // Thêm phương thức mới: Lấy tất cả đăng ký (toàn hệ thống)
    public List<Registration> findAll() {
        String sql = "SELECT * FROM dang_ky_su_kien";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Registration.class));
    }

    public Registration findById(Long id) {
        String sql = "SELECT * FROM dang_ky_su_kien WHERE dang_ky_su_kien_id = ?";
        List<Registration> results = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Registration.class), id);
        return results.isEmpty() ? null : results.get(0);
    }

    // Phương thức tạo biểu đồ: Tỷ lệ trạng thái yêu cầu đăng ký (Pie Chart)
    public List<Map<String, Object>> getRequestStatusDistribution() {
        String sql = "SELECT trang_thai, COUNT(dang_ky_su_kien_id) as count FROM dang_ky_su_kien GROUP BY trang_thai";
        return jdbcTemplate.queryForList(sql);
    }

    // Phương thức tạo biểu đồ: Số lượng đăng ký theo thời gian (Line Chart)
    public List<Map<String, Object>> getRegistrationsOverTime(String period) {
        String groupBy;
        switch (period) {
            case "week":
                groupBy = "WEEK(thoi_gian_dang_ky)";
                break;
            case "month":
                groupBy = "MONTH(thoi_gian_dang_ky)";
                break;
            case "quarter":
                groupBy = "QUARTER(thoi_gian_dang_ky)";
                break;
            case "year":
                groupBy = "YEAR(thoi_gian_dang_ky)";
                break;
            default:
                groupBy = "DATE(thoi_gian_dang_ky)";
        }
        String sql = "SELECT DATE(thoi_gian_dang_ky) AS ngay, COUNT(dang_ky_su_kien_id) AS count FROM dang_ky_su_kien GROUP BY " + groupBy + " ORDER BY ngay";
        return jdbcTemplate.queryForList(sql);
    }
}
 