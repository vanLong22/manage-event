package com.example.demo.service;

import com.example.demo.model.Rating;
import com.example.demo.repository.RatingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class RatingService {
    
    @Autowired
    private RatingRepository ratingRepository;
    
    @Autowired
    private ActivityHistoryService historyService;

    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public Map<String, Object> rateEvent(Long suKienId, Long nguoiDungId, Integer soSao, String noiDung) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Kiểm tra đánh giá hợp lệ
            if (soSao == null || soSao < 1 || soSao > 5) {
                result.put("success", false);
                result.put("message", "Số sao phải từ 1 đến 5");
                return result;
            }
            
            // Lưu đánh giá
            Rating rating = new Rating();
            rating.setSuKienId(suKienId);
            rating.setNguoiDungId(nguoiDungId);
            rating.setSoSao(soSao);
            rating.setNoiDung(noiDung);
            
            ratingRepository.save(rating);
            
            // Ghi lịch sử
            historyService.logActivity(nguoiDungId, "DanhGia", suKienId, 
                "Đánh giá sự kiện " + soSao + " sao");
            
            // Cập nhật thống kê sự kiện
            updateEventRatingStats(suKienId);
            
            result.put("success", true);
            result.put("message", "Đánh giá thành công");
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi đánh giá: " + e.getMessage());
        }
        
        return result;
    }

    // Lấy thông tin đánh giá
    public Map<String, Object> getEventRatingInfo(Long suKienId, Long nguoiDungId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            Double average = ratingRepository.getAverageRating(suKienId);
            Integer total = ratingRepository.getTotalRatings(suKienId);
            Integer userRating = ratingRepository.getUserRating(suKienId, nguoiDungId);
            List<Map<String, Object>> distribution = ratingRepository.getRatingDistribution(suKienId);
            
            // Format distribution
            int[] distArray = new int[5];
            for (Map<String, Object> dist : distribution) {
                int star = ((Number) dist.get("so_sao")).intValue();
                int count = ((Number) dist.get("count")).intValue();
                if (star >= 1 && star <= 5) {
                    distArray[star - 1] = count;
                }
            }
            
            result.put("success", true);
            result.put("average", average != null ? average : 0);
            result.put("total", total != null ? total : 0);
            result.put("userRating", userRating != null ? userRating : 0);
            result.put("distribution", distArray);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi lấy thông tin đánh giá");
        }
        
        return result;
    }
    
    private void updateEventRatingStats(Long suKienId) {
        Double average = ratingRepository.getAverageRating(suKienId);
        Integer total = ratingRepository.getTotalRatings(suKienId);

        if (average != null) {
            String sql = "UPDATE su_kien SET diem_danh_gia_tb = ?, tong_so_danh_gia = ? WHERE su_kien_id = ?";
            jdbcTemplate.update(sql, average, total, suKienId);
        }
    }
    
    public Map<String, Object> getEventRatings(Long suKienId, Long nguoiDungId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Lấy thông tin tổng quan
            Double average = ratingRepository.getAverageRating(suKienId);
            Integer total = ratingRepository.getTotalRatings(suKienId);
            Integer userRating = ratingRepository.getUserRating(suKienId, nguoiDungId);
            List<Map<String, Object>> distribution = ratingRepository.getRatingDistribution(suKienId);
            
            // Định dạng distribution
            int[] distArray = new int[5];
            for (Map<String, Object> dist : distribution) {
                int star = ((Number) dist.get("so_sao")).intValue();
                int count = ((Number) dist.get("count")).intValue();
                if (star >= 1 && star <= 5) {
                    distArray[star - 1] = count;
                }
            }
            
            result.put("success", true);
            result.put("average", average != null ? average : 0);
            result.put("total", total != null ? total : 0);
            result.put("userRating", userRating != null ? userRating : 0);
            result.put("distribution", distArray);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi lấy thông tin đánh giá");
        }
        
        return result;
    }
}