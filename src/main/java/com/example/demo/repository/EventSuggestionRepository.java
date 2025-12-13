package com.example.demo.repository;

import com.example.demo.model.EventSuggestion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public class EventSuggestionRepository {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Custom RowMapper để handle snake_case columns -> camelCase properties
    private static class EventSuggestionRowMapper implements RowMapper<EventSuggestion> {
        @Override
        public EventSuggestion mapRow(ResultSet rs, int rowNum) throws SQLException {
            EventSuggestion suggestion = new EventSuggestion();
            suggestion.setDangSuKienId(rs.getLong("dang_su_kien_id"));
            suggestion.setNguoiDungId(rs.getLong("nguoi_dung_id"));
            suggestion.setTieuDe(rs.getString("tieu_de"));
            suggestion.setMoTaNhuCau(rs.getString("mo_ta_nhu_cau"));
            suggestion.setLoaiSuKienId(rs.getInt("loai_su_kien_id"));
            suggestion.setDiaDiem(rs.getString("dia_diem"));
            suggestion.setThoiGianDuKien(rs.getTimestamp("thoi_gian_du_kien"));
            suggestion.setSoLuongKhach(rs.getInt("so_luong_khach"));
            suggestion.setGiaCaLong(rs.getString("gia_ca_long"));
            suggestion.setThongTinLienLac(rs.getString("thong_tin_lien_lac"));
            suggestion.setTrangThai(rs.getString("trang_thai"));
            suggestion.setTrangThaiPheDuyet(rs.getString("trang_thai_phe_duyet"));
            suggestion.setThoiGianTao(rs.getTimestamp("thoi_gian_tao"));
            suggestion.setThoiGianPhanHoi(rs.getTimestamp("thoi_gian_phan_hoi"));
            return suggestion;
        }
    }

    // Phương thức tự động cập nhật trạng thái thành "Huy" nếu thời gian dự kiến cách ngày hiện tại <= 1 ngày
    public void autoUpdateStatusForUpcomingEvents() {
        String sql = "UPDATE dang_su_kien " +
                     "SET trang_thai = 'Huy' " +
                     "WHERE trang_thai_phe_duyet = 'DaDuyet' " +
                     "AND thoi_gian_du_kien IS NOT NULL " +
                     "AND DATEDIFF(thoi_gian_du_kien, NOW()) <= 1 " +
                     "AND trang_thai != 'Huy' " +
                     "AND trang_thai != 'TuChoi'";
        jdbcTemplate.update(sql);
    }

    public List<EventSuggestion> findByUserId(Long userId) {
        String sql = "SELECT * FROM dang_su_kien WHERE nguoi_dung_id = ? AND trang_thai_phe_duyet IS NOT NULL ORDER BY thoi_gian_tao DESC";
        return jdbcTemplate.query(sql, new EventSuggestionRowMapper(), userId);
    }

    public EventSuggestion findById(Long id) {
        try {
            return jdbcTemplate.queryForObject(
                "SELECT * FROM dang_su_kien WHERE dang_su_kien_id = ? AND trang_thai_phe_duyet IS NOT NULL",
                new EventSuggestionRowMapper(),
                id
            );
        } catch (Exception e) {
            return null;
        }
    }

    public Optional<EventSuggestion> findByIdAndUserId(Long id, Long userId) {
        try {
            EventSuggestion suggestion = jdbcTemplate.queryForObject(
                "SELECT * FROM dang_su_kien WHERE dang_su_kien_id = ? AND nguoi_dung_id = ? AND trang_thai_phe_duyet IS NOT NULL",
                new EventSuggestionRowMapper(),
                id, userId
            );
            return Optional.ofNullable(suggestion);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    public void save(EventSuggestion suggestion) {
        String sql = "INSERT INTO dang_su_kien (" +
                     "nguoi_dung_id, tieu_de, mo_ta_nhu_cau, loai_su_kien_id, " +
                     "dia_diem, thoi_gian_du_kien, so_luong_khach, gia_ca_long, " +
                     "thong_tin_lien_lac, trang_thai, trang_thai_phe_duyet, thoi_gian_tao) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        jdbcTemplate.update(sql,
            suggestion.getNguoiDungId(),
            suggestion.getTieuDe(),
            suggestion.getMoTaNhuCau(),
            suggestion.getLoaiSuKienId(),
            suggestion.getDiaDiem(),
            suggestion.getThoiGianDuKien(),
            suggestion.getSoLuongKhach(),
            suggestion.getGiaCaLong(),
            suggestion.getThongTinLienLac(),
            suggestion.getTrangThai() != null ? suggestion.getTrangThai() : "CHO_DUYET",
            "ChoDuyet", // Trạng thái phê duyệt mặc định
            suggestion.getThoiGianTao()
        );
    }

    public Long saveAndReturnId(EventSuggestion suggestion) {
        String sql = "INSERT INTO dang_su_kien (" +
                     "nguoi_dung_id, tieu_de, mo_ta_nhu_cau, loai_su_kien_id, " +
                     "dia_diem, thoi_gian_du_kien, so_luong_khach, gia_ca_long, " +
                     "thong_tin_lien_lac, trang_thai, trang_thai_phe_duyet, thoi_gian_tao) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, suggestion.getNguoiDungId());
            ps.setString(2, suggestion.getTieuDe());
            ps.setString(3, suggestion.getMoTaNhuCau());
            ps.setInt(4, suggestion.getLoaiSuKienId());
            ps.setString(5, suggestion.getDiaDiem());
            ps.setTimestamp(6, suggestion.getThoiGianDuKien() != null ? 
                new Timestamp(suggestion.getThoiGianDuKien().getTime()) : null);
            ps.setInt(7, suggestion.getSoLuongKhach());
            ps.setString(8, suggestion.getGiaCaLong());
            ps.setString(9, suggestion.getThongTinLienLac());
            ps.setString(10, suggestion.getTrangThai() != null ? suggestion.getTrangThai() : "CHO_DUYET");
            ps.setString(11, "ChoDuyet"); // Trạng thái phê duyệt mặc định
            ps.setTimestamp(12, suggestion.getThoiGianTao() != null ? 
                new Timestamp(suggestion.getThoiGianTao().getTime()) : new Timestamp(System.currentTimeMillis()));
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey() != null ? keyHolder.getKey().longValue() : null;
    }

    public boolean deleteSuggestion(Long suggestionId, Long userId) {
        int affectedRows = jdbcTemplate.update(
            "DELETE FROM dang_su_kien WHERE dang_su_kien_id = ? AND nguoi_dung_id = ?",
            suggestionId, userId
        );
        return affectedRows > 0;
    }

    public boolean updateSuggestion(EventSuggestion suggestion) {
        int affectedRows = jdbcTemplate.update(
            "UPDATE dang_su_kien SET tieu_de = ?, mo_ta_nhu_cau = ?, loai_su_kien_id = ?, " +
            "dia_diem = ?, thoi_gian_du_kien = ?, so_luong_khach = ?, gia_ca_long = ?, " +
            "thong_tin_lien_lac = ?, trang_thai = ?, trang_thai_phe_duyet = ? WHERE dang_su_kien_id = ? AND nguoi_dung_id = ?",
            suggestion.getTieuDe(),
            suggestion.getMoTaNhuCau(),
            suggestion.getLoaiSuKienId(),
            suggestion.getDiaDiem(),
            suggestion.getThoiGianDuKien(),
            suggestion.getSoLuongKhach(),
            suggestion.getGiaCaLong(),
            suggestion.getThongTinLienLac(),
            suggestion.getTrangThai(),
            suggestion.getTrangThaiPheDuyet(),
            suggestion.getDangSuKienId(),
            suggestion.getNguoiDungId()
        );
        return affectedRows > 0;
    }

    public boolean updateSuggestionStatus(Long suggestionId, String status) {
        int affectedRows = jdbcTemplate.update(
            "UPDATE dang_su_kien SET trang_thai = ?, thoi_gian_phan_hoi = CURRENT_TIMESTAMP WHERE dang_su_kien_id = ?",
            status, suggestionId
        );
        return affectedRows > 0;
    }
    
    public boolean updateSuggestionApprovalStatus(Long suggestionId, String trangThaiPheDuyet) {
        int affectedRows = jdbcTemplate.update(
            "UPDATE dang_su_kien SET trang_thai_phe_duyet = ? WHERE dang_su_kien_id = ?",
            trangThaiPheDuyet, suggestionId
        );
        return affectedRows > 0;
    }

    public List<EventSuggestion> findByStatus(String status) {
        String sql = "SELECT * FROM dang_su_kien WHERE trang_thai = ? AND trang_thai_phe_duyet IS NOT NULL ORDER BY thoi_gian_tao DESC";
        return jdbcTemplate.query(sql, new EventSuggestionRowMapper(), status);
    }
    
    // Thêm vào EventSuggestionRepository
    public Map<String, Object> findSuggestionDetailById(Long suggestionId) {
        String sql = "SELECT ds.*, nd.ho_ten, nd.email, nd.so_dien_thoai, nd.dia_chi, nd.gioi_tinh, " +
                    "lsk.ten_loai as loai_su_kien_ten, nd.vai_tro " +
                    "FROM dang_su_kien ds " +
                    "LEFT JOIN nguoi_dung nd ON ds.nguoi_dung_id = nd.nguoi_dung_id " +
                    "LEFT JOIN loai_su_kien lsk ON ds.loai_su_kien_id = lsk.loai_su_kien_id " +
                    "WHERE ds.dang_su_kien_id = ? AND ds.trang_thai_phe_duyet IS NOT NULL";

        try {
            return jdbcTemplate.queryForObject(sql, new RowMapper<Map<String, Object>>() {
                @Override
                public Map<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
                    Map<String, Object> result = new java.util.HashMap<>();
                    result.put("dangSuKienId", rs.getLong("dang_su_kien_id"));
                    result.put("nguoiDungId", rs.getLong("nguoi_dung_id"));
                    result.put("tieuDe", rs.getString("tieu_de"));
                    result.put("moTaNhuCau", rs.getString("mo_ta_nhu_cau"));
                    result.put("loaiSuKienId", rs.getInt("loai_su_kien_id"));
                    result.put("loaiSuKienTen", rs.getString("loai_su_kien_ten"));
                    result.put("diaDiem", rs.getString("dia_diem"));
                    result.put("thoiGianDuKien", rs.getTimestamp("thoi_gian_du_kien"));
                    result.put("soLuongKhach", rs.getInt("so_luong_khach"));
                    result.put("giaCaLong", rs.getString("gia_ca_long"));
                    result.put("thongTinLienLac", rs.getString("thong_tin_lien_lac"));
                    result.put("trangThai", rs.getString("trang_thai"));
                    result.put("trangThaiPheDuyet", rs.getString("trang_thai_phe_duyet"));
                    result.put("thoiGianTao", rs.getTimestamp("thoi_gian_tao"));
                    result.put("thoiGianPhanHoi", rs.getTimestamp("thoi_gian_phan_hoi"));
                    
                    // Thông tin user chi tiết
                    Map<String, Object> user = new java.util.HashMap<>();
                    user.put("hoTen", rs.getString("ho_ten"));
                    user.put("email", rs.getString("email"));
                    user.put("soDienThoai", rs.getString("so_dien_thoai"));
                    user.put("diaChi", rs.getString("dia_chi"));
                    user.put("gioiTinh", rs.getString("gioi_tinh"));
                    user.put("vaiTro", rs.getString("vai_tro"));
                    result.put("user", user);
                    
                    return result;
                }
            }, suggestionId);
        } catch (Exception e) {
            return null;
        }
    }
       
    // Thêm phương thức mới: Lọc theo trạng thái phê duyệt
    public List<EventSuggestion> findByApprovalStatus(String trangThaiPheDuyet) {
        String sql = "SELECT * FROM dang_su_kien WHERE trang_thai_phe_duyet = ? ORDER BY thoi_gian_tao DESC";
        return jdbcTemplate.query(sql, new EventSuggestionRowMapper(), trangThaiPheDuyet);
    }

    // Sửa phương thức findSuggestionsWithFilters để chỉ lấy những đề xuất có trạng thái phê duyệt
    public List<Map<String, Object>> findSuggestionsWithFilters(Integer loaiSuKienId, String diaDiem, 
            String soLuongKhachRange, String trangThaiPheDuyet) {
        StringBuilder sql = new StringBuilder(
            "SELECT ds.*, nd.ho_ten, nd.email, nd.so_dien_thoai, lsk.ten_loai as loai_su_kien_ten " +
            "FROM dang_su_kien ds " +
            "LEFT JOIN nguoi_dung nd ON ds.nguoi_dung_id = nd.nguoi_dung_id " +
            "LEFT JOIN loai_su_kien lsk ON ds.loai_su_kien_id = lsk.loai_su_kien_id " +
            "WHERE ds.trang_thai_phe_duyet = 'DaDuyet'"
        );

        // Lọc theo trạng thái phê duyệt
        if (trangThaiPheDuyet != null && !trangThaiPheDuyet.isEmpty()) {
            sql.append(" AND ds.trang_thai_phe_duyet = '").append(trangThaiPheDuyet).append("'");
        }

        // Các bộ lọc khác
        if (loaiSuKienId != null) {
            sql.append(" AND ds.loai_su_kien_id = ").append(loaiSuKienId);
        }
        if (diaDiem != null && !diaDiem.trim().isEmpty()) {
            sql.append(" AND LOWER(ds.dia_diem) LIKE LOWER('%").append(diaDiem).append("%')");
        }
        if (soLuongKhachRange != null && !soLuongKhachRange.isEmpty()) {
            switch (soLuongKhachRange) {
                case "0-50":
                    sql.append(" AND ds.so_luong_khach BETWEEN 0 AND 50");
                    break;
                case "50-100":
                    sql.append(" AND ds.so_luong_khach BETWEEN 50 AND 100");
                    break;
                case "100-200":
                    sql.append(" AND ds.so_luong_khach BETWEEN 100 AND 200");
                    break;
                case "200-500":
                    sql.append(" AND ds.so_luong_khach BETWEEN 200 AND 500");
                    break;
                case "500":
                    sql.append(" AND ds.so_luong_khach > 500");
                    break;
            }
        }

        sql.append(" ORDER BY ds.thoi_gian_tao DESC");

        return jdbcTemplate.query(sql.toString(), new RowMapper<Map<String, Object>>() {
            @Override
            public Map<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
                Map<String, Object> result = new java.util.HashMap<>();
                result.put("dangSuKienId", rs.getLong("dang_su_kien_id"));
                result.put("nguoiDungId", rs.getLong("nguoi_dung_id"));
                result.put("tieuDe", rs.getString("tieu_de"));
                result.put("moTaNhuCau", rs.getString("mo_ta_nhu_cau"));
                result.put("loaiSuKienId", rs.getInt("loai_su_kien_id"));
                result.put("loaiSuKienTen", rs.getString("loai_su_kien_ten"));
                result.put("diaDiem", rs.getString("dia_diem"));
                result.put("thoiGianDuKien", rs.getTimestamp("thoi_gian_du_kien"));
                result.put("soLuongKhach", rs.getInt("so_luong_khach"));
                result.put("giaCaLong", rs.getString("gia_ca_long"));
                result.put("thongTinLienLac", rs.getString("thong_tin_lien_lac"));
                result.put("trangThai", rs.getString("trang_thai"));
                result.put("trangThaiPheDuyet", rs.getString("trang_thai_phe_duyet"));
                result.put("thoiGianTao", rs.getTimestamp("thoi_gian_tao"));
                result.put("thoiGianPhanHoi", rs.getTimestamp("thoi_gian_phan_hoi"));
                
                // Thông tin user
                Map<String, Object> user = new java.util.HashMap<>();
                user.put("hoTen", rs.getString("ho_ten"));
                user.put("email", rs.getString("email"));
                user.put("soDienThoai", rs.getString("so_dien_thoai"));
                result.put("user", user);
                
                return result;
            }
        });
    }
}