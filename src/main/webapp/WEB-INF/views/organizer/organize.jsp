<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHub - Dashboard Người Tổ Chức</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- CSS tùy chỉnh -->
    <style>
        :root {
            --primary: #4a6bff;
            --primary-light: #e8ecff;
            --secondary: #ff7b54;
            --success: #2ecc71;
            --warning: #f39c12;
            --danger: #e74c3c;
            --dark: #2c3e50;
            --light: #f8f9fa;
            --gray: #95a5a6;
            --border-radius: 12px;
            --box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f7ff;
            color: var(--dark);
            line-height: 1.6;
        }

        .container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, var(--primary) 0%, #3a5bff 100%);
            color: white;
            padding: 20px 0;
            transition: var(--transition);
            box-shadow: var(--box-shadow);
            z-index: 100;
        }

        .logo {
            display: flex;
            align-items: center;
            padding: 0 20px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .logo i {
            font-size: 28px;
            margin-right: 10px;
        }

        .logo h1 {
            font-size: 22px;
            font-weight: 700;
        }

        .menu {
            list-style: none;
            padding: 0 10px;
        }

        .menu-item {
            margin-bottom: 8px;
        }

        .menu-link {
            display: flex;
            align-items: center;
            padding: 14px 16px;
            color: rgba(255, 255, 255, 0.85);
            text-decoration: none;
            border-radius: var(--border-radius);
            transition: var(--transition);
            cursor: pointer;
        }

        .menu-link:hover, .menu-link.active {
            background-color: rgba(255, 255, 255, 0.15);
            color: white;
        }

        .menu-link i {
            font-size: 18px;
            margin-right: 12px;
            width: 24px;
            text-align: center;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .header-title h2 {
            font-size: 24px;
            font-weight: 700;
            color: var(--dark);
        }

        .header-title p {
            color: var(--gray);
            font-size: 14px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background-color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 18px;
        }

        .user-details h4 {
            font-size: 16px;
            font-weight: 600;
        }

        .user-details p {
            font-size: 13px;
            color: var(--gray);
        }

        /* Dashboard Cards */
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            border-radius: var(--border-radius);
            padding: 20px;
            box-shadow: var(--box-shadow);
            transition: var(--transition);
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        }

        .card-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            font-size: 22px;
        }

        .card-icon.primary {
            background-color: var(--primary-light);
            color: var(--primary);
        }

        .card-icon.success {
            background-color: rgba(46, 204, 113, 0.15);
            color: var(--success);
        }

        .card-icon.warning {
            background-color: rgba(243, 156, 18, 0.15);
            color: var(--warning);
        }

        .card-icon.danger {
            background-color: rgba(231, 76, 60, 0.15);
            color: var(--danger);
        }

        .card h3 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .card p {
            color: var(--gray);
            font-size: 14px;
        }

        /* Content Sections */
        .content-section {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: var(--box-shadow);
            display: none;
        }

        .content-section.active {
            display: block;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 20px;
            font-weight: 700;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background-color: #3a5bff;
        }

        .btn-success {
            background-color: var(--success);
            color: white;
        }

        .btn-warning {
            background-color: var(--warning);
            color: white;
        }

        .btn-danger {
            background-color: var(--danger);
            color: white;
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid var(--primary);
            color: var(--primary);
        }

        .btn-outline:hover {
            background-color: var(--primary-light);
        }

        /* Tables */
        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        th {
            font-weight: 600;
            color: var(--dark);
            background-color: var(--primary-light);
        }

        tr:hover {
            background-color: rgba(0, 0, 0, 0.02);
        }

        .status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status.approved {
            background-color: rgba(46, 204, 113, 0.15);
            color: var(--success);
        }

        .status.pending {
            background-color: rgba(243, 156, 18, 0.15);
            color: var(--warning);
        }

        .status.cancelled {
            background-color: rgba(231, 76, 60, 0.15);
            color: var(--danger);
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .action-btn {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: rgba(0, 0, 0, 0.05);
            color: var(--dark);
            cursor: pointer;
            transition: var(--transition);
        }

        .action-btn:hover {
            background-color: var(--primary);
            color: white;
        }

        /* Forms */
        .form-group {
            margin-bottom: 20px;
        }

        .form-row {
            display: flex;
            gap: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark);
        }

        input, select, textarea {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            transition: var(--transition);
        }

        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(74, 107, 255, 0.2);
        }

        textarea {
            min-height: 120px;
            resize: vertical;
        }

        /* Event Cards */
        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .event-card {
            background: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--box-shadow);
            transition: var(--transition);
        }

        .event-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        .event-image {
            height: 160px;
            background-color: var(--primary-light);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-size: 40px;
        }

        .event-content {
            padding: 20px;
        }

        .event-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .event-meta {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
            font-size: 14px;
            color: var(--gray);
        }

        .event-meta i {
            margin-right: 5px;
        }

        .event-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid rgba(0, 0, 0, 0.05);
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: white;
            border-radius: var(--border-radius);
            width: 90%;
            max-width: 600px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            padding: 20px 25px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h3 {
            font-size: 20px;
            font-weight: 700;
        }

        .close-modal {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: var(--gray);
        }

        .modal-body {
            padding: 25px;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                height: auto;
            }
            
            .menu {
                display: flex;
                overflow-x: auto;
                padding-bottom: 10px;
            }
            
            .menu-item {
                margin-bottom: 0;
                margin-right: 10px;
            }
            
            .menu-link {
                white-space: nowrap;
            }
        }

        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .dashboard-cards {
                grid-template-columns: 1fr;
            }
            
            .events-grid {
                grid-template-columns: 1fr;
            }
        }

        .form-text {
            display: block;
            margin-top: 5px;
            font-size: 0.8rem;
            color: #6c757d;
        }

        #private-event-id-group {
            transition: all 0.3s ease;
        }

        #private-event-id {
            font-family: monospace;
            letter-spacing: 1px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo">
                <i class="fas fa-calendar-alt"></i>
                <h1>EventHub</h1>
            </div>
            <ul class="menu">
                <li class="menu-item">
                    <a href="#" class="menu-link active" data-target="dashboard">
                        <i class="fas fa-home"></i>
                        <span>Tổng quan</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="events">
                        <i class="fas fa-calendar-week"></i>
                        <span>Quản lý sự kiện</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="create-event">
                        <i class="fas fa-plus-circle"></i>
                        <span>Tạo sự kiện mới</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="attendance">
                        <i class="fas fa-clipboard-check"></i>
                        <span>Điểm danh</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="participants">
                        <i class="fas fa-users"></i>
                        <span>Người tham gia</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="analytics">
                        <i class="fas fa-chart-bar"></i>
                        <span>Thống kê</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="account">
                        <i class="fas fa-user-cog"></i>
                        <span>Tài khoản</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <div class="header">
                <div class="header-title">
                    <h2 id="page-title">Tổng quan</h2>
                    <p id="page-subtitle">Quản lý sự kiện của bạn tại một nơi</p>
                </div>
                <div class="user-info">
                    <div class="user-avatar" id="user-avatar">
                        <c:out value="${user.hoTen}"/>
                    </div>
                    <div class="user-details">
                        <h4 id="user-name"><c:out value="${user.hoTen}"/></h4>
                        <p id="user-role"><c:out value="${user.vaiTro}"/></p>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div id="dashboard" class="content-section active">
                <div class="dashboard-cards">
                    <div class="card">
                        <div class="card-icon primary">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <h3 id="active-events"><c:out value="${stats.activeEvents}"/></h3>
                        <p>Sự kiện đang hoạt động</p>
                    </div>
                    <div class="card">
                        <div class="card-icon success">
                            <i class="fas fa-users"></i>
                        </div>
                        <h3 id="total-participants"><c:out value="${stats.totalParticipants}"/></h3>
                        <p>Người tham gia</p>
                    </div>
                    <div class="card">
                        <div class="card-icon warning">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h3 id="upcoming-events"><c:out value="${stats.upcomingEvents}"/></h3>
                        <p>Sự kiện sắp diễn ra</p>
                    </div>
                    <div class="card">
                        <div class="card-icon danger">
                            <i class="fas fa-exclamation-circle"></i>
                        </div>
                        <h3 id="attention-events"><c:out value="${stats.attentionEvents}"/></h3>
                        <p>Sự kiện cần chú ý</p>
                    </div>
                </div>

                <div class="section-header">
                    <h3 class="section-title">Sự kiện sắp diễn ra</h3>
                    <button class="btn btn-outline">
                        <i class="fas fa-eye"></i> Xem tất cả
                    </button>
                </div>

                <div class="events-grid" id="upcoming-events-grid">
                    <c:forEach var="event" items="${upcomingEvents}">
                        <div class="event-card" data-event-id="<c:out value="${event.suKienId}"/>">
                            <div class="event-image">
                                <img src="<c:out value="${event.anhBia != null ? event.anhBia : '/default.jpg'}"/>" alt="">
                            </div>
                            <div class="event-content">
                                <h4 class="event-title"><c:out value="${event.tenSuKien}"/></h4>
                                <div class="event-meta">
                                    <span><i class="far fa-calendar"></i> <fmt:formatDate value="${event.thoiGianBatDau}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    <span><i class="fas fa-map-marker-alt"></i> <c:out value="${event.diaDiem}"/></span>
                                </div>
                                <p><c:out value="${event.moTa}"/></p>
                                <div class="event-footer">
                                    <span class="status <c:out value="${fn:toLowerCase(event.trangThai)}"/>"><c:out value="${event.trangThai}"/></span>
                                    <span><i class="fas fa-users"></i> <c:out value="${event.soLuongDaDangKy}"/> / <c:out value="${event.soLuongToiDa}"/></span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Events Management Content -->
            <div id="events" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Quản lý sự kiện</h3>
                    <button class="btn btn-primary" id="create-event-btn">
                        <i class="fas fa-plus"></i> Tạo sự kiện mới
                    </button>
                </div>

                <div class="table-container">
                    <table id="events-table">
                        <thead>
                            <tr>
                                <th>Tên sự kiện</th>
                                <th>Ngày diễn ra</th>
                                <th>Địa điểm</th>
                                <th>Trạng thái</th>
                                <th>Người tham gia</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="event" items="${allEvents}">
                                <tr data-event-id="<c:out value="${event.suKienId}"/>">
                                    <td><c:out value="${event.tenSuKien}"/></td>
                                    <td><fmt:formatDate value="${event.thoiGianBatDau}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td><c:out value="${event.diaDiem}"/></td>
                                    <td>
                                        <span class="status <c:out value='${fn:toLowerCase(event.trangThai)}'/>">
                                            <c:choose>
                                                <c:when test="${event.trangThai == 'DangDienRa'}">Đang Diễn Ra</c:when>
                                                <c:when test="${event.trangThai == 'DaKetThuc'}">Đã Kết Thúc</c:when>
                                                <c:when test="${event.trangThai == 'SapDienRa'}">Sắp Diễn Ra</c:when>
                                                <c:otherwise>Không xác định</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td><c:out value="${event.soLuongDaDangKy}"/> / <c:out value="${event.soLuongToiDa}"/></td>
                                    <td class="action-buttons">
                                        <div class="action-btn edit-event" data-event-id="<c:out value="${event.suKienId}"/>" title="Chỉnh sửa">
                                            <i class="fas fa-edit"></i>
                                        </div>
                                        <div class="action-btn delete-event" data-event-id="<c:out value="${event.suKienId}"/>" title="Xóa">
                                            <i class="fas fa-trash"></i>
                                        </div>
                                        <div class="action-btn export-event" data-event-id="<c:out value="${event.suKienId}"/>" title="Xuất danh sách">
                                            <i class="fas fa-file-export"></i>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Create Event Content -->
            <div id="create-event" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Tạo sự kiện mới</h3>
                </div>

                <form id="event-form" enctype="multipart/form-data">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="event-name">Tên sự kiện *</label>
                            <input type="text" id="event-name" placeholder="Nhập tên sự kiện" required>
                        </div>
                        <div class="form-group">
                            <label for="event-type">Loại sự kiện *</label>
                            <select id="event-type" required>
                                <option value="">Chọn loại sự kiện</option>
                                <c:forEach var="type" items="${eventTypes}">
                                    <option value="<c:out value="${type.loaiSuKienId}"/>"><c:out value="${type.tenLoai}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="event-description">Mô tả sự kiện *</label>
                        <textarea id="event-description" placeholder="Mô tả chi tiết về sự kiện" required></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="event-start-date">Thời gian bắt đầu *</label>
                            <input type="datetime-local" id="event-start-date" required>
                        </div>
                        <div class="form-group">
                            <label for="event-end-date">Thời gian kết thúc *</label>
                            <input type="datetime-local" id="event-end-date" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="event-location">Địa điểm *</label>
                        <input type="text" id="event-location" placeholder="Nhập địa điểm tổ chức" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="event-capacity">Số lượng người tham gia tối đa *</label>
                            <input type="number" id="event-capacity" min="1" placeholder="Nhập số lượng" required>
                        </div>
                        <div class="form-group">
                            <label for="event-privacy">Quyền riêng tư *</label>
                            <select id="event-privacy" required>
                                <option value="CongKhai">Công khai</option>
                                <option value="RiengTu">Riêng tư</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group" id="private-event-id-group" style="display: none;">
                        <label for="private-event-id">Mã sự kiện riêng tư *</label>
                        <input type="text" id="private-event-id" placeholder="Nhập mã ID cho sự kiện riêng tư">
                        <small class="form-text">Mã này sẽ được sử dụng để người tham gia truy cập sự kiện riêng tư</small>
                    </div>

                    <div class="form-group">
                        <label for="event-image">Hình ảnh sự kiện</label>
                        <input type="file" id="event-image" accept="image/*">
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Tạo sự kiện
                        </button>
                        <button type="reset" class="btn btn-outline">
                            <i class="fas fa-redo"></i> Đặt lại
                        </button>
                    </div>
                </form>
            </div>

            <!-- Attendance Content -->
            <div id="attendance" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Quản lý điểm danh</h3>
                </div>

                <div class="form-group">
                    <label for="select-event-attendance">Chọn sự kiện</label>
                    <select id="select-event-attendance">
                        <option value="">Chọn sự kiện</option>
                        <c:forEach var="event" items="${allEvents}">
                            <option value="<c:out value="${event.suKienId}"/>"><c:out value="${event.tenSuKien}"/></option>
                        </c:forEach>
                    </select>
                </div>

                <div class="table-container">
                    <table id="attendance-table">
                        <thead>
                            <tr>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Thời gian đăng ký</th>
                                <th>Trạng thái điểm danh</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Nội dung sẽ load bằng AJAX -->
                        </tbody>
                    </table>
                </div>

                <div class="form-group" style="margin-top: 20px;">
                    <button class="btn btn-success" id="save-attendance">
                        <i class="fas fa-save"></i> Lưu điểm danh
                    </button>
                    <button class="btn btn-outline" id="export-attendance">
                        <i class="fas fa-file-export"></i> Xuất báo cáo
                    </button>
                </div>
            </div>

            <!-- Participants Content -->
            <div id="participants" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Quản lý người tham gia</h3>
                    <button class="btn btn-outline" id="export-participants">
                        <i class="fas fa-file-export"></i> Xuất danh sách
                    </button>
                </div>

                <div class="form-group">
                    <label for="filter-event-participants">Lọc theo sự kiện</label>
                    <select id="filter-event-participants">
                        <option value="">Tất cả sự kiện</option>
                        <c:forEach var="event" items="${allEvents}">
                            <option value="<c:out value="${event.suKienId}"/>"><c:out value="${event.tenSuKien}"/></option>
                        </c:forEach>
                    </select>
                </div>

                <div class="table-container">
                    <table id="participants-table">
                        <thead>
                            <tr>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Sự kiện đã tham gia</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Nội dung sẽ load bằng AJAX -->
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Analytics Content -->
            <div id="analytics" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Thống kê và báo cáo</h3>
                    <button class="btn btn-outline" id="download-report">
                        <i class="fas fa-download"></i> Tải báo cáo
                    </button>
                </div>

                <div class="dashboard-cards">
                    <div class="card">
                        <div class="card-icon primary">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h3 id="avg-attendance-rate">0%</h3>
                        <p>Tỷ lệ tham gia trung bình</p>
                    </div>
                    <div class="card">
                        <div class="card-icon success">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <h3 id="satisfaction-rate">0%</h3>
                        <p>Khách hàng hài lòng</p>
                    </div>
                    <div class="card">
                        <div class="card-icon warning">
                            <i class="fas fa-money-bill-wave"></i>
                        </div>
                        <h3 id="estimated-revenue">0M</h3>
                        <p>Doanh thu ước tính</p>
                    </div>
                    <div class="card">
                        <div class="card-icon danger">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <h3 id="cancellation-rate">0%</h3>
                        <p>Tỷ lệ hủy đăng ký</p>
                    </div>
                </div>

                <div class="form-group">
                    <label for="report-period">Chọn kỳ báo cáo</label>
                    <select id="report-period">
                        <option value="week">Tuần này</option>
                        <option value="month">Tháng này</option>
                        <option value="quarter">Quý này</option>
                        <option value="year">Năm nay</option>
                        <option value="custom">Tùy chỉnh</option>
                    </select>
                </div>

                <div class="content-section" style="margin-top: 20px;">
                    <h4 style="margin-bottom: 15px;">Sự kiện phổ biến nhất</h4>
                    <div class="table-container">
                        <table id="popular-events-table">
                            <thead>
                                <tr>
                                    <th>Tên sự kiện</th>
                                    <th>Số người đăng ký</th>
                                    <th>Tỷ lệ tham gia</th>
                                    <th>Đánh giá trung bình</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="event" items="${popularEvents}">
                                    <tr>
                                        <td><c:out value="${event.tenSuKien}"/></td>
                                        <td><c:out value="${event.soLuongDaDangKy}"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Trong <div id="analytics" class="content-section">, sau bảng popular events -->
                <div class="charts-section" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(400px, 1fr)); gap: 20px; margin-top: 30px;">
                    <div class="chart-card">
                        <h4>Biểu Đồ Sự Kiện Theo Trạng Thái</h4>
                        <img id="events-by-status-chart" style="width: 100%; height: auto;">
                    </div>
                    <div class="chart-card">
                        <h4>Biểu Đồ Đăng Ký Theo Sự Kiện</h4>
                        <img id="registrations-by-event-chart" style="width: 100%; height: auto;">
                    </div>
                    <div class="chart-card">
                        <h4>Biểu Đồ Đăng Ký Theo Thời Gian</h4>
                        <img id="registrations-over-time-chart" style="width: 100%; height: auto;">
                    </div>
                </div>
            </div>

            <!-- Account Content -->
            <div id="account" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Thông tin tài khoản</h3>
                </div>

                <form id="account-form">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="user-avatar">Ảnh đại diện</label>
                            <div style="display: flex; align-items: center; gap: 15px;">
                                <div class="user-avatar" style="width: 80px; height: 80px; font-size: 32px;" id="account-avatar">
                                    <c:out value="${user.hoTen}"/>
                                </div>
                                <button type="button" class="btn btn-outline" id="change-avatar">
                                    <i class="fas fa-camera"></i> Thay đổi ảnh
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="first-name">Họ *</label>
                            <input type="text" id="first-name" required>
                        </div>
                        <div class="form-group">
                            <label for="last-name">Tên *</label>
                            <input type="text" id="last-name" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="user-email">Email *</label>
                            <input type="email" id="user-email" required>
                        </div>
                        <div class="form-group">
                            <label for="user-phone">Số điện thoại *</label>
                            <input type="tel" id="user-phone" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="user-address">Địa chỉ</label>
                        <input type="text" id="user-address">
                    </div>

                    <div class="form-group">
                        <label for="user-bio">Giới thiệu bản thân</label>
                        <textarea id="user-bio" placeholder="Mô tả về bản thân"></textarea>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Lưu thay đổi
                        </button>
                        <button type="button" class="btn btn-outline" id="change-password">
                            <i class="fas fa-lock"></i> Đổi mật khẩu
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Event Detail Modal -->
    <div class="modal" id="event-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Chi tiết sự kiện</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body" id="event-modal-body">
                <!-- Nội dung sẽ load bằng AJAX -->
            </div>
        </div>
    </div>

    <!-- Participant Detail Modal -->
    <div class="modal" id="participant-detail-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Chi tiết người tham gia</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body" id="participant-detail-body">
                <!-- Nội dung sẽ load bằng AJAX -->
            </div>
        </div>
    </div>

    <!-- Send Notification Modal -->
    <div class="modal" id="send-notification-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Gửi thông báo</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="send-notification-form">
                    <div class="form-group">
                        <label for="notification-title">Tiêu đề</label>
                        <input type="text" id="notification-title" required>
                    </div>
                    <div class="form-group">
                        <label for="notification-content">Nội dung</label>
                        <textarea id="notification-content" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">Gửi</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Change Password Modal -->
    <div class="modal" id="change-password-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Đổi mật khẩu</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="change-password-form">
                    <div class="form-group">
                        <label for="current-password">Mật khẩu hiện tại</label>
                        <input type="password" id="current-password" required>
                    </div>
                    <div class="form-group">
                        <label for="new-password">Mật khẩu mới</label>
                        <input type="password" id="new-password" required>
                    </div>
                    <div class="form-group">
                        <label for="confirm-password">Xác nhận mật khẩu mới</label>
                        <input type="password" id="confirm-password" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Đổi mật khẩu</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Lấy userId từ session
        var userId = <c:out value="${sessionScope.userId}"/>;

        // Navigation functionality
        var menuLinks = document.querySelectorAll('.menu-link');
        for (var i = 0; i < menuLinks.length; i++) {
            menuLinks[i].addEventListener('click', function(e) {
                e.preventDefault();
                
                // Remove active class from all menu links
                var allMenuLinks = document.querySelectorAll('.menu-link');
                for (var j = 0; j < allMenuLinks.length; j++) {
                    allMenuLinks[j].classList.remove('active');
                }
                
                // Remove active class from all content sections
                var allSections = document.querySelectorAll('.content-section');
                for (var k = 0; k < allSections.length; k++) {
                    allSections[k].classList.remove('active');
                }
                
                // Add active class to clicked menu link
                this.classList.add('active');
                
                // Show corresponding content section
                var target = this.getAttribute('data-target');
                document.getElementById(target).classList.add('active');
                
                // Update page title and subtitle
                var pageTitle = document.getElementById('page-title');
                var pageSubtitle = document.getElementById('page-subtitle');
                
                switch(target) {
                    case 'dashboard':
                        pageTitle.textContent = 'Tổng quan';
                        pageSubtitle.textContent = 'Quản lý sự kiện của bạn tại một nơi';
                        loadDashboard();
                        break;
                    case 'events':
                        pageTitle.textContent = 'Quản lý sự kiện';
                        pageSubtitle.textContent = 'Xem và quản lý tất cả sự kiện của bạn';
                        loadEvents();
                        break;
                    case 'create-event':
                        pageTitle.textContent = 'Tạo sự kiện mới';
                        pageSubtitle.textContent = 'Thiết lập thông tin cho sự kiện mới';
                        break;
                    case 'attendance':
                        pageTitle.textContent = 'Điểm danh';
                        pageSubtitle.textContent = 'Quản lý điểm danh người tham gia';
                        loadAttendanceEvents();
                        break;
                    case 'participants':
                        pageTitle.textContent = 'Người tham gia';
                        pageSubtitle.textContent = 'Quản lý thông tin người tham gia sự kiện';
                        loadParticipantsEvents();
                        break;
                    case 'analytics':
                        pageTitle.textContent = 'Thống kê';
                        pageSubtitle.textContent = 'Xem báo cáo và phân tích sự kiện';
                        loadAnalytics();
                        break;
                    case 'account':
                        pageTitle.textContent = 'Tài khoản';
                        pageSubtitle.textContent = 'Quản lý thông tin cá nhân của bạn';
                        loadAccount();
                        break;
                }
            });
        }

        // Create event button
        document.getElementById('create-event-btn').addEventListener('click', function() {
            document.querySelector('[data-target="create-event"]').click();
        });

        // Load dashboard
        function loadDashboard() {
            $.get('/organizer/api/events/upcoming', function(data) {
                var html = '';
                for (var i = 0; i < data.length; i++) {
                    var event = data[i];
                    html += '<div class="event-card" data-event-id="' + event.suKienId + '">' +
                                '<div class="event-image">' +
                                    '<img src="' + (event.anhBia || '/default.jpg') + '" alt="">' +
                                '</div>' +
                                '<div class="event-content">' +
                                    '<h4 class="event-title">' + event.tenSuKien + '</h4>' +
                                    '<div class="event-meta">' +
                                        '<span><i class="far fa-calendar"></i> ' + new Date(event.thoiGianBatDau).toLocaleString() + '</span>' +
                                        '<span><i class="fas fa-map-marker-alt"></i> ' + event.diaDiem + '</span>' +
                                    '</div>' +
                                    '<p>' + event.moTa + '</p>' +
                                    '<div class="event-footer">' +
                                        '<span class="status ' + event.trangThai.toLowerCase() + '">' + event.trangThai + '</span>' +
                                        '<span><i class="fas fa-users"></i> ' + event.soLuongDaDangKy + ' / ' + event.soLuongToiDa + '</span>' +
                                    '</div>' +
                                '</div>' +
                            '</div>';
                }
                $('#upcoming-events-grid').html(html);
            });

            // Load stats
            $.get('/organizer/api/analytics/stats', function(data) {
                $('#active-events').text(data.activeEvents);
                $('#total-participants').text(data.totalParticipants);
                $('#upcoming-events').text(data.upcomingEvents);
                $('#attention-events').text(data.attentionEvents);
            });
        }

        // Load events
        function loadEvents() {
            $.get('/organizer/api/events', function(data) {
                var html = '';

                // Mapping trạng thái sang tiếng Việt
                var trangThaiMap = {
                    'DangDienRa': 'Đang diễn ra',
                    'SapDienRa': 'Sắp diễn ra',
                    'DaKetThuc': 'Đã kết thúc'
                };

                for (var i = 0; i < data.length; i++) {
                    var event = data[i];
                    var trangThaiText = trangThaiMap[event.trangThai] || 'Không xác định';

                    html += '<tr data-event-id="' + event.suKienId + '">' +
                                '<td>' + event.tenSuKien + '</td>' +
                                '<td>' + new Date(event.thoiGianBatDau).toLocaleString() + '</td>' +
                                '<td>' + event.diaDiem + '</td>' +
                                '<td><span class="status ' + event.trangThai.toLowerCase() + '">' + trangThaiText + '</span></td>' +
                                '<td>' + event.soLuongDaDangKy + ' / ' + event.soLuongToiDa + '</td>' +
                                '<td class="action-buttons">' +
                                    '<div class="action-btn edit-event" data-event-id="' + event.suKienId + '" title="Chỉnh sửa">' +
                                        '<i class="fas fa-edit"></i>' +
                                    '</div>' +
                                    '<div class="action-btn delete-event" data-event-id="' + event.suKienId + '" title="Xóa">' +
                                        '<i class="fas fa-trash"></i>' +
                                    '</div>' +
                                    '<div class="action-btn export-event" data-event-id="' + event.suKienId + '" title="Xuất danh sách">' +
                                        '<i class="fas fa-file-export"></i>' +
                                    '</div>' +
                                '</td>' +
                            '</tr>';
                }

                $('#events-table tbody').html(html);
            });
        }

        function editEvent(suKienId) {
            if (!suKienId) {
                alert("ID sự kiện không hợp lệ!");
                return;
            }

            $.get('/organizer/api/events/' + suKienId, function(event) {
                if (!event) {
                    alert("Không tìm thấy sự kiện!");
                    return;
                }

                $('#event-name').val(event.tenSuKien);
                $('#event-type').val(event.loaiSuKienId);
                $('#event-description').val(event.moTa);
                $('#event-start-date').val(new Date(event.thoiGianBatDau).toISOString().slice(0,16));
                $('#event-end-date').val(new Date(event.thoiGianKetThuc).toISOString().slice(0,16));
                $('#event-location').val(event.diaDiem);
                $('#event-capacity').val(event.soLuongToiDa);
                $('#event-privacy').val(event.loaiSuKien);

                // Hiển thị và điền mã riêng tư nếu sự kiện là riêng tư
                if (event.loaiSuKien === 'RiengTu') {
                    $('#private-event-id-group').show();
                    $('#private-event-id').val(event.maRiengTu || '').prop('required', true);
                } else {
                    $('#private-event-id-group').hide();
                    $('#private-event-id').prop('required', false);
                }

                $('#event-form')[0].dataset.editId = suKienId;
                document.querySelector('[data-target="create-event"]').click();
            })
            .fail(function(xhr) {
                alert("Không tải được thông tin sự kiện (mã lỗi " + xhr.status + ")");
            });
        }

        function deleteEvent(suKienId) {
            if (confirm('Xác nhận xóa sự kiện?')) {
                $.ajax({
                    url: '/organizer/api/events/delete',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ suKienId: suKienId }),
                    success: function(response) {
                        if (response.success) {
                            alert(response.message);
                            loadEvents();
                        }
                    }
                });
            }
        }

        function exportEventList(suKienId) {
            window.location.href = '/organizer/api/events/export?suKienId=' + suKienId;
        }

        // Attach events for events table
        $('#events-table tbody').on('click', '.action-btn', function() {
            var target = $(this);
            var eventId = target.data('event-id');
            if (target.hasClass('edit-event')) {
                editEvent(eventId);
            } else if (target.hasClass('delete-event')) {
                deleteEvent(eventId);
            } else if (target.hasClass('export-event')) {
                exportEventList(eventId);
            }
        });

        // Hiển thị/ẩn trường mã sự kiện riêng tư
        $('#event-privacy').on('change', function() {
            if (this.value === 'RiengTu') {
                $('#private-event-id-group').show();
                $('#private-event-id').prop('required', true);
            } else {
                $('#private-event-id-group').hide();
                $('#private-event-id').prop('required', false);
            }
        });

        // Khi reset form, ẩn trường mã riêng tư
        $('#event-form').on('reset', function() {
            $('#private-event-id-group').hide();
            $('#private-event-id').prop('required', false);
        });

        // Submit event form (create or edit)
        $('#event-form').on('submit', function(e) {
            e.preventDefault();
            var isEdit = this.dataset.editId;
            var formData = new FormData();
            var event = {
                suKienId: isEdit ? parseInt(isEdit) : null,
                tenSuKien: $('#event-name').val(),
                loaiSuKienId: $('#event-type').val(),
                moTa: $('#event-description').val(),
                thoiGianBatDau: $('#event-start-date').val(),
                thoiGianKetThuc: $('#event-end-date').val(),
                diaDiem: $('#event-location').val(),
                soLuongToiDa: $('#event-capacity').val(),
                loaiSuKien: $('#event-privacy').val()
            };
            
            // Thêm mã sự kiện riêng tư nếu có
            if ($('#event-privacy').val() === 'RiengTu') {
                event.matKhauSuKienRiengTu = $('#private-event-id').val();
            }
            
            formData.append('event', JSON.stringify(event));
            var imageFile = $('#event-image')[0].files[0];
            if (imageFile) {
                formData.append('anhBiaFile', imageFile);
            }
            var url = isEdit ? '/organizer/api/events/update' : '/organizer/api/events/create';
            var formElement = this;
            $.ajax({
                url: url,
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    if (response.success) {
                        alert(isEdit ? 'Cập nhật thành công!' : 'Tạo thành công!');
                        formElement.reset();
                        delete formElement.dataset.editId;
                        // Ẩn trường mã riêng tư sau khi submit
                        $('#private-event-id-group').hide();
                        $('#private-event-id').prop('required', false);
                        document.querySelector('[data-target="events"]').click();
                    } else {
                        alert(response.message || 'Lỗi xảy ra!');
                    }
                }
            });
        });
        
        // Load attendance events
        function loadAttendanceEvents() {
            $.get('/organizer/api/events', function(data) {
                var html = '<option value="">Chọn sự kiện</option>';
                for (var i = 0; i < data.length; i++) {
                    var event = data[i];
                    html += '<option value="' + event.suKienId + '">' + event.tenSuKien + '</option>';
                }
                $('#select-event-attendance').html(html);
            });
        }

        // Load attendance for selected event
        $('#select-event-attendance').on('change', function() {
            var suKienId = this.value;
            if (suKienId) {
                $.get('/organizer/api/registrations?suKienId=' + suKienId, function(data) {
                    var html = '';
                    for (var i = 0; i < data.length; i++) {
                        var reg = data[i];
                        var statusClass = reg.trangThai.toLowerCase();
                        var diemDanhText = reg.trangThai === 'DaThamGia' ? 'Đã tham gia' : 'Chưa tham gia';
                        var toggleIcon = reg.trangThai === 'DaThamGia' ? 'fa-times' : 'fa-check';
                        var newStatus = reg.trangThai !== 'DaThamGia';
                        html += '<tr data-reg-id="' + reg.dangKyId + '">' +
                                    '<td>' + reg.user.hoTen + '</td>' +
                                    '<td>' + reg.user.email + '</td>' +
                                    '<td>' + reg.user.soDienThoai + '</td>' +
                                    '<td>' + new Date(reg.thoiGianDangKy).toLocaleString() + '</td>' +
                                    '<td><span class="status ' + statusClass + '">' + diemDanhText + '</span></td>' +
                                    '<td class="action-buttons">' +
                                        '<div class="action-btn toggle-attendance" data-reg-id="' + reg.dangKyId + '" data-new-status="' + newStatus + '" title="' + (reg.trangThai === 'DaThamGia' ? 'Đánh dấu vắng' : 'Đánh dấu tham gia') + '">' +
                                            '<i class="fas ' + toggleIcon + '"></i>' +
                                        '</div>' +
                                    '</td>' +
                                '</tr>';
                    }
                    $('#attendance-table tbody').html(html);
                });
            }
        });

        // Attach toggle attendance
        $('#attendance-table tbody').on('click', '.toggle-attendance', function() {
            var target = $(this);
            var dangKyId = target.data('reg-id');
            var newStatus = target.data('new-status');
            toggleAttendance(dangKyId, newStatus);
        });

        function toggleAttendance(dangKyId, newStatus) {
            $.ajax({
                url: '/organizer/api/attendance/update',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ dangKyId: dangKyId, trangThaiDiemDanh: newStatus }),
                success: function(response) {
                    if (response.success) {
                        $('#select-event-attendance').trigger('change');
                    }
                }
            });
        }

        // Save attendance (if batch)
        $('#save-attendance').on('click', function() {
            alert('Điểm danh đã lưu!');
        });

        // Export attendance
        $('#export-attendance').on('click', function() {
            var suKienId = $('#select-event-attendance').val();
            if (suKienId) {
                window.location.href = '/organizer/api/attendance/export?suKienId=' + suKienId;
            } else {
                alert('Vui lòng chọn sự kiện!');
            }
        });

        // Load participants events
        function loadParticipantsEvents() {
            $.get('/organizer/api/events', function(data) {
                var html = '<option value="">Tất cả sự kiện</option>';
                for (var i = 0; i < data.length; i++) {
                    var event = data[i];
                    html += '<option value="' + event.suKienId + '">' + event.tenSuKien + '</option>';
                }
                $('#filter-event-participants').html(html);
            }).fail(function(xhr, status, error) {
                console.error('Lỗi khi load events:', error);
                alert('Không thể tải danh sách sự kiện');
            });
        }

        // Load participants for selected event
        $('#filter-event-participants').on('change', function() {
            var suKienId = this.value;
            console.log('Selected suKienId:', suKienId);
            
            var url = suKienId ? '/organizer/api/registrations?suKienId=' + suKienId : '/organizer/api/registrations';
            
            $.get(url, function(data) {
                console.log('Data received:', data);
                var html = '';
                
                if (data && data.length > 0) {
                    for (var i = 0; i < data.length; i++) {
                        var reg = data[i];
                        var hoTen = reg.user ? reg.user.hoTen : 'N/A';
                        var email = reg.user ? reg.user.email : 'N/A';
                        var soDienThoai = reg.user ? reg.user.soDienThoai : 'N/A';
                        var tenSuKien = reg.suKien ? reg.suKien.tenSuKien : 'N/A';
                        
                        // 🟢 Dịch trạng thái sang tiếng Việt
                        var trangThaiGoc = reg.trangThai || 'Unknown';
                        var trangThaiTV = '';
                        switch (trangThaiGoc) {
                            case 'ChoDuyet':
                                trangThaiTV = 'Chờ duyệt';
                                break;
                            case 'DaDuyet':
                                trangThaiTV = 'Đã duyệt';
                                break;
                            case 'TuChoi':
                                trangThaiTV = 'Từ chối';
                                break;
                            default:
                                trangThaiTV = 'Không xác định';
                        }

                        html += '<tr data-reg-id="' + reg.dangKyId + '">' +
                                    '<td>' + hoTen + '</td>' +
                                    '<td>' + email + '</td>' +
                                    '<td>' + soDienThoai + '</td>' +
                                    '<td>' + tenSuKien + '</td>' +
                                    '<td><span class="status ' + trangThaiGoc.toLowerCase() + '">' + trangThaiTV + '</span></td>' +
                                    '<td class="action-buttons">' +
                                        '<div class="action-btn view-participant-detail" data-reg-id="' + reg.dangKyId + '" title="Xem chi tiết">' +
                                            '<i class="fas fa-eye"></i>' +
                                        '</div>' +
                                        '<div class="action-btn send-notification" data-reg-id="' + reg.dangKyId + '" title="Gửi thông báo">' +
                                            '<i class="fas fa-bell"></i>' +
                                        '</div>' +
                                    '</td>' +
                                '</tr>';
                    }
                } else {
                    html = '<tr><td colspan="6" style="text-align: center;">Không có dữ liệu người tham gia</td></tr>';
                }
                
                $('#participants-table tbody').html(html);
            }).fail(function(xhr, status, error) {
                console.error('Lỗi khi load participants:', error);
                alert('Không thể tải danh sách người tham gia');
                $('#participants-table tbody').html('<tr><td colspan="6" style="text-align: center; color: red;">Lỗi khi tải dữ liệu</td></tr>');
            });
        });

        // Attach events for participants table
        $('#participants-table tbody').on('click', '.action-btn', function() {
            var target = $(this);
            var regId = target.data('reg-id');
            if (target.hasClass('view-participant-detail')) {
                openParticipantDetailModal(regId);
            } else if (target.hasClass('send-notification')) {
                openSendNotificationModal(regId);
            }
        });

        // Export participants
        $('#export-participants').on('click', function() {
            var suKienId = $('#filter-event-participants').val();
            var param = suKienId ? '?suKienId=' + suKienId : '';
            window.location.href = '/organizer/api/participants/export' + param;
        });

        // Load analytics
        function loadAnalytics(period) {
            period = period || 'month';
            $.get('/organizer/api/analytics/stats?period=' + period, function(data) {
                $('#avg-attendance-rate').text(data.avgAttendanceRate + '%');
                $('#satisfaction-rate').text(data.satisfactionRate + '%');
                $('#estimated-revenue').text(data.estimatedRevenue + 'M');
                $('#cancellation-rate').text(data.cancellationRate + '%');
                
                // Set charts từ base64
                if (data.eventsByStatusChart) {
                    $('#events-by-status-chart').attr('src', 'data:image/png;base64,' + data.eventsByStatusChart);
                }
                if (data.registrationsByEventChart) {
                    $('#registrations-by-event-chart').attr('src', 'data:image/png;base64,' + data.registrationsByEventChart);
                }
                if (data.registrationsOverTimeChart) {
                    $('#registrations-over-time-chart').attr('src', 'data:image/png;base64,' + data.registrationsOverTimeChart);
                }
            }).fail(function(xhr, status, error) {
                console.log("Lỗi khi load analytics:", error);  // In console browser (F12 để xem)
            });

            $.get('/organizer/api/analytics/popular?period=' + period, function(data) {
                var html = '';
                for (var i = 0; i < data.length; i++) {
                    var event = data[i];
                    html += '<tr>' +
                                '<td>' + event.tenSuKien + '</td>' +
                                '<td>' + event.soLuongDaDangKy + '</td>' +
                                '<td>' + event.tyLeThamGia + '%</td>' +
                                '<td>' + event.danhGiaTrungBinh + '/5</td>' +
                            '</tr>';
                }
                $('#popular-events-table tbody').html(html);
            });
        }

        // Report period change
        $('#report-period').on('change', function() {
            loadAnalytics(this.value);
        });

        // Download report
        $('#download-report').on('click', function() {
            var period = $('#report-period').val();
            window.location.href = '/organizer/api/analytics/export?period=' + period;
        });

        // Load account
        function loadAccount() {
            $.get('/organizer/api/account', function(user) {
                var names = user.hoTen.split(' ');
                $('#first-name').val(names[0] || '');
                $('#last-name').val(names.slice(1).join(' ') || '');
                $('#user-email').val(user.email);
                $('#user-phone').val(user.soDienThoai);
                $('#user-address').val(user.diaChi);
                $('#user-bio').val(user.bio || '');
                var avatarText = user.hoTen.split(' ').map(function(name) {
                    return name[0];
                }).join('');
                $('#account-avatar').text(avatarText);
            });
        }

        // Submit account update
        $('#account-form').on('submit', function(e) {
            e.preventDefault();
            var user = {
                nguoiDungId: userId,
                hoTen: $('#first-name').val() + ' ' + $('#last-name').val(),
                email: $('#user-email').val(),
                soDienThoai: $('#user-phone').val(),
                diaChi: $('#user-address').val(),
                bio: $('#user-bio').val()
            };
            $.ajax({
                url: '/organizer/api/account/update',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(user),
                success: function(response) {
                    if (response.success) {
                        alert(response.message);
                        loadAccount();
                    }
                }
            });
        });

        // Open change password modal
        $('#change-password').on('click', function() {
            $('#change-password-modal').show();
        });

        // Submit change password
        $('#change-password-form').on('submit', function(e) {
            e.preventDefault();
            if ($('#new-password').val() !== $('#confirm-password').val()) {
                alert('Mật khẩu mới không khớp!');
                return;
            }
            var data = {
                currentPassword: $('#current-password').val(),
                newPassword: $('#new-password').val()
            };
            var formElement = this;
            $.ajax({
                url: '/organizer/api/account/change-password',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function(response) {
                    if (response.success) {
                        alert(response.message);
                        $('#change-password-modal').hide();
                        formElement.reset();
                    } else {
                        alert(response.message || 'Lỗi xảy ra!');
                    }
                }
            });
        });

        // Modal functionality for event
        var eventModal = $('#event-modal');
        $('.close-modal').on('click', function() {
            $(this).closest('.modal').hide();
        });

        $(window).on('click', function(e) {
            if ($(e.target).hasClass('modal')) {
                $(e.target).hide();
            }
        });

        function openEventModal(suKienId) {
            $.get('/organizer/api/events/' + suKienId, function(event) {
                var trangThaiHienThi = '';

                switch (event.trangThai) {
                    case 'DangDienRa':
                        trangThaiHienThi = 'Đang diễn ra';
                        break;
                    case 'SapDienRa':
                        trangThaiHienThi = 'Sắp diễn ra';
                        break;
                    case 'DaKetThuc':
                        trangThaiHienThi = 'Đã kết thúc';
                        break;
                    default:
                        trangThaiHienThi = 'Không xác định';
                }
                var html = '<div class="event-image" style="margin-bottom: 20px;">' +
                                '<img src="' + (event.anhBia || '/default.jpg') + '" alt="' + event.tenSuKien + '">' +
                            '</div>' +
                            '<h4 style="margin-bottom: 15px;">' + event.tenSuKien + '</h4>' +
                            '<div class="event-meta" style="margin-bottom: 15px;">' +
                                '<span><i class="far fa-calendar"></i> ' + new Date(event.thoiGianBatDau).toLocaleString() + '</span>' +
                                '<span><i class="fas fa-map-marker-alt"></i> ' + event.diaDiem + '</span>' +
                            '</div>' +
                            '<p style="margin-bottom: 20px;">' + event.moTa + '</p>' +
                            '<div class="form-row">' +
                                '<div class="form-group">' +
                                    '<label>Trạng thái:</label>' +
                                    '<span class="status ' + event.trangThai.toLowerCase() + '">' + trangThaiHienThi + '</span>' +
                                '</div>' +
                                '<div class="form-group">' +
                                    '<label>Số người tham gia:</label>' +
                                    '<span>' + event.soLuongDaDangKy + ' / ' + event.soLuongToiDa + '</span>' +
                                '</div>' +
                            '</div>' +
                            '<div class="form-group" style="margin-top: 20px;">' +
                                '<button class="btn btn-primary edit-event-from-modal" data-event-id="' + event.suKienId + '">' +
                                    '<i class="fas fa-edit"></i> Chỉnh sửa' +
                                '</button>' +
                                '<button class="btn btn-outline export-event-from-modal" data-event-id="' + event.suKienId + '">' +
                                    '<i class="fas fa-file-export"></i> Xuất danh sách' +
                                '</button>' +
                            '</div>';
                $('#event-modal-body').html(html);
                eventModal.show();
            });
        }

        // Attach open modal for event cards
        $('#upcoming-events-grid').on('click', '.event-card', function() {
            var eventId = $(this).data('event-id');
            openEventModal(eventId);
        });

        // Attach events for modal buttons
        $('#event-modal-body').on('click', 'button', function() {
            var target = $(this);
            var eventId = target.data('event-id');
            if (target.hasClass('edit-event-from-modal')) {
                editEvent(eventId);
            } else if (target.hasClass('export-event-from-modal')) {
                exportEventList(eventId);
            }
        });

        // Open participant detail modal
        function openParticipantDetailModal(regId) {
            $.get('/organizer/api/registrations/' + regId, function(reg) {
                var html = '<h4>' + reg.user.hoTen + '</h4>' +
                            '<p>Email: ' + reg.user.email + '</p>' +
                            '<p>Số điện thoại: ' + reg.user.soDienThoai + '</p>' +
                            '<p>Địa chỉ: ' + reg.user.diaChi + '</p>' +
                            '<p>Giới tính: ' + reg.user.gioiTinh + '</p>' +
                            '<p>Sự kiện: ' + reg.suKien.tenSuKien + '</p>' +
                            '<p>Thời gian đăng ký: ' + new Date(reg.thoiGianDangKy).toLocaleString() + '</p>' +
                            '<p>Trạng thái: ' + reg.trangThai + '</p>' +
                            '<p>Ghi chú: ' + (reg.ghiChu || 'Không có') + '</p>';
                $('#participant-detail-body').html(html);
                $('#participant-detail-modal').show();
            });
        }

        // Open send notification modal
        function openSendNotificationModal(regId) {
            $('#send-notification-form')[0].dataset.regId = regId;
            $('#send-notification-modal').show();
        }

        // Submit send notification
        $('#send-notification-form').on('submit', function(e) {
            e.preventDefault();
            var regId = this.dataset.regId;
            var data = {
                regId: regId,
                title: $('#notification-title').val(),
                content: $('#notification-content').val()
            };
            var formElement = this;
            $.ajax({
                url: '/organizer/api/notifications/send',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function(response) {
                    if (response.success) {
                        alert('Thông báo đã gửi!');
                        $('#send-notification-modal').hide();
                        formElement.reset();
                    }
                }
            });
        });

        // Initial load
        loadDashboard();
    </script>
</body>
</html>