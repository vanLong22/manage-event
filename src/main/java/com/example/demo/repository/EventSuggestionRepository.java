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
            suggestion.setThoiGianTao(rs.getTimestamp("thoi_gian_tao"));
            suggestion.setThoiGianPhanHoi(rs.getTimestamp("thoi_gian_phan_hoi"));
            return suggestion;
        }
    }

    public List<EventSuggestion> findByUserId(Long userId) {
        String sql = "SELECT * FROM dang_su_kien WHERE nguoi_dung_id = ? ORDER BY thoi_gian_tao DESC";
        return jdbcTemplate.query(sql, new EventSuggestionRowMapper(), userId);
    }

    public EventSuggestion findById(Long id) {
        try {
            return jdbcTemplate.queryForObject(
                "SELECT * FROM dang_su_kien WHERE dang_su_kien_id = ?",
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
                "SELECT * FROM dang_su_kien WHERE dang_su_kien_id = ? AND nguoi_dung_id = ?",
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
                     "thong_tin_lien_lac, trang_thai, thoi_gian_tao) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
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
            suggestion.getThoiGianTao()
        );
    }

    public Long saveAndReturnId(EventSuggestion suggestion) {
        String sql = "INSERT INTO dang_su_kien (" +
                     "nguoi_dung_id, tieu_de, mo_ta_nhu_cau, loai_su_kien_id, " +
                     "dia_diem, thoi_gian_du_kien, so_luong_khach, gia_ca_long, " +
                     "thong_tin_lien_lac, trang_thai, thoi_gian_tao) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
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
            ps.setTimestamp(11, suggestion.getThoiGianTao() != null ? 
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
            "thong_tin_lien_lac = ?, trang_thai = ? WHERE dang_su_kien_id = ? AND nguoi_dung_id = ?",
            suggestion.getTieuDe(),
            suggestion.getMoTaNhuCau(),
            suggestion.getLoaiSuKienId(),
            suggestion.getDiaDiem(),
            suggestion.getThoiGianDuKien(),
            suggestion.getSoLuongKhach(),
            suggestion.getGiaCaLong(),
            suggestion.getThongTinLienLac(),
            suggestion.getTrangThai(),
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

    public List<EventSuggestion> findByStatus(String status) {
        String sql = "SELECT * FROM dang_su_kien WHERE trang_thai = ? ORDER BY thoi_gian_tao DESC";
        return jdbcTemplate.query(sql, new EventSuggestionRowMapper(), status);
    }
}