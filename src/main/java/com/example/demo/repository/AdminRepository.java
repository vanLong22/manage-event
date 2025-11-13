package com.example.demo.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
public class AdminRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Map<String, Object>> findUsersWithStats() {
        String sql = """
            SELECT 
                nd.*,
                (SELECT COUNT(*) FROM su_kien sk WHERE sk.nguoi_to_chuc_id = nd.nguoi_dung_id) as organizedEvents,
                (SELECT COUNT(*) FROM dang_ky_su_kien dk WHERE dk.nguoi_dung_id = nd.nguoi_dung_id) as participatedEvents
            FROM nguoi_dung nd
            ORDER BY nd.ngay_tao DESC
            """;
        return jdbcTemplate.queryForList(sql);
    }

    public List<Map<String, Object>> findEventsWithDetails() {
        String sql = """
            SELECT 
                sk.*,
                nd.ho_ten as organizer_name,
                lsk.ten_loai as event_type_name,
                (SELECT COUNT(*) FROM dang_ky_su_kien dk WHERE dk.su_kien_id = sk.su_kien_id) as registration_count
            FROM su_kien sk
            LEFT JOIN nguoi_dung nd ON sk.nguoi_to_chuc_id = nd.nguoi_dung_id
            LEFT JOIN loai_su_kien lsk ON sk.loai_su_kien_id = lsk.loai_su_kien_id
            ORDER BY sk.ngay_tao DESC
            """;
        return jdbcTemplate.queryForList(sql);
    }

    public Map<String, Object> getSystemStatistics() {
        String sql = """
            SELECT 
                (SELECT COUNT(*) FROM nguoi_dung) as total_users,
                (SELECT COUNT(*) FROM nguoi_dung WHERE vai_tro = 'ToChuc') as total_organizers,
                (SELECT COUNT(*) FROM su_kien) as total_events,
                (SELECT COUNT(*) FROM su_kien WHERE trang_thai = 'DangDienRa') as active_events,
                (SELECT COUNT(*) FROM su_kien WHERE trang_thai = 'SapDienRa') as upcoming_events,
                (SELECT COUNT(*) FROM dang_ky_su_kien) as total_registrations,
                (SELECT COUNT(*) FROM dang_su_kien WHERE trang_thai = 'ChoDuyet') as pending_suggestions
            """;
        return jdbcTemplate.queryForMap(sql);
    }

    public boolean banUser(Long userId) {
        String sql = "UPDATE nguoi_dung SET trang_thai = 'Banned' WHERE nguoi_dung_id = ?";
        int affectedRows = jdbcTemplate.update(sql, userId);
        return affectedRows > 0;
    }

    public boolean activateUser(Long userId) {
        String sql = "UPDATE nguoi_dung SET trang_thai = 'Active' WHERE nguoi_dung_id = ?";
        int affectedRows = jdbcTemplate.update(sql, userId);
        return affectedRows > 0;
    }
}