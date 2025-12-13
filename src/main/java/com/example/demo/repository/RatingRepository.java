package com.example.demo.repository;

import com.example.demo.model.Rating;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Repository
public class RatingRepository {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public void save(Rating rating) {
        String sql = "INSERT INTO danh_gia (su_kien_id, nguoi_dung_id, so_sao, noi_dung) VALUES (?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE so_sao = ?, noi_dung = ?, thoi_gian_cap_nhat = NOW()";
        jdbcTemplate.update(sql, 
            rating.getSuKienId(),
            rating.getNguoiDungId(),
            rating.getSoSao(),
            rating.getNoiDung(),
            rating.getSoSao(),
            rating.getNoiDung()
        );
    }
    
    public Double getAverageRating(Long suKienId) {
        String sql = "SELECT AVG(so_sao) FROM danh_gia WHERE su_kien_id = ?";
        return jdbcTemplate.queryForObject(sql, Double.class, suKienId);
    }
    
    public Integer getUserRating(Long suKienId, Long nguoiDungId) {
        String sql = "SELECT so_sao FROM danh_gia WHERE su_kien_id = ? AND nguoi_dung_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, Integer.class, suKienId, nguoiDungId);
        } catch (Exception e) {
            return null;
        }
    }
    
    public List<Map<String, Object>> getRatingDistribution(Long suKienId) {
        String sql = "SELECT so_sao, COUNT(*) as count FROM danh_gia WHERE su_kien_id = ? GROUP BY so_sao ORDER BY so_sao DESC";
        return jdbcTemplate.queryForList(sql, suKienId);
    }
    
    public int getTotalRatings(Long suKienId) {
        String sql = "SELECT COUNT(*) FROM danh_gia WHERE su_kien_id = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, suKienId);
    }
    
    public List<Rating> getRatingsByEvent(Long suKienId, int limit) {
        String sql = "SELECT dg.*, nd.ho_ten, nd.anh_dai_dien " +
                     "FROM danh_gia dg " +
                     "JOIN nguoi_dung nd ON dg.nguoi_dung_id = nd.nguoi_dung_id " +
                     "WHERE dg.su_kien_id = ? ORDER BY dg.thoi_gian_tao DESC LIMIT ?";
        return jdbcTemplate.query(sql, new RowMapper<Rating>() {
            @Override
            public Rating mapRow(ResultSet rs, int rowNum) throws SQLException {
                Rating rating = new Rating();
                rating.setDanhGiaId(rs.getLong("danh_gia_id"));
                rating.setSuKienId(rs.getLong("su_kien_id"));
                rating.setNguoiDungId(rs.getLong("nguoi_dung_id"));
                rating.setSoSao(rs.getInt("so_sao"));
                rating.setNoiDung(rs.getString("noi_dung"));
                rating.setThoiGianTao(rs.getTimestamp("thoi_gian_tao"));
                rating.setThoiGianCapNhat(rs.getTimestamp("thoi_gian_cap_nhat"));
                return rating;
            }
        }, suKienId, limit);
    }

    public Object getJdbcTemplate() {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getJdbcTemplate'");
    }
}