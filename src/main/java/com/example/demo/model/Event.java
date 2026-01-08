package com.example.demo.model;

import java.util.Date;

public class Event {
    private Long suKienId;
    private String tenSuKien;
    private String moTa;
    private String diaDiem;
    private String anhBia;
    private Long loaiSuKienId;
    private Long nguoiToChucId;
    private Date thoiGianBatDau;
    private Date thoiGianKetThuc;
    private String loaiSuKien;
    private String matKhauSuKienRiengTu;
    private Integer soLuongToiDa;
    private Integer soLuongDaDangKy;
    private Date ngayTao;
    private String trangThaiThoigian; 
    private String trangThaiPheDuyet;   
    

    // Default Constructor
    public Event() {
    }

    // All-Args Constructor
    public Event(Long suKienId, String tenSuKien, String moTa, String diaDiem, String anhBia,
                 Long loaiSuKienId, Long nguoiToChucId, Date thoiGianBatDau,
                 Date thoiGianKetThuc, String loaiSuKien, String matKhauSuKienRiengTu,
                 Integer soLuongToiDa, Integer soLuongDaDangKy, Date ngayTao, String trangThaiThoigian,String trangThaiPheDuyet) {

        this.suKienId = suKienId;
        this.tenSuKien = tenSuKien;
        this.moTa = moTa;
        this.diaDiem = diaDiem;
        this.anhBia = anhBia;
        this.loaiSuKienId = loaiSuKienId;
        this.nguoiToChucId = nguoiToChucId;
        this.thoiGianBatDau = thoiGianBatDau;
        this.thoiGianKetThuc = thoiGianKetThuc;
        this.loaiSuKien = loaiSuKien;
        this.matKhauSuKienRiengTu = matKhauSuKienRiengTu;
        this.soLuongToiDa = soLuongToiDa;
        this.soLuongDaDangKy = soLuongDaDangKy;
        this.ngayTao = ngayTao;
        this.trangThaiThoigian = trangThaiThoigian;
        this.trangThaiPheDuyet = trangThaiPheDuyet;
    }



    // Getters and Setters
    public Long getSuKienId() {
        return suKienId;
    }

    public void setSuKienId(Long suKienId) {
        this.suKienId = suKienId;
    }

    public String getTenSuKien() {
        return tenSuKien;
    }

    public void setTenSuKien(String tenSuKien) {
        this.tenSuKien = tenSuKien;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public String getDiaDiem() {
        return diaDiem;
    }

    public void setDiaDiem(String diaDiem) {
        this.diaDiem = diaDiem;
    }

    public String getAnhBia() {
        return anhBia;
    }

    public void setAnhBia(String anhBia) {
        this.anhBia = anhBia;
    }

    public Long getLoaiSuKienId() {
        return loaiSuKienId;
    }

    public void setLoaiSuKienId(Long loaiSuKienId) {
        this.loaiSuKienId = loaiSuKienId;
    }

    public Long getNguoiToChucId() {
        return nguoiToChucId;
    }

    public void setNguoiToChucId(Long nguoiToChucId) {
        this.nguoiToChucId = nguoiToChucId;
    }

    public Date getThoiGianBatDau() {
        return thoiGianBatDau;
    }

    public void setThoiGianBatDau(Date thoiGianBatDau) {
        this.thoiGianBatDau = thoiGianBatDau;
    }

    public Date getThoiGianKetThuc() {
        return thoiGianKetThuc;
    }

    public void setThoiGianKetThuc(Date thoiGianKetThuc) {
        this.thoiGianKetThuc = thoiGianKetThuc;
    }

    public String getLoaiSuKien() {
        return loaiSuKien;
    }

    public void setLoaiSuKien(String loaiSuKien) {
        this.loaiSuKien = loaiSuKien;
    }

    public String getMatKhauSuKienRiengTu() {
        return matKhauSuKienRiengTu;
    }

    public void setMatKhauSuKienRiengTu(String matKhauSuKienRiengTu) {
        this.matKhauSuKienRiengTu = matKhauSuKienRiengTu;
    }

    public String getTrangThaiPheDuyet() {
        return trangThaiPheDuyet;
    }

    public void setTrangThaiPheDuyet(String trangThaiPheDuyet) {
        this.trangThaiPheDuyet = trangThaiPheDuyet;
    }

    public String getTrangThaiThoigian() {
        return trangThaiThoigian;
    }

    public void setTrangThaiThoigian(String trangThaiThoigian) {
        this.trangThaiThoigian = trangThaiThoigian;
    }

    public Integer getSoLuongToiDa() {
        return soLuongToiDa;
    }

    public void setSoLuongToiDa(Integer soLuongToiDa) {
        this.soLuongToiDa = soLuongToiDa;
    }

    public Integer getSoLuongDaDangKy() {
        return soLuongDaDangKy;
    }

    public void setSoLuongDaDangKy(Integer soLuongDaDangKy) {
        this.soLuongDaDangKy = soLuongDaDangKy;
    }

    public Date getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(Date ngayTao) {
        this.ngayTao = ngayTao;
    }
}
