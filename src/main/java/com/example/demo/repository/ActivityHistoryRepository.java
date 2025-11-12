// package com.example.demo.repository;

// import com.example.demo.model.ActivityHistory;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.jdbc.core.BeanPropertyRowMapper;
// import org.springframework.jdbc.core.JdbcTemplate;
// import org.springframework.stereotype.Repository;

// import java.util.List;

// @Repository
// public class ActivityHistoryRepository {
//     @Autowired
//     private JdbcTemplate jdbcTemplate;

//     public List<ActivityHistory> findByUserId(Long userId) {
//         return jdbcTemplate.query("SELECT * FROM lich_su_hoat_dong WHERE nguoi_dung_id = ? ORDER BY thoi_gian DESC", 
//             new BeanPropertyRowMapper<>(ActivityHistory.class), userId);
//     }

//     public void save(ActivityHistory history) {
//         String sql = "INSERT INTO lich_su_hoat_dong (nguoi_dung_id, loai_hoat_dong, chi_tiet, thoi_gian) VALUES (?, ?, ?, ?)";
//         jdbcTemplate.update(sql, history.getNguoiDungId(), history.getLoaiHoatDong(), history.getChiTiet(), history.getThoiGian());
//     }
// }

package com.example.demo.repository;

import com.example.demo.model.ActivityHistory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ActivityHistoryRepository {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<ActivityHistory> findByUserId(Long userId) {
        return jdbcTemplate.query(
            "SELECT * FROM lich_su_hoat_dong WHERE nguoi_dung_id = ? ORDER BY thoi_gian DESC",
            new BeanPropertyRowMapper<>(ActivityHistory.class),
            userId
        );
    }

    public void save(ActivityHistory history) {
        String sql = "INSERT INTO lich_su_hoat_dong (nguoi_dung_id, loai_hoat_dong, su_kien_id, chi_tiet, thoi_gian) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        jdbcTemplate.update(sql,
            history.getNguoiDungId(),
            history.getLoaiHoatDong(),
            history.getSuKienId(),
            history.getChiTiet(),
            history.getThoiGian()
        );
    }

    public List<ActivityHistory> findByUserIdAndType(Long userId, String activityType) {
        return jdbcTemplate.query(
            "SELECT * FROM lich_su_hoat_dong WHERE nguoi_dung_id = ? AND loai_hoat_dong = ? ORDER BY thoi_gian DESC",
            new BeanPropertyRowMapper<>(ActivityHistory.class),
            userId, activityType
        );
    }

    public void deleteOldHistory(int daysToKeep) {
        String sql = "DELETE FROM lich_su_hoat_dong WHERE thoi_gian < DATE_SUB(NOW(), INTERVAL ? DAY)";
        jdbcTemplate.update(sql, daysToKeep);
    }
}