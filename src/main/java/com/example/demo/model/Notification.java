package com.example.demo.model;

import java.util.Date;

public class Notification {
    private Long thongBaoId;
    private Long nguoiDungId;
    private String noiDung;
    private Date thoiGian;
    private Long daDoc;
    private String loaiThongBao;
    private String tieuDe;

    public Notification(){
        
    }

    public Notification(Long thongBaoId, Long nguoiDungId, String noiDung, Date thoiGian, Long daDoc, String loaiThongBao, String tieuDe) {
        this.thongBaoId = thongBaoId;
        this.nguoiDungId = nguoiDungId;
        this.noiDung = noiDung;
        this.thoiGian = thoiGian;
        this.daDoc = daDoc;
        this.loaiThongBao = loaiThongBao;
        this.tieuDe = tieuDe;
    }
    // Getters & Setters
    public Long getThongBaoId() { return thongBaoId; }
    public void setThongBaoId(Long thongBaoId) { this.thongBaoId = thongBaoId; }
    
    public Long getNguoiDungId() { return nguoiDungId; }
    public void setNguoiDungId(Long nguoiDungId) { this.nguoiDungId = nguoiDungId; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public Date getThoiGian() { return thoiGian; }
    public void setThoiGian(Date thoiGian) { this.thoiGian = thoiGian; }

    public Long getDaDoc() { return daDoc; }
    public void setDaDoc(Long daDoc) { this.daDoc = daDoc; }

    public String getLoaiThongBao() {
        return loaiThongBao;
    }

    public void setLoaiThongBao(String loaiThongBao) {
        this.loaiThongBao = loaiThongBao;
    }

    public String getTieuDe() {
        return tieuDe;
    }

    public void setTieuDe(String tieuDe) {
        this.tieuDe = tieuDe;
    }

}