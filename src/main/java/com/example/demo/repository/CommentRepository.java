package com.example.demo.repository;

import com.example.demo.model.Comment;
import com.example.demo.model.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class CommentRepository {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public void save(Comment comment) {
        String sql = "INSERT INTO binh_luan (su_kien_id, nguoi_dung_id, noi_dung, trang_thai) VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql,
            comment.getSuKienId(),
            comment.getNguoiDungId(),
            comment.getNoiDung(),
            comment.getTrangThai() != null ? comment.getTrangThai() : "HIEN_THI"
        );
    }
    
    public List<Comment> getCommentsByEvent(Long suKienId, int limit, int offset) {
        System.out.println("Id của sự kiện là: " + suKienId);
        
        String sql = "SELECT bl.*, nd.ho_ten, nd.anh_dai_dien " +
                     "FROM binh_luan bl " +
                     "JOIN nguoi_dung nd ON bl.nguoi_dung_id = nd.nguoi_dung_id " +
                     "WHERE bl.su_kien_id = ? AND bl.trang_thai = 'HIEN_THI' " +
                     "ORDER BY bl.thoi_gian_tao DESC LIMIT ? OFFSET ?";
        
        return jdbcTemplate.query(sql, new RowMapper<Comment>() {
            @Override
            public Comment mapRow(ResultSet rs, int rowNum) throws SQLException {
                Comment comment = new Comment();
                comment.setBinhLuanId(rs.getLong("binh_luan_id"));
                comment.setSuKienId(rs.getLong("su_kien_id"));
                comment.setNguoiDungId(rs.getLong("nguoi_dung_id"));
                comment.setNoiDung(rs.getString("noi_dung"));
                comment.setTrangThai(rs.getString("trang_thai"));
                comment.setThoiGianTao(rs.getTimestamp("thoi_gian_tao"));
                comment.setThoiGianCapNhat(rs.getTimestamp("thoi_gian_cap_nhat"));
                
                // Set user info
                User user = new User();
                user.setHoTen(rs.getString("ho_ten"));
                user.setAnhDaiDien(rs.getString("anh_dai_dien"));
                comment.setUser(user);
                
                return comment;
            }
        }, suKienId, limit, offset);
    }
    
    public int getTotalComments(Long suKienId) {
        String sql = "SELECT COUNT(*) FROM binh_luan WHERE su_kien_id = ? AND trang_thai = 'HIEN_THI'";
        return jdbcTemplate.queryForObject(sql, Integer.class, suKienId);
    }
    
    public boolean deleteComment(Long binhLuanId, Long nguoiDungId) {
        String sql = "UPDATE binh_luan SET trang_thai = 'AN' WHERE binh_luan_id = ? AND nguoi_dung_id = ?";
        int affected = jdbcTemplate.update(sql, binhLuanId, nguoiDungId);
        return affected > 0;
    }
}