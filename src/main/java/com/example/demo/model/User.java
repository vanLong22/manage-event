package com.example.demo.model;

import java.util.Date;

public class User {
    private Long nguoiDungId;
    private String tenDangNhap;
    private String matKhau;
    private String email;
    private String soDienThoai;
    private String hoTen;
    private String diaChi;
    private String gioiTinh;
    private String anhDaiDien;
    private String vaiTro;
    private Date ngayTao;
    private Integer trangThai;  

    // Default Constructor
    public User() {
    }

    // All-Args Constructor (cập nhật)
    public User(Long nguoiDungId, String tenDangNhap, String matKhau, String email, String soDienThoai,
                String hoTen, String diaChi, String gioiTinh, String anhDaiDien, String vaiTro,
                Date ngayTao, Integer trangThai) {
        this.nguoiDungId = nguoiDungId;
        this.tenDangNhap = tenDangNhap;
        this.matKhau = matKhau;
        this.email = email;
        this.soDienThoai = soDienThoai;
        this.hoTen = hoTen;
        this.diaChi = diaChi;
        this.gioiTinh = gioiTinh;
        this.anhDaiDien = anhDaiDien;
        this.vaiTro = vaiTro;
        this.ngayTao = ngayTao;
        this.trangThai = trangThai;
    }

    // Getters and Setters (thêm getter/setter cho trangThai)
    public Long getNguoiDungId() {
        return nguoiDungId;
    }

    public void setNguoiDungId(Long nguoiDungId) {
        this.nguoiDungId = nguoiDungId;
    }

    public String getTenDangNhap() {
        return tenDangNhap;
    }

    public void setTenDangNhap(String tenDangNhap) {
        this.tenDangNhap = tenDangNhap;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSoDienThoai() {
        return soDienThoai;
    }

    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }

    public String getGioiTinh() {
        return gioiTinh;
    }

    public void setGioiTinh(String gioiTinh) {
        this.gioiTinh = gioiTinh;
    }

    public String getAnhDaiDien() {
        return anhDaiDien;
    }

    public void setAnhDaiDien(String anhDaiDien) {
        this.anhDaiDien = anhDaiDien;
    }

    public String getVaiTro() {
        return vaiTro;
    }

    public void setVaiTro(String vaiTro) {
        this.vaiTro = vaiTro;
    }

    public Date getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(Date ngayTao) {
        this.ngayTao = ngayTao;
    }

    public Integer getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(Integer trangThai) {
        this.trangThai = trangThai;
    }
}