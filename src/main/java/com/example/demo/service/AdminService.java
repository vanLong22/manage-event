package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

@Service
public class AdminService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private UserService userService;

    @Autowired
    private EventService eventService;

    @Autowired
    private EventSuggestionService eventSuggestionService;

    public Map<String, Object> getDashboardStats() {
        String sql = """
            SELECT 
                (SELECT COUNT(*) FROM nguoi_dung) as totalUsers,
                (SELECT COUNT(*) FROM su_kien) as totalEvents,
                (SELECT COUNT(*) FROM dang_su_kien WHERE trang_thai = 'ChoDuyet') as pendingSuggestions,
                (SELECT COUNT(*) FROM su_kien WHERE trang_thai = 'DangDienRa') as activeEvents
            """;
        
        return jdbcTemplate.queryForMap(sql);
    }

    public boolean updateUserStatus(Long userId, String status) {
        String sql = "UPDATE nguoi_dung SET trang_thai = ? WHERE nguoi_dung_id = ?";
        int affectedRows = jdbcTemplate.update(sql, status, userId);
        return affectedRows > 0;
    }

    public boolean updateEventStatus(Long eventId, String status) {
        String sql = "UPDATE su_kien SET trang_thai = ? WHERE su_kien_id = ?";
        int affectedRows = jdbcTemplate.update(sql, status, eventId);
        return affectedRows > 0;
    }

    public List<Map<String, Object>> getUserActivityLogs(Long userId) {
        String sql = """
            SELECT lshd.*, sk.ten_su_kien 
            FROM lich_su_hoat_dong lshd 
            LEFT JOIN su_kien sk ON lshd.su_kien_id = sk.su_kien_id 
            WHERE lshd.nguoi_dung_id = ? 
            ORDER BY lshd.thoi_gian DESC 
            LIMIT 50
            """;
        return jdbcTemplate.queryForList(sql, userId);
    }

    public List<Map<String, Object>> getSystemLogs() {
        String sql = """
            SELECT * FROM lich_su_hoat_dong 
            ORDER BY thoi_gian DESC 
            LIMIT 100
            """;
        return jdbcTemplate.queryForList(sql);
    }
}