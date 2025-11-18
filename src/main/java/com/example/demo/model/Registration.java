package com.example.demo.model;

import java.util.Date;

public class Registration {
    private Long dangKyId;
    private Long nguoiDungId;
    private Long suKienId;
    private Date thoiGianDangKy;
    private String trangThai;
    private String ghiChu;

    private Event suKien;

    public Event getSuKien() { return suKien; }
    public void setSuKien(Event suKien) { this.suKien = suKien; }

    private User user;

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    private Event event;
    public Event getEvent() { return event; }
    public void setEvent(Event event) { this.event = event; }

    public Registration() {
    }

    public Registration(Long dangKyId, Long nguoiDungId, Long suKienId, Date thoiGianDangKy, String trangThai,
            String ghiChu) {
        this.dangKyId = dangKyId;
        this.nguoiDungId = nguoiDungId;
        this.suKienId = suKienId;
        this.thoiGianDangKy = thoiGianDangKy;
        this.trangThai = trangThai;
        this.ghiChu = ghiChu;
    }

    public Long getDangKyId() { return dangKyId; }
    public void setDangKyId(Long dangKyId) { this.dangKyId = dangKyId; }

    public Long getNguoiDungId() { return nguoiDungId; }
    public void setNguoiDungId(Long nguoiDungId) { this.nguoiDungId = nguoiDungId; }

    public Long getSuKienId() { return suKienId; }
    public void setSuKienId(Long suKienId) { this.suKienId = suKienId; }

    public Date getThoiGianDangKy() { return thoiGianDangKy; }
    public void setThoiGianDangKy(Date thoiGianDangKy) { this.thoiGianDangKy = thoiGianDangKy; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }

}
