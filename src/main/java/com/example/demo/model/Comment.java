package com.example.demo.model;

import java.util.Date;

public class Comment {
    private Long binhLuanId;
    private Long suKienId;
    private Long nguoiDungId;
    private String noiDung;
    private String trangThai;
    private Date thoiGianTao;
    private Date thoiGianCapNhat;
    private User user; // Thông tin người dùng
    
    public Comment() {
    }

    public Comment(Long binhLuanId, Long suKienId, Long nguoiDungId, String noiDung, String trangThai, Date thoiGianTao,
            Date thoiGianCapNhat, User user) {
        this.binhLuanId = binhLuanId;
        this.suKienId = suKienId;
        this.nguoiDungId = nguoiDungId;
        this.noiDung = noiDung;
        this.trangThai = trangThai;
        this.thoiGianTao = thoiGianTao;
        this.thoiGianCapNhat = thoiGianCapNhat;
        this.user = user;
    }

    public Long getBinhLuanId() {
        return binhLuanId;
    }

    public void setBinhLuanId(Long binhLuanId) {
        this.binhLuanId = binhLuanId;
    }

    public Long getSuKienId() {
        return suKienId;
    }

    public void setSuKienId(Long suKienId) {
        this.suKienId = suKienId;
    }

    public Long getNguoiDungId() {
        return nguoiDungId;
    }

    public void setNguoiDungId(Long nguoiDungId) {
        this.nguoiDungId = nguoiDungId;
    }

    public String getNoiDung() {
        return noiDung;
    }

    public void setNoiDung(String noiDung) {
        this.noiDung = noiDung;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public Date getThoiGianTao() {
        return thoiGianTao;
    }

    public void setThoiGianTao(Date thoiGianTao) {
        this.thoiGianTao = thoiGianTao;
    }

    public Date getThoiGianCapNhat() {
        return thoiGianCapNhat;
    }

    public void setThoiGianCapNhat(Date thoiGianCapNhat) {
        this.thoiGianCapNhat = thoiGianCapNhat;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }   

    


}