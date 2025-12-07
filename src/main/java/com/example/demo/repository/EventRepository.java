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
    
    // Hàm tính toán trạng thái thời gian
    private String calculateTimeStatus(Date startTime, Date endTime) {
        Date now = new Date();
        if (now.before(startTime)) {
            return "SapDienRa";
        } else if (now.after(endTime)) {
            return "DaKetThuc";
        } else {
            return "DangDienRa";
        }
    }

    public List<Event> findAll() {
        return jdbcTemplate.query("SELECT * FROM su_kien", new BeanPropertyRowMapper<>(Event.class));
    }

    public List<Event> findFeatured() {
        return jdbcTemplate.query("SELECT * FROM su_kien WHERE trang_thai_thoigian = 'DangDienRa' ORDER BY ngay_tao DESC LIMIT 3", 
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
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM dang_ky_su_kien WHERE su_kien_id = ? AND trang_thai_phe_duyet = 'DA_DUYET'", Integer.class, suKienId);
    }

    public List<Event> findTop6PublicUpcoming() {
        String sql = """
            SELECT * FROM su_kien 
            WHERE loai_su_kien = 'CongKhai' 
              AND trang_thai_thoigian IN ('SapDienRa', 'DangDienRa')
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
              AND trang_thai_thoigian IN ('SapDienRa', 'DangDienRa')
              AND so_luong_da_dang_ky < so_luong_toi_da
            ORDER BY thoi_gian_bat_dau ASC
            """;
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Event.class));
    }

    public List<Event> searchEvents(String keyword) {
        String sql = """
            SELECT * FROM su_kien 
            WHERE (ten_su_kien LIKE ? OR mo_ta LIKE ? OR dia_diem LIKE ?)
            AND trang_thai_thoigian IN ('SapDienRa', 'DangDienRa')
            LIMIT 10
            """;

        String likePattern = "%" + keyword + "%";

        return jdbcTemplate.query(sql, 
            new BeanPropertyRowMapper<>(Event.class),
            likePattern, likePattern, likePattern
        );
    }

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
            sql += " AND trang_thai_thoigian = ?";
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
        // Tính toán trạng thái thời gian dựa trên ngày hiện tại
        String trangThaiThoiGian = calculateTimeStatus(suKien.getThoiGianBatDau(), suKien.getThoiGianKetThuc());
        
        String sql = "INSERT INTO su_kien (ten_su_kien, mo_ta, dia_diem, anh_bia, loai_su_kien_id, nguoi_to_chuc_id, " +
                     "thoi_gian_bat_dau, thoi_gian_ket_thuc, loai_su_kien, mat_khau_su_kien_rieng_tu, " +
                     "trang_thai_thoigian, trang_thai_phe_duyet, so_luong_toi_da, so_luong_da_dang_ky, ngay_tao) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        jdbcTemplate.update(sql, 
            suKien.getTenSuKien(), 
            suKien.getMoTa(), 
            suKien.getDiaDiem(), 
            suKien.getAnhBia(), 
            suKien.getLoaiSuKienId(), 
            suKien.getNguoiToChucId(), 
            suKien.getThoiGianBatDau(), 
            suKien.getThoiGianKetThuc(), 
            suKien.getLoaiSuKien(), 
            suKien.getMatKhauSuKienRiengTu(), 
            trangThaiThoiGian, // Trạng thái thời gian đã tính toán
            "ChoDuyet", // Trạng thái phê duyệt mặc định
            suKien.getSoLuongToiDa(), 
            0, 
            suKien.getNgayTao()
        );
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

    // Thêm phương thức mới: Popular events toàn hệ thống (top N by registrations)
    public List<Event> findPopularEvents(int limit) {
        String sql = "SELECT * FROM su_kien ORDER BY so_luong_da_dang_ky DESC LIMIT ?";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Event.class), limit);
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

        // Lọc theo trạng thái thời gian
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND trang_thai_thoigian = ?");
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
        // Lấy thông tin sự kiện cũ
        Event existingEvent = findById(suKien.getSuKienId());
        if (existingEvent == null) {
            throw new RuntimeException("Event not found");
        }
        
        // Tính toán trạng thái thời gian mới
        String trangThaiThoiGian = calculateTimeStatus(suKien.getThoiGianBatDau(), suKien.getThoiGianKetThuc());
        
        // Giữ lại ảnh bìa cũ nếu không có ảnh mới
        String anhBia = suKien.getAnhBia() != null ? suKien.getAnhBia() : existingEvent.getAnhBia();
        
        // Giữ lại trạng thái phê duyệt cũ
        String trangThaiPheDuyet = existingEvent.getTrangThaiPheDuyet() != null ? 
                                  existingEvent.getTrangThaiPheDuyet() : "ChoDuyet";
        
        String sql = "UPDATE su_kien SET ten_su_kien = ?, mo_ta = ?, dia_diem = ?, anh_bia = ?, " +
                     "thoi_gian_bat_dau = ?, thoi_gian_ket_thuc = ?, loai_su_kien = ?, " +
                     "trang_thai_thoigian = ?, trang_thai_phe_duyet = ?, so_luong_toi_da = ? " +
                     "WHERE su_kien_id = ?";
                     
        jdbcTemplate.update(sql, 
            suKien.getTenSuKien(), 
            suKien.getMoTa(), 
            suKien.getDiaDiem(), 
            anhBia,
            suKien.getThoiGianBatDau(), 
            suKien.getThoiGianKetThuc(), 
            suKien.getLoaiSuKien(), 
            trangThaiThoiGian,
            trangThaiPheDuyet,
            suKien.getSoLuongToiDa(), 
            suKien.getSuKienId()
        );
    }

    // Phương thức tạo biểu đồ: Số lượng sự kiện theo loại (Bar Chart)
    public List<Map<String, Object>> getEventsByType(Long organizerId) {
        String sql = """
            SELECT l.ten_loai, COUNT(s.su_kien_id) as count 
            FROM su_kien s 
            JOIN loai_su_kien l ON s.loai_su_kien_id = l.loai_su_kien_id 
            WHERE s.nguoi_to_chuc_id = ? 
            GROUP BY l.ten_loai
            """;
        return jdbcTemplate.queryForList(sql, organizerId);
    }

    public List<Event> getEventsByIds(List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return new ArrayList<>();
        }

        // Tạo chuỗi placeholder (?, ?, ...) tương ứng số lượng IDs
        String placeholders = String.join(",", ids.stream().map(id -> "?").toArray(String[]::new));
        String sql = "SELECT * FROM su_kien WHERE su_kien_id IN (" + placeholders + ")";

        // Chuyển List<Long> sang Object[] để truyền vào jdbcTemplate
        Object[] params = ids.toArray();

        return jdbcTemplate.query(sql, params, new BeanPropertyRowMapper<>(Event.class));
    }

    // Phương thức cập nhật trạng thái thời gian cho tất cả sự kiện
    public void updateAllTimeStatus() {
        String sql = """
            UPDATE su_kien 
            SET trang_thai_thoigian = CASE 
                WHEN NOW() < thoi_gian_bat_dau THEN 'SapDienRa'
                WHEN NOW() > thoi_gian_ket_thuc THEN 'DaKetThuc'
                ELSE 'DangDienRa'
            END
            """;
        jdbcTemplate.update(sql);
    }
}