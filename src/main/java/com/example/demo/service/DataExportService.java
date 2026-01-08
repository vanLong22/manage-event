package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@Service
public class DataExportService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /* =====================================================================
       Export dữ liệu huấn luyện (train.csv) – giữ nguyên tên cột tiếng Anh
       Nội dung (loai_su_kien, dia_diem, ...) được ghi nguyên gốc tiếng Việt
       ===================================================================== */
    public void exportDataToCsv(String filePath) throws IOException {
        // Positive samples (đã tham gia)
        String sqlPositive = """
            SELECT dk.nguoi_dung_id               AS user_id,
                   dk.su_kien_id                  AS event_id,
                   1                              AS label,
                   sk.loai_su_kien                AS loai_su_kien,
                   sk.dia_diem                    AS dia_diem,
                   DATEDIFF(sk.thoi_gian_bat_dau, NOW()) AS thoi_gian_diff_days
            FROM dang_ky_su_kien dk
            JOIN su_kien sk ON dk.su_kien_id = sk.su_kien_id
            WHERE dk.trang_thai = 'DaDuyet'
            """;

        // Negative samples (chưa tham gia – giới hạn để cân bằng)
        String sqlNegative = """
            SELECT nd.nguoi_dung_id               AS user_id,
                   sk.su_kien_id                  AS event_id,
                   0                              AS label,
                   sk.loai_su_kien                AS loai_su_kien,
                   sk.dia_diem                    AS dia_diem,
                   DATEDIFF(sk.thoi_gian_bat_dau, NOW()) AS thoi_gian_diff_days
            FROM nguoi_dung nd
            CROSS JOIN su_kien sk
            LEFT JOIN dang_ky_su_kien dk 
                   ON dk.nguoi_dung_id = nd.nguoi_dung_id 
                  AND dk.su_kien_id   = sk.su_kien_id
            WHERE dk.dang_ky_su_kien_id IS NULL
            ORDER BY RAND()
            LIMIT 3000
            """;

        List<Map<String, Object>> positive = jdbcTemplate.queryForList(sqlPositive);
        List<Map<String, Object>> negative = jdbcTemplate.queryForList(sqlNegative);

        // Ghi file với UTF-8 + BOM (Excel nhận diện tiếng Việt tốt hơn)
        try (OutputStreamWriter writer = new OutputStreamWriter(
                new FileOutputStream(filePath), StandardCharsets.UTF_8)) {

            // Thêm BOM để Excel hiển thị đúng tiếng Việt ngay lập tức
            writer.write('\ufeff');

            // Header – giữ nguyên tên cột tiếng Anh như yêu cầu
            writer.write("user_id,event_id,label,loai_su_kien,dia_diem,thoi_gian_diff_days\n");

            writeRows(writer, positive);
            writeRows(writer, negative);
        }
    }

    /* =====================================================================
       Export sự kiện mới (dự đoán) – new_events.csv
       ===================================================================== */
    public void exportNewEventsToCsv(String filePath) throws IOException {
        String sql = """
            SELECT sk.su_kien_id                                          AS event_id,
                   sk.loai_su_kien                                        AS loai_su_kien,
                   sk.dia_diem                                            AS dia_diem,
                   DATEDIFF(sk.thoi_gian_bat_dau, NOW())                  AS thoi_gian_diff_days,
                   sk.so_luong_da_dang_ky                                 AS so_luong_da_dang_ky
            FROM su_kien sk
            WHERE sk.trang_thai IN ('SapDienRa', 'DangDienRa')
              AND sk.so_luong_da_dang_ky < sk.so_luong_toi_da
            """;

        List<Map<String, Object>> data = jdbcTemplate.queryForList(sql);

        try (OutputStreamWriter writer = new OutputStreamWriter(
                new FileOutputStream(filePath), StandardCharsets.UTF_8)) {

            writer.write('\ufeff'); // BOM cho Excel

            // Header giữ nguyên tiếng Anh, thêm so_luong_da_dang_ky
            writer.write("event_id,loai_su_kien,dia_diem,thoi_gian_diff_days,so_luong_da_dang_ky\n");

            for (Map<String, Object> row : data) {
                writer.write(
                        row.get("event_id") + "," +
                        escapeCsv(row.get("loai_su_kien")) + "," +
                        escapeCsv(row.get("dia_diem")) + "," +
                        row.get("thoi_gian_diff_days") + "," +
                        row.get("so_luong_da_dang_ky") + "\n"
                );
            }
        }
    }

    /* =====================================================================
       Helper: ghi từng dòng – tự động escape dấu phẩy và dấu nháy nếu cần
       ===================================================================== */
    private void writeRows(OutputStreamWriter writer, List<Map<String, Object>> rows) throws IOException {
        for (Map<String, Object> row : rows) {
            writer.write(
                    row.get("user_id") + "," +
                    row.get("event_id") + "," +
                    row.get("label") + "," +
                    escapeCsv(row.get("loai_su_kien")) + "," +
                    escapeCsv(row.get("dia_diem")) + "," +
                    row.get("thoi_gian_diff_days") + "\n"
            );
        }
    }

    /***
     * Escape giá trị CSV: nếu chứa dấu phẩy,, dấu nháy kép hoặc xuống dòng → bọc trong ""
     * và nhân đôi dấu nháy kép bên trong.
     */
    private String escapeCsv(Object value) {
        if (value == null) return "";
        String str = value.toString();
        if (str.contains(",") || str.contains("\"") || str.contains("\n") || str.contains("\r")) {
            str = str.replace("\"", "\"\"");
            return "\"" + str + "\"";
        }
        return str;
    }

    public void exportUserHistoryForRecommendation(Long userId) throws IOException {
        String dirPath = "D:\\2022-2026\\HOC KI 7\\XD HTTT\\quanLySuKien\\demo\\src\\main\\webapp\\static\\csv";
        createDirectoryIfNotExists(dirPath);

        String filePath = dirPath + "\\user_" + userId + "_history.csv";

        String sql = """
            SELECT sk.su_kien_id AS event_id,
                sk.loai_su_kien,
                sk.dia_diem,
                DATEDIFF(sk.thoi_gian_bat_dau, CURDATE()) AS thoi_gian_diff_days
            FROM dang_ky_su_kien dk
            JOIN su_kien sk ON dk.su_kien_id = sk.su_kien_id
            WHERE dk.nguoi_dung_id = ?
            AND dk.trang_thai = 'DaDuyet'
            """;

        List<Map<String, Object>> data = jdbcTemplate.queryForList(sql, userId);

        try (Writer writer = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(filePath), StandardCharsets.UTF_8))) {

            writer.write("event_id,loai_su_kien,dia_diem,thoi_gian_diff_days,label\n");

            for (Map<String, Object> row : data) {
                writer.write(String.format("%s,\"%s\",\"%s\",%s,1\n",
                        row.get("event_id"),
                        row.get("loai_su_kien"),
                        row.get("dia_diem"),
                        row.get("thoi_gian_diff_days")
                ));
            }
        }

        System.out.println("✅ Exported history for user " + userId + " to " + filePath);
    }
    private void createDirectoryIfNotExists(String path) {
        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdirs();
            System.out.println("Created directory: " + path);
        }
    }

}