package com.example.demo.repository;

import com.example.demo.model.Event;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Repository
public class EventRepository {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    
    public List<Event> findAll() {
        return jdbcTemplate.query("SELECT * FROM su_kien", new BeanPropertyRowMapper<>(Event.class));
    }

    public List<Event> findFeatured() {
        return jdbcTemplate.query("SELECT * FROM su_kien WHERE trang_thai = 'DangDienRa' ORDER BY ngay_tao DESC LIMIT 3", 
            new BeanPropertyRowMapper<>(Event.class));
    }

    public List<Event> findByUserId(Long userId) {
        System.out.println("su kiện của người dùng đăng ký là   : " +userId);
        return jdbcTemplate.query("SELECT sk.* FROM su_kien sk INNER JOIN dang_ky_su_kien dk ON sk.su_kien_id = dk.su_kien_id WHERE dk.nguoi_dung_id = ?", 
            new BeanPropertyRowMapper<>(Event.class), userId);
    }

    public Event findById(Long id) {
        try {
            return jdbcTemplate.queryForObject("SELECT * FROM su_kien WHERE su_kien_id = ?", 
                new BeanPropertyRowMapper<>(Event.class), id);
        } catch (Exception e) {
            return null;
        }
    }

    public int countRegistrations(Long suKienId) {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM dang_ky_su_kien WHERE su_kien_id = ? AND trang_thai = 'DA_DUYET'", Integer.class, suKienId);
    }

