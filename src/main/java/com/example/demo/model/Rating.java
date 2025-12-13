package com.example.demo.model;


import java.util.Date;

public class Rating {
    private Long danhGiaId;
    private Long suKienId;
    private Long nguoiDungId;
    private Integer soSao;
    private String noiDung;
    private Date thoiGianTao;
    private Date thoiGianCapNhat;

    public Rating() {
    }
    
    public Rating(Long danhGiaId, Long suKienId, Long nguoiDungId, Integer soSao, String noiDung, Date thoiGianTao,
            Date thoiGianCapNhat) {
        this.danhGiaId = danhGiaId;
        this.suKienId = suKienId;
        this.nguoiDungId = nguoiDungId;
        this.soSao = soSao;
        this.noiDung = noiDung;
        this.thoiGianTao = thoiGianTao;
        this.thoiGianCapNhat = thoiGianCapNhat;
    }
    public Long getDanhGiaId() {
        return danhGiaId;
    }
    public void setDanhGiaId(Long danhGiaId) {
        this.danhGiaId = danhGiaId;
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
    public Integer getSoSao() {
        return soSao;
    }
    public void setSoSao(Integer soSao) {
        this.soSao = soSao;
    }
    public String getNoiDung() {
        return noiDung;
    }
    public void setNoiDung(String noiDung) {
        this.noiDung = noiDung;
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
    
    
}
