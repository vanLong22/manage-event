package com.example.demo.model;

import java.util.Date;

public class ActivityHistory {
    private Long lichSuId;
    private Long nguoiDungId;
    private String loaiHoatDong;
    private Long suKienId;
    private String chiTiet;
    private Date  thoiGian;

    public ActivityHistory(Long lichSuId, Long nguoiDungId, String loaiHoatDong, String chiTiet,
            Date thoiGian) {
        this.lichSuId = lichSuId;
        this.nguoiDungId = nguoiDungId;
        this.loaiHoatDong = loaiHoatDong;
        this.chiTiet = chiTiet;
        this.thoiGian = thoiGian;
    }

    public ActivityHistory(Long lichSuId, Long nguoiDungId, String loaiHoatDong, Long suKienId, String chiTiet,
            Date thoiGian) {
        this.lichSuId = lichSuId;
        this.nguoiDungId = nguoiDungId;
        this.loaiHoatDong = loaiHoatDong;
        this.suKienId = suKienId;
        this.chiTiet = chiTiet;
        this.thoiGian = thoiGian;
    }

    
    public ActivityHistory() {
    }


    // Getters & Setters
    public Long getLichSuId() { return lichSuId; }
    public void setLichSuId(Long lichSuId) { this.lichSuId = lichSuId; }
    
    public Long getNguoiDungId() { return nguoiDungId; }
    public void setNguoiDungId(Long nguoiDungId) { this.nguoiDungId = nguoiDungId; }

    public String getLoaiHoatDong() { return loaiHoatDong; }
    public void setLoaiHoatDong(String loaiHoatDong) { this.loaiHoatDong = loaiHoatDong; }

    public Long getSuKienId() {
        return suKienId;
    }

    public void setSuKienId(Long suKienId) {
        this.suKienId = suKienId;
    }

    public String getChiTiet() { return chiTiet; }
    public void setChiTiet(String chiTiet) { this.chiTiet = chiTiet; }

    public Date getThoiGian() { return thoiGian; }
    public void setThoiGian(Date thoiGian) { this.thoiGian = thoiGian; }

}