    public List<Event> findTop6PublicUpcoming() {
        String sql = """
            SELECT * FROM su_kien 
            WHERE loai_su_kien = 'CongKhai' 
              AND trang_thai IN ('SapDienRa', 'DangDienRa')
              AND so_luong_da_dang_ky < so_luong_toi_da
            ORDER BY thoi_gian_bat_dau ASC 
            LIMIT 6
            """;
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Event.class));
    }

    public List<Event> findPublicAvailable() {
        String sql = """
            SELECT * FROM su_kien 
            WHERE loai_su_kien = 'CongKhai' 
              AND trang_thai IN ('SapDienRa', 'DangDienRa')
              AND so_luong_da_dang_ky < so_luong_toi_da
            ORDER BY thoi_gian_bat_dau ASC
            """;
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Event.class));
    }

    public List<Event> searchEvents(String keyword) {
        String sql = """
            SELECT * FROM su_kien 
            WHERE (ten_su_kien LIKE ? OR mo_ta LIKE ? OR dia_diem LIKE ?)
            AND trang_thai IN ('SapDienRa', 'DangDienRa')
            LIMIT 10
            """;

        String likePattern = "%" + keyword + "%";

        return jdbcTemplate.query(sql, 
            new BeanPropertyRowMapper<>(Event.class),
            likePattern, likePattern, likePattern
        );
    }

    // Trong EventRepository.java
    public List<Event> searchEventsWithFilters(String keyword, String status, String privacy, Long categoryId) {
        String sql = "SELECT * FROM su_kien WHERE 1=1";
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            String likePattern = "%" + keyword + "%";
            sql += " AND (ten_su_kien LIKE ? OR mo_ta LIKE ? OR dia_diem LIKE ?)";
            params.add(likePattern);
            params.add(likePattern);
            params.add(likePattern);
        }

        if (status != null && !status.isEmpty()) {
            sql += " AND trang_thai = ?";
            params.add(status);
        }

        if (privacy != null && !privacy.isEmpty()) {
            sql += " AND loai_su_kien = ?";
            params.add(privacy);
        }

        if (categoryId != null) {
            sql += " AND loai_su_kien_id = ?";
            params.add(categoryId);
        }

        sql += " ORDER BY thoi_gian_bat_dau ASC";

        return jdbcTemplate.query(sql, params.toArray(), new BeanPropertyRowMapper<>(Event.class));
    }

    public List<Event> findByOrganizer(Long organizerId) {
        String sql = "SELECT * FROM su_kien WHERE nguoi_to_chuc_id = ?";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Event.class), organizerId);
    }

    public void save(Event suKien) {
        String sql = "INSERT INTO su_kien (ten_su_kien, mo_ta, dia_diem, anh_bia, loai_su_kien_id, nguoi_to_chuc_id, " +
                     "thoi_gian_bat_dau, thoi_gian_ket_thuc, loai_su_kien, mat_khau_su_kien_rieng_tu, trang_thai, so_luong_toi_da, so_luong_da_dang_ky, ngay_tao) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, suKien.getTenSuKien(), suKien.getMoTa(), suKien.getDiaDiem(), 
                suKien.getAnhBia(), suKien.getLoaiSuKienId(), suKien.getNguoiToChucId(), suKien.getThoiGianBatDau(), 
                suKien.getThoiGianKetThuc(), suKien.getLoaiSuKien(), suKien.getMatKhauSuKienRiengTu(), suKien.getTrangThai(), 
                suKien.getSoLuongToiDa(), 0, suKien.getNgayTao());
    }

    // Thêm mới: Upcoming by organizer
    public List<Event> findUpcomingByOrganizer(Long organizerId) {
        String sql = "SELECT * FROM su_kien WHERE nguoi_to_chuc_id = ? AND thoi_gian_bat_dau > NOW() ORDER BY thoi_gian_bat_dau ASC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Event.class), organizerId);
    }

    // Thêm mới: Popular by organizer (top 5 by registrations)
    public List<Event> findPopularByOrganizer(Long organizerId) {
        String sql = "SELECT * FROM su_kien WHERE nguoi_to_chuc_id = ? ORDER BY so_luong_da_dang_ky DESC LIMIT 5";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Event.class), organizerId);
    }

    // Thêm mới: Delete
    public void delete(Long id) {
        String sql = "DELETE FROM su_kien WHERE su_kien_id = ?";
        jdbcTemplate.update(sql, id);
    }

    public List<Event> filterEvents(String keyword, String eventType, Date startDate, Date endDate, 
                                String location, Long categoryId, String status) {
        StringBuilder sql = new StringBuilder("SELECT * FROM su_kien WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Lọc theo từ khóa
        if (keyword != null && !keyword.trim().isEmpty()) {
            String likePattern = "%" + keyword.trim() + "%";
            sql.append(" AND (ten_su_kien LIKE ? OR mo_ta LIKE ? OR dia_diem LIKE ?)");
            params.add(likePattern);
            params.add(likePattern);
            params.add(likePattern);
        }

        // Lọc theo loại sự kiện (riêng tư/công khai)
        if (eventType != null && !eventType.trim().isEmpty()) {
            sql.append(" AND loai_su_kien = ?");
            params.add(eventType);
        }

        // Lọc theo thời gian bắt đầu
        if (startDate != null) {
            sql.append(" AND thoi_gian_bat_dau >= ?");
            params.add(new java.sql.Timestamp(startDate.getTime()));
        }

        // Lọc theo thời gian kết thúc
        if (endDate != null) {
            sql.append(" AND thoi_gian_ket_thuc <= ?");
            params.add(new java.sql.Timestamp(endDate.getTime()));
        }

        // Lọc theo địa điểm
        if (location != null && !location.trim().isEmpty()) {
            String likeLocation = "%" + location.trim() + "%";
            sql.append(" AND dia_diem LIKE ?");
            params.add(likeLocation);
        }

        // Lọc theo danh mục sự kiện
        if (categoryId != null) {
            sql.append(" AND loai_su_kien_id = ?");
            params.add(categoryId);
        }

        // Lọc theo trạng thái
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND trang_thai = ?");
            params.add(status);
        }

        sql.append(" ORDER BY thoi_gian_bat_dau ASC");

        return jdbcTemplate.query(sql.toString(), params.toArray(), new BeanPropertyRowMapper<>(Event.class));
    }

    // Thêm phương thức lấy tên loại sự kiện bằng tiếng Việt
    public String getEventTypeName(Long categoryId) {
        if (categoryId == null) return null;
        
        try {
            String sql = "SELECT ten_loai FROM loai_su_kien WHERE loai_su_kien_id = ?";
            return jdbcTemplate.queryForObject(sql, String.class, categoryId);
        } catch (Exception e) {
            return null;
        }
    }

    // Phương thức lấy tất cả loại sự kiện với tên tiếng Việt
    public List<Map<String, Object>> getAllEventTypesWithNames() {
        String sql = "SELECT loai_su_kien_id, ten_loai FROM loai_su_kien ORDER BY ten_loai";
        return jdbcTemplate.queryForList(sql);
    }

    public void update(Event suKien) {
        String sql = "UPDATE su_kien SET ten_su_kien = ?, mo_ta = ?, dia_diem = ?, anh_bia = ?, " +
                     "thoi_gian_bat_dau = ?, thoi_gian_ket_thuc = ?, loai_su_kien = ?, trang_thai = ?, so_luong_toi_da = ? " +
                     "WHERE su_kien_id = ?";
        jdbcTemplate.update(sql, suKien.getTenSuKien(), suKien.getMoTa(), suKien.getDiaDiem(), 
                suKien.getAnhBia(), suKien.getThoiGianBatDau(), suKien.getThoiGianKetThuc(), 
                suKien.getLoaiSuKien(), suKien.getTrangThai(), suKien.getSoLuongToiDa(), suKien.getSuKienId());
    }
}