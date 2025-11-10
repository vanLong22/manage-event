package com.example.demo.repository;

import com.example.demo.model.Notification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class NotificationRepository {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Notification> findByUserId(Long userId) {
        System.out.println("Sự kiện của người dùng đăng ký là: " + userId);
        return jdbcTemplate.query(
            "SELECT * FROM thong_bao WHERE nguoi_dung_id = ? ORDER BY thoi_gian_gui DESC", 
            new BeanPropertyRowMapper<>(Notification.class), 
            userId
        );
    }

    public Notification findById(Long id) {
        try {
            return jdbcTemplate.queryForObject(
                "SELECT * FROM thong_bao WHERE thong_bao_id = ?",
                new BeanPropertyRowMapper<>(Notification.class),
                id
            );
        } catch (Exception e) {
            return null;
        }
    }

    public void markAsRead(Long thongBaoId) {
        jdbcTemplate.update(
            "UPDATE thong_bao SET da_doc = 1 WHERE thong_bao_id = ?", 
            thongBaoId
        );
    }

    public void markAllAsRead(Long userId) {
        jdbcTemplate.update(
            "UPDATE thong_bao SET da_doc = 1 WHERE nguoi_dung_id = ?", 
            userId
        );
    }

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

    public int countUnreadNotifications(Long userId) {
        Integer count = jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM thong_bao WHERE nguoi_dung_id = ? AND da_doc = 0",
            Integer.class,
            userId
        );
        return count != null ? count : 0;
    }
}