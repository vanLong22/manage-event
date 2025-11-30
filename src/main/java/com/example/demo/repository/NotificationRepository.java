package com.example.demo.repository;

import com.example.demo.model.Notification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.List;

@Repository
public class NotificationRepository {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // RowMapper cho Notification - ánh xạ đúng với model của bạn
    private static class NotificationRowMapper implements RowMapper<Notification> {
        @Override
        public Notification mapRow(ResultSet rs, int rowNum) throws SQLException {
            Notification notification = new Notification();
            notification.setThongBaoId(rs.getLong("thong_bao_id"));
            notification.setNguoiDungId(rs.getLong("nguoi_dung_id"));
            notification.setNoiDung(rs.getString("noi_dung"));
            notification.setThoiGian(rs.getTimestamp("thoi_gian_gui")); // Ánh xạ thoi_gian_gui -> thoiGian
            notification.setDaDoc(rs.getLong("da_doc"));
            notification.setLoaiThongBao(rs.getString("loai_thong_bao"));
            notification.setTieuDe(rs.getString("tieu_de"));
            notification.setSuKienId(rs.getLong("su_kien_id"));
            return notification;
        }
    }

    // Lưu thông báo mới và trả về ID
    public Long save(Notification notification) {
        String sql = "INSERT INTO thong_bao (tieu_de, noi_dung, loai_thong_bao, nguoi_dung_id, su_kien_id, da_doc, thoi_gian_gui) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, notification.getTieuDe());
            ps.setString(2, notification.getNoiDung());
            ps.setString(3, notification.getLoaiThongBao());
            ps.setLong(4, notification.getNguoiDungId());
            ps.setObject(5, notification.getSuKienId() != null ? notification.getSuKienId() : null);
            ps.setLong(6, notification.getDaDoc() != null ? notification.getDaDoc() : 0L);
            ps.setTimestamp(7, notification.getThoiGian() != null ? 
                new Timestamp(notification.getThoiGian().getTime()) : new Timestamp(System.currentTimeMillis()));
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey() != null ? keyHolder.getKey().longValue() : null;
    }

    // Lấy thông báo theo user ID
    public List<Notification> findByUserId(Long userId) {
        String sql = "SELECT * FROM thong_bao WHERE nguoi_dung_id = ? ORDER BY thoi_gian_gui DESC";
        return jdbcTemplate.query(sql, new NotificationRowMapper(), userId);
    }

    // Lấy thông báo theo ID
    public Notification findById(Long id) {
        try {
            return jdbcTemplate.queryForObject(
                "SELECT * FROM thong_bao WHERE thong_bao_id = ?",
                new NotificationRowMapper(),
                id
            );
        } catch (Exception e) {
            return null;
        }
    }

    // Đánh dấu đã đọc
    public void markAsRead(Long thongBaoId) {
        jdbcTemplate.update(
            "UPDATE thong_bao SET da_doc = 1 WHERE thong_bao_id = ?", 
            thongBaoId
        );
    }

    // Đánh dấu tất cả là đã đọc cho user
    public void markAllAsRead(Long userId) {
        jdbcTemplate.update(
            "UPDATE thong_bao SET da_doc = 1 WHERE nguoi_dung_id = ?", 
            userId
        );
    }

    // Xóa thông báo
    public boolean deleteNotification(Long notificationId, Long userId) {
        int affectedRows = jdbcTemplate.update(
            "DELETE FROM thong_bao WHERE thong_bao_id = ? AND nguoi_dung_id = ?",
            notificationId, userId
        );
        return affectedRows > 0;
    }

        public boolean updateNotificationStatus(Long notificationId, String status) {
        int affectedRows = jdbcTemplate.update(
            "UPDATE thong_bao SET trang_thai = ? WHERE thong_bao_id = ?",
            status, notificationId
        );
        return affectedRows > 0;
    }

    // Đếm số thông báo chưa đọc
    public int countUnreadNotifications(Long userId) {
        Integer count = jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM thong_bao WHERE nguoi_dung_id = ? AND da_doc = 0",
            Integer.class,
            userId
        );
        return count != null ? count : 0;
    }

    // Lấy thông báo theo loại
    public List<Notification> findByTypeAndUserId(String loaiThongBao, Long userId) {
        String sql = "SELECT * FROM thong_bao WHERE loai_thong_bao = ? AND nguoi_dung_id = ? ORDER BY thoi_gian_gui DESC";
        return jdbcTemplate.query(sql, new NotificationRowMapper(), loaiThongBao, userId);
    }

    // Lấy thông báo theo sự kiện
    public List<Notification> findByEventId(Long suKienId) {
        String sql = "SELECT * FROM thong_bao WHERE su_kien_id = ? ORDER BY thoi_gian_gui DESC";
        return jdbcTemplate.query(sql, new NotificationRowMapper(), suKienId);
    }

    // Lấy thông báo gần đây (giới hạn số lượng)
    public List<Notification> findRecentByUserId(Long userId, int limit) {
        String sql = "SELECT * FROM thong_bao WHERE nguoi_dung_id = ? ORDER BY thoi_gian_gui DESC LIMIT ?";
        return jdbcTemplate.query(sql, new NotificationRowMapper(), userId, limit);
    }

    // Cập nhật thông báo
    public boolean updateNotification(Notification notification) {
        int affectedRows = jdbcTemplate.update(
            "UPDATE thong_bao SET tieu_de = ?, noi_dung = ?, loai_thong_bao = ?, " +
            "nguoi_dung_id = ?, su_kien_id = ?, da_doc = ?, thoi_gian_gui = ? " +
            "WHERE thong_bao_id = ?",
            notification.getTieuDe(),
            notification.getNoiDung(),
            notification.getLoaiThongBao(),
            notification.getNguoiDungId(),
            notification.getSuKienId(),
            notification.getDaDoc(),
            notification.getThoiGian(),
            notification.getThongBaoId()
        );
        return affectedRows > 0;
    }

    // Xóa thông báo cũ (theo ngày)
    public int deleteOldNotifications(java.util.Date beforeDate) {
        return jdbcTemplate.update(
            "DELETE FROM thong_bao WHERE thoi_gian_gui < ?",
            new Timestamp(beforeDate.getTime())
        );
    }

    // Thống kê thông báo theo loại
    public List<java.util.Map<String, Object>> getNotificationStatsByType(Long userId) {
        String sql = "SELECT loai_thong_bao, COUNT(*) as count, SUM(da_doc = 0) as unread " +
                     "FROM thong_bao WHERE nguoi_dung_id = ? GROUP BY loai_thong_bao";
        
        return jdbcTemplate.query(sql, new RowMapper<java.util.Map<String, Object>>() {
            @Override
            public java.util.Map<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
                java.util.Map<String, Object> stats = new java.util.HashMap<>();
                stats.put("loaiThongBao", rs.getString("loai_thong_bao"));
                stats.put("count", rs.getInt("count"));
                stats.put("unread", rs.getInt("unread"));
                return stats;
            }
        }, userId);
    }
}