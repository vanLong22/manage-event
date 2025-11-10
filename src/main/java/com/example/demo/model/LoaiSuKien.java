package com.example.demo.model;

 
public class LoaiSuKien {

    private Long loaiSuKienId;
    private String tenLoai;
    private String moTa;
    private String trangThai;


    public LoaiSuKien() {
    }

    public LoaiSuKien(Long loaiSuKienId, String tenLoai, String moTa, String trangThai) {
        this.loaiSuKienId = loaiSuKienId;
        this.tenLoai = tenLoai;
        this.moTa = moTa;
        this.trangThai = trangThai;
    }

    public Long getLoaiSuKienId() {
        return loaiSuKienId;
    }
    public void setLoaiSuKienId(Long loaiSuKienId) {
        this.loaiSuKienId = loaiSuKienId;
    }
    public String getTenLoai() {
        return tenLoai;
    }
    public void setTenLoai(String tenLoai) {
        this.tenLoai = tenLoai;
    }
    public String getMoTa() {
        return moTa;
    }
    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }
    public String getTrangThai() {
        return trangThai;
    }
    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    } 

    
}
