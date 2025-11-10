package com.example.demo.model;

import java.util.Date;

public class EventSuggestion {
    private Long dangSuKienId;
    private Long nguoiDungId;
    private String tieuDe;
    private String moTaNhuCau;
    private Integer loaiSuKienId;
    private String diaDiem;
    private Date thoiGianDuKien;
    private Integer soLuongKhach;
    private String giaCaLong;
    private String thongTinLienLac;
    private String trangThai; // ChoDuyet, DaDuyet, TuChoi
    private Date thoiGianTao;
    private Date thoiGianPhanHoi;

    public EventSuggestion() {
    }

    public EventSuggestion(Long dangSuKienId, Long nguoiDungId, String tieuDe, String moTaNhuCau, Integer loaiSuKienId,
                      String diaDiem, Date thoiGianDuKien, Integer soLuongKhach, String giaCaLong,
                      String thongTinLienLac, String trangThai, Date thoiGianTao, Date thoiGianPhanHoi) {
        this.dangSuKienId = dangSuKienId;
        this.nguoiDungId = nguoiDungId;
        this.tieuDe = tieuDe;
        this.moTaNhuCau = moTaNhuCau;
        this.loaiSuKienId = loaiSuKienId;
        this.diaDiem = diaDiem;
        this.thoiGianDuKien = thoiGianDuKien;
        this.soLuongKhach = soLuongKhach;
        this.giaCaLong = giaCaLong;
        this.thongTinLienLac = thongTinLienLac;
        this.trangThai = trangThai;
        this.thoiGianTao = thoiGianTao;
        this.thoiGianPhanHoi = thoiGianPhanHoi;
    }

    // --- Getters and Setters ---
    public Long getDangSuKienId() {
        return dangSuKienId;
    }

    public void setDangSuKienId(Long dangSuKienId) {
        this.dangSuKienId = dangSuKienId;
    }

    public Long getNguoiDungId() {
        return nguoiDungId;
    }

    public void setNguoiDungId(Long nguoiDungId) {
        this.nguoiDungId = nguoiDungId;
    }

    public String getTieuDe() {
        return tieuDe;
    }

    public void setTieuDe(String tieuDe) {
        this.tieuDe = tieuDe;
    }

    public String getMoTaNhuCau() {
        return moTaNhuCau;
    }

    public void setMoTaNhuCau(String moTaNhuCau) {
        this.moTaNhuCau = moTaNhuCau;
    }

    public Integer getLoaiSuKienId() {
        return loaiSuKienId;
    }

    public void setLoaiSuKienId(Integer loaiSuKienId) {
        this.loaiSuKienId = loaiSuKienId;
    }

    public String getDiaDiem() {
        return diaDiem;
    }

    public void setDiaDiem(String diaDiem) {
        this.diaDiem = diaDiem;
    }

    public Date getThoiGianDuKien() {
        return thoiGianDuKien;
    }

    public void setThoiGianDuKien(Date thoiGianDuKien) {
        this.thoiGianDuKien = thoiGianDuKien;
    }

    public Integer getSoLuongKhach() {
        return soLuongKhach;
    }

    public void setSoLuongKhach(Integer soLuongKhach) {
        this.soLuongKhach = soLuongKhach;
    }

    public String getGiaCaLong() {
        return giaCaLong;
    }

    public void setGiaCaLong(String giaCaLong) {
        this.giaCaLong = giaCaLong;
    }

    public String getThongTinLienLac() {
        return thongTinLienLac;
    }

    public void setThongTinLienLac(String thongTinLienLac) {
        this.thongTinLienLac = thongTinLienLac;
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

    public Date getThoiGianPhanHoi() {
        return thoiGianPhanHoi;
    }

    public void setThoiGianPhanHoi(Date thoiGianPhanHoi) {
        this.thoiGianPhanHoi = thoiGianPhanHoi;
    }
}
