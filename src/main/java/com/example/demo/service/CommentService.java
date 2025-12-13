package com.example.demo.service;

import com.example.demo.model.Comment;
import com.example.demo.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CommentService {
    
    @Autowired
    private CommentRepository commentRepository;
    
    @Autowired
    private ActivityHistoryService historyService;
    
    @Autowired
    private EventService eventService;

    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public Map<String, Object> addComment(Long suKienId, Long nguoiDungId, String noiDung) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Kiểm tra nội dung
            if (noiDung == null || noiDung.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Nội dung bình luận không được để trống");
                return result;
            }
            
            if (noiDung.length() > 500) {
                result.put("success", false);
                result.put("message", "Bình luận không được vượt quá 500 ký tự");
                return result;
            }
            
            // Kiểm tra sự kiện tồn tại
            if (eventService.getEventById(suKienId) == null) {
                result.put("success", false);
                result.put("message", "Sự kiện không tồn tại");
                return result;
            }
            
            // Lưu bình luận
            Comment comment = new Comment();
            comment.setSuKienId(suKienId);
            comment.setNguoiDungId(nguoiDungId);
            comment.setNoiDung(noiDung.trim());
            comment.setTrangThai("HIEN_THI");
            comment.setThoiGianTao(new Date());
            
            commentRepository.save(comment);
            
            // Ghi lịch sử
            historyService.logActivity(nguoiDungId, "BinhLuan", suKienId, 
                "Bình luận về sự kiện");
            
            // Cập nhật thống kê sự kiện
            updateEventCommentStats(suKienId);
            
            result.put("success", true);
            result.put("message", "Bình luận đã được gửi");
            result.put("commentId", comment.getBinhLuanId());
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi gửi bình luận: " + e.getMessage());
        }
        
        return result;
    }
    
    private void updateEventCommentStats(Long suKienId) {
        int total = commentRepository.getTotalComments(suKienId);
        String sql = "UPDATE su_kien SET tong_so_binh_luan = ? WHERE su_kien_id = ?";
        jdbcTemplate.update(sql, total, suKienId);
    }
    
    public Map<String, Object> getEventComments(Long suKienId, int page, int limit) {
        Map<String, Object> result = new HashMap<>();

        System.out.println("========== getEventComments ==========");
        System.out.println("suKienId = " + suKienId);
        System.out.println("page = " + page);
        System.out.println("limit = " + limit);

        try {
            int offset = (page - 1) * limit;
            System.out.println("offset = " + offset);

            List<Comment> comments = commentRepository.getCommentsByEvent(suKienId, limit, offset);

            System.out.println("Số bình luận lấy được: " + comments.size());

            // In chi tiết từng comment
            for (int i = 0; i < comments.size(); i++) {
                Comment c = comments.get(i);
                System.out.println("---- Comment #" + (i + 1) + " ----");
                System.out.println("ID: " + c.getBinhLuanId());
                System.out.println("Nội dung: " + c.getNoiDung());
                System.out.println("Người dùng: " + 
                    (c.getUser() != null ? c.getUser().getHoTen() : "null"));
                System.out.println("Ảnh đại diện: " + 
                    (c.getUser() != null ? c.getUser().getAnhDaiDien() : "null"));
                System.out.println("Thời gian tạo: " + c.getThoiGianTao());
            }

            int total = commentRepository.getTotalComments(suKienId);
            int totalPages = (int) Math.ceil((double) total / limit);

            System.out.println("Tổng số bình luận: " + total);
            System.out.println("Tổng số trang: " + totalPages);

            result.put("success", true);
            result.put("comments", comments);
            result.put("total", total);
            result.put("page", page);
            result.put("totalPages", totalPages);

        } catch (Exception e) {
            System.out.println("❌ Lỗi trong getEventComments:");
            e.printStackTrace();

            result.put("success", false);
            result.put("message", "Lỗi khi lấy danh sách bình luận");
        }

        System.out.println("======================================");

        return result;
    }
    
    public Map<String, Object> deleteComment(Long binhLuanId, Long nguoiDungId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            boolean deleted = commentRepository.deleteComment(binhLuanId, nguoiDungId);
            if (deleted) {
                result.put("success", true);
                result.put("message", "Đã xóa bình luận");
            } else {
                result.put("success", false);
                result.put("message", "Không thể xóa bình luận");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi xóa bình luận");
        }
        
        return result;
    }
}