<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHub - Quản trị viên</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>         
    <style>
        :root {
            --primary: #9C27B0;
            --primary-light: #F3E5F5;
            --secondary: #7237d8ff;
            --success: #4CAF50;
            --warning: #FF9800;
            --danger: #F44336;
            --dark: #2E3A47;
            --light: #F5F7FA;
            --gray: #90A4AE;
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
            background-color: #f8f5f9;
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
            background: linear-gradient(180deg, var(--primary) 0%, #8E24AA 100%);
            color: white;
            padding: 20px 0;
            transition: var(--transition);
            box-shadow: var(--box-shadow);
            z-index: 100;

            /* Thêm các thuộc tính sau để cố định */
            position: sticky;
            top: 0;
            height: 100vh;
            overflow-y: auto;
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

        .header-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .search-box {
            position: relative;
        }

        .search-box input {
            padding: 10px 15px 10px 40px;
            border: 1px solid #ddd;
            border-radius: 8px;
            width: 250px;
            font-size: 14px;
            transition: var(--transition);
        }

        .search-box input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(156, 39, 176, 0.2);
        }

        .search-box i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray);
        }

        .notification {
            position: relative;
            cursor: pointer;
        }

        .notification i {
            font-size: 20px;
            color: var(--dark);
        }

        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background-color: var(--danger);
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
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
            background-color: rgba(76, 175, 80, 0.15);
            color: var(--success);
        }

        .card-icon.warning {
            background-color: rgba(255, 152, 0, 0.15);
            color: var(--warning);
        }

        .card-icon.danger {
            background-color: rgba(244, 67, 54, 0.15);
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
            background-color: #8E24AA;
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
            background-color: rgba(76, 175, 80, 0.15);
            color: var(--success);
        }

        .status.pending {
            background-color: rgba(255, 193, 7, 0.15);
            color: var(--warning);
        }

        .status.cancelled {
            background-color: rgba(244, 67, 54, 0.15);
            color: var(--danger);
        }

        .status.active {
            background-color: rgba(76, 175, 80, 0.15);
            color: var(--success);
        }

        .status.inactive {
            background-color: rgba(244, 67, 54, 0.15);
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
            box-shadow: 0 0 0 3px rgba(156, 39, 176, 0.2);
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

        /* Modal Center Fix */
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
            padding: 20px;
        }

        .modal-content {
            background: white;
            border-radius: var(--border-radius);
            width: 90%;
            max-width: 600px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            margin: auto;
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

        /* Ensure modal is centered on mobile */
        @media (max-width: 768px) {
            .modal {
                padding: 10px;
            }
            
            .modal-content {
                width: 95%;
                max-width: none;
            }
        }

        /* Filter Section */
        .filter-section {
            background: white;
            border-radius: var(--border-radius);
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: var(--box-shadow);
        }

        .filter-row {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .filter-group {
            flex: 1;
            min-width: 180px;
        }

        /* Charts */
        .chart-container {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: var(--box-shadow);
        }

        .chart-placeholder {
            height: 300px;
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--gray);
            font-size: 18px;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 20px;
            box-shadow: var(--box-shadow);
            text-align: center;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-label {
            color: var(--gray);
            font-size: 14px;
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
            
            .search-box input {
                width: 200px;
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
            
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .header-actions {
                width: 100%;
                justify-content: space-between;
            }
            
            .search-box input {
                width: 100%;
            }
            
            .filter-row {
                flex-direction: column;
                gap: 10px;
            }
            
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }


        .event-card {
            cursor: pointer;
            transition: var(--transition);
            position: relative;
        }

        .event-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        /* Đảm bảo các nút hành động vẫn hoạt động bình thường */
        .event-card .action-buttons {
            cursor: default;
            pointer-events: auto;
        }

        .event-card .action-btn {
            cursor: pointer;
            pointer-events: auto;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo">
                <i class="fas fa-user-shield"></i>
                <h1>EventHub Admin</h1>
            </div>
            <ul class="menu">
                <li class="menu-item">
                    <a href="#" class="menu-link active" data-target="dashboard">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Tổng quan</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="users">
                        <i class="fas fa-users"></i>
                        <span>Quản lý người dùng</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="events">
                        <i class="fas fa-calendar-week"></i>
                        <span>Quản lý sự kiện</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="approvals">
                        <i class="fas fa-clipboard-check"></i>
                        <span>Phê duyệt sự kiện</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="analytics">
                        <i class="fas fa-chart-bar"></i>
                        <span>Thống kê</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="suggestions">
                        <i class="fas fa-lightbulb"></i>
                        <span>Gợi ý sự kiện</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="settings">
                        <i class="fas fa-cog"></i>
                        <span>Cài đặt hệ thống</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <div class="header">
                <div class="header-title">
                    <h2 id="page-title">Tổng quan hệ thống</h2>
                    <p id="page-subtitle">Quản lý và giám sát toàn bộ hệ thống EventHub</p>
                </div>
                <div class="header-actions">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="global-search" placeholder="Tìm kiếm...">
                    </div>
                    <div class="notification">
                        <i class="fas fa-bell"></i>
                        <div class="notification-badge" id="notification-count">0</div>
                    </div>
                    <div class="user-info">
                        <div class="user-avatar">AD</div>
                        <div class="user-details">
                            <h4>Quản trị viên</h4>
                            <p>Administrator</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div id="dashboard" class="content-section active">
                <div class="dashboard-cards">
                    <div class="card">
                        <div class="card-icon primary">
                            <i class="fas fa-users"></i>
                        </div>
                        <h3 id="total-users">${totalUsers}</h3>
                        <p>Tổng số người dùng</p>
                    </div>
                    <div class="card">
                        <div class="card-icon success">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <h3 id="active-events">0</h3>
                        <p>Sự kiện đang hoạt động</p>
                    </div>
                    <div class="card">
                        <div class="card-icon warning">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h3 id="pending-events">0</h3>
                        <p>Sự kiện chờ duyệt</p>
                    </div>
                    <div class="card">
                        <div class="card-icon danger">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <h3 id="violation-events">0</h3>
                        <p>Sự kiện vi phạm</p>
                    </div>
                </div>

                <!-- Recent Events -->
                <div class="section-header">
                    <h3 class="section-title">Sự kiện gần đây</h3>
                    <button class="btn btn-outline" id="btn-view-all-events">
                        <i class="fas fa-eye"></i> Xem tất cả
                    </button>
                </div>
                <div id="recent-events" class="events-grid">
                    <!-- Recent events will be loaded here -->
                </div>
            </div>

            <!-- Users Management Content -->
            <div id="users" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Quản lý người dùng</h3>
                    <button class="btn btn-outline" id="btn-export-users">
                        <i class="fas fa-file-export"></i> Xuất báo cáo
                    </button>
                </div>

                <div class="filter-section">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="user-role">Vai trò</label>
                            <select id="user-role">
                                <option value="">Tất cả vai trò</option>
                                <option value="ToChuc">Người tổ chức</option>
                                <option value="NguoiDung">Người tham gia</option>
                                <option value="Admin">Quản trị viên</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="user-status">Trạng thái</label>
                            <select id="user-status">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active">Đang hoạt động</option>
                                <option value="inactive">Đã khóa</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="table-container">
                    <table id="users-table">
                        <thead>
                            <tr>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Vai trò</th>
                                <th>Ngày đăng ký</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="users-tbody">
                            <!-- Users data will be loaded here -->
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Events Management Content -->
            <div id="events" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Quản lý sự kiện</h3>
                    <button class="btn btn-outline" id="btn-export-events">
                        <i class="fas fa-file-export"></i> Xuất báo cáo
                    </button>
                </div>

                <div class="filter-section">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="event-status">Trạng thái</label>
                            <select id="event-status">
                                <option value="">Tất cả trạng thái</option>
                                <option value="SapDienRa">Sắp diễn ra</option>
                                <option value="DangDienRa">Đang diễn ra</option>
                                <option value="DaKetThuc">Đã kết thúc</option>
                                <option value="Huy">Đã hủy</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="event-type">Loại sự kiện</label>
                            <select id="event-type">
                                <option value="">Tất cả loại</option>
                                <option value="CongKhai">Công khai</option>
                                <option value="RiengTu">Riêng tư</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="table-container">
                    <table id="events-table">
                        <thead>
                            <tr>
                                <th>Tên sự kiện</th>
                                <th>Người tổ chức</th>
                                <th>Ngày diễn ra</th>
                                <th>Địa điểm</th>
                                <th>Loại sự kiện</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="events-tbody">
                            <!-- Events data will be loaded here -->
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Approvals Content -->
            <div id="approvals" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Phê duyệt sự kiện</h3>
                    <div>
                        <span class="status pending" id="pending-count">0 sự kiện chờ duyệt</span>
                    </div>
                </div>
                <div id="pending-events-list" class="events-grid">
                    <!-- Pending events will be loaded here -->
                </div>
            </div>

            <!-- Analytics Content -->
            <div id="analytics" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Thống kê hệ thống</h3>
                    <button class="btn btn-outline" id="btn-download-report">
                        <i class="fas fa-download"></i> Tải báo cáo
                    </button>
                </div>

                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-value" id="stat-total-users">0</div>
                        <div class="stat-label">Tổng số người dùng</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value" id="stat-active-events">0</div>
                        <div class="stat-label">Sự kiện đang hoạt động</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value" id="stat-pending-events">0</div>
                        <div class="stat-label">Sự kiện chờ duyệt</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value" id="stat-avg-participation">0%</div>
                        <div class="stat-label">Tỷ lệ tham gia trung bình</div>
                    </div>
                </div>
                
                <!--biểu đồ-->
                <div class="charts-section" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(400px, 1fr)); gap: 20px;">
                    <div class="chart-container">
                        <h3>Sự Kiện Theo Trạng Thái</h3>
                        <img id="eventsByStatusChart" src="" alt="Biểu đồ sự kiện theo trạng thái" style="width: 100%; height: auto;">
                        <div id="eventsByStatusPlaceholder" class="chart-placeholder" style="display: none;">Đang tải biểu đồ...</div>
                    </div>
                    <div class="chart-container">
                        <h3>Đăng Ký Theo Sự Kiện Phổ Biến</h3>
                        <img id="registrationsByEventChart" src="" alt="Biểu đồ đăng ký theo sự kiện" style="width: 100%; height: auto;">
                        <div id="registrationsByEventPlaceholder" class="chart-placeholder" style="display: none;">Đang tải biểu đồ...</div>
                    </div>
                    <div class="chart-container">
                        <h3>Đăng Ký Theo Thời Gian</h3>
                        <img id="registrationsOverTimeChart" src="" alt="Biểu đồ đăng ký theo thời gian" style="width: 100%; height: auto;">
                        <div id="registrationsOverTimePlaceholder" class="chart-placeholder" style="display: none;">Đang tải biểu đồ...</div>
                    </div>
                </div>
            </div>

            <!-- Suggestions Content -->
            <div id="suggestions" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Quản lý gợi ý sự kiện</h3>
                    <button class="btn btn-primary" id="btn-save-suggestion-config">
                        <i class="fas fa-cog"></i> Lưu cấu hình
                    </button>
                </div>

                <div class="form-group">
                    <label for="suggestion-algorithm">Thuật toán gợi ý</label>
                    <select id="suggestion-algorithm">
                        <option value="collaborative">Lọc cộng tác (Collaborative Filtering)</option>
                        <option value="content-based">Dựa trên nội dung (Content-Based)</option>
                        <option value="hybrid">Kết hợp (Hybrid)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Yếu tố ưu tiên</label>
                    <div style="display: flex; flex-wrap: wrap; gap: 15px; margin-top: 10px;">
                        <label style="display: flex; align-items: center; gap: 5px;">
                            <input type="checkbox" id="factor-history" checked> Lịch sử tìm kiếm
                        </label>
                        <label style="display: flex; align-items: center; gap: 5px;">
                            <input type="checkbox" id="factor-participation" checked> Sự kiện đã tham gia
                        </label>
                        <label style="display: flex; align-items: center; gap: 5px;">
                            <input type="checkbox" id="factor-preferences" checked> Sở thích người dùng
                        </label>
                    </div>
                </div>
            </div>

            <!-- Settings Content -->
            <div id="settings" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Cài đặt hệ thống</h3>
                </div>

                <div class="form-group">
                    <label for="system-name">Tên hệ thống</label>
                    <input type="text" id="system-name" value="EventHub">
                </div>

                <div class="form-group">
                    <label for="system-description">Mô tả hệ thống</label>
                    <textarea id="system-description">Nền tảng quản lý và tham gia sự kiện trực tuyến</textarea>
                </div>

                <div class="form-group">
                    <button class="btn btn-primary" id="btn-save-settings">
                        <i class="fas fa-save"></i> Lưu cài đặt
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- User Detail Modal -->
    <div class="modal" id="user-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Chi tiết người dùng</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <div id="user-modal-content">
                    <!-- User details will be loaded here -->
                </div>
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
            <div class="modal-body">
                <div id="event-modal-content">
                    <!-- Event details will be loaded here -->
                </div>
            </div>
        </div>
    </div>

    <script>
        // Global variables
        let currentUsers = [];
        let currentEvents = [];

        // Initialize page
        $(document).ready(function() {
            loadDashboardData();
            setupEventListeners();
        });

        // Navigation functionality
        function setupEventListeners() {
            // Menu navigation
            $('.menu-link').click(function(e) {
                e.preventDefault();
                
                // Remove active class from all links and sections
                $('.menu-link').removeClass('active');
                $('.content-section').removeClass('active');
                
                // Add active class to clicked link
                $(this).addClass('active');
                
                // Show corresponding section
                const target = $(this).data('target');
                $('#' + target).addClass('active');
                
                // Load data for the section
                switch(target) {
                    case 'dashboard':
                        loadDashboardData();
                        break;
                    case 'users':
                        loadUsers();
                        break;
                    case 'events':
                        loadEvents();
                        break;
                    case 'approvals':
                        loadPendingEvents();
                        break;
                    case 'analytics':
                        loadAnalytics();
                        break;
                }
                
                updatePageTitle(target);
            });

            // Global search
            $('#global-search').on('input', function() {
                const searchTerm = $(this).val().toLowerCase();
                filterTables(searchTerm);
            });

            // Modal functionality
            $('.close-modal').click(function() {
                $('#user-modal, #event-modal').hide();
            });

            $(window).click(function(e) {
                if ($(e.target).hasClass('modal')) {
                    $('#user-modal, #event-modal').hide();
                }
            });

            // Button events
            $('#btn-view-all-events').click(function() {
                loadAllEvents();
            });

            $('#btn-export-users').click(function() {
                exportUsers();
            });

            $('#btn-export-events').click(function() {
                exportEvents();
            });

            $('#btn-download-report').click(function() {
                downloadReport();
            });

            $('#btn-save-suggestion-config').click(function() {
                saveSuggestionConfig();
            });

            $('#btn-save-settings').click(function() {
                saveSystemSettings();
            });

            // Filter events
            $('#user-role, #user-status').change(function() {
                loadUsers();
            });

            $('#event-status, #event-type').change(function() {
                loadEvents();
            });

            // Event delegation for dynamic content
            $(document).on('click', '.btn-view-user', function() {
                const userId = $(this).data('user-id');
                viewUser(userId);
            });

            $(document).on('click', '.btn-toggle-user-status', function() {
                const userId = $(this).data('user-id');
                const isActive = $(this).data('is-active');
                toggleUserStatus(userId, isActive);
            });

            $(document).on('click', '.btn-approve-event', function() {
                const eventId = $(this).data('event-id');
                approveEvent(eventId);
            });

            $(document).on('click', '.btn-reject-event', function() {
                const eventId = $(this).data('event-id');
                rejectEvent(eventId);
            });

            $(document).on('click', '.btn-delete-event', function() {
                const eventId = $(this).data('event-id');
                deleteEvent(eventId);
            });

         
            // Thêm sự kiện click cho card sự kiện
            $(document).on('click', '.event-card', function(e) {
                // Ngăn chặn sự kiện khi click vào các nút hành động
                if ($(e.target).closest('.action-btn').length === 0) {
                    const eventId = $(this).find('.btn-view-event').data('event-id') || 
                                $(this).closest('[data-event-id]').data('event-id') ||
                                $(this).data('event-id');
                    if (eventId) {
                        viewEvent(eventId);
                    }
                }
            });
        }

        function updatePageTitle(section) {
            const titles = {
                'dashboard': ['Tổng quan hệ thống', 'Quản lý và giám sát toàn bộ hệ thống EventHub'],
                'users': ['Quản lý người dùng', 'Quản lý tài khoản người dùng và phân quyền'],
                'events': ['Quản lý sự kiện', 'Quản lý và giám sát tất cả sự kiện'],
                'approvals': ['Phê duyệt sự kiện', 'Xem xét và phê duyệt sự kiện mới'],
                'analytics': ['Thống kê hệ thống', 'Phân tích và báo cáo hệ thống'],
                'suggestions': ['Gợi ý sự kiện', 'Quản lý thuật toán gợi ý sự kiện'],
                'settings': ['Cài đặt hệ thống', 'Cấu hình hệ thống và tùy chọn']
            };
            
            $('#page-title').text(titles[section][0]);
            $('#page-subtitle').text(titles[section][1]);
        }

        // API Functions
        function loadDashboardData() {
            $.get('/admin/api/dashboard', function(data) {
                $('#total-users').text(data.totalUsers || 0);
                $('#active-events').text(data.activeEvents || 0);
                $('#pending-events').text(data.pendingEvents || 0);
                $('#violation-events').text(data.violationEvents || 0);
                $('#notification-count').text(data.notificationCount || 0);
                
                // Hiển thị sự kiện gần đây từ dữ liệu thực tế
                if (data.recentEvents && data.recentEvents.length > 0) {
                    displayRecentEvents(data.recentEvents);
                } else {
                    displayRecentEvents([]);
                }
            }).fail(function(xhr, status, error) {
                console.error('Error loading dashboard data:', error);
                showError('Lỗi tải dữ liệu dashboard: ' + error);
                
                // Hiển thị trạng thái lỗi
                $('#recent-events').html(`
                    <div class="no-events" style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--danger);">
                        <i class="fas fa-exclamation-triangle" style="font-size: 48px; margin-bottom: 15px;"></i>
                        <h3>Lỗi tải dữ liệu</h3>
                        <p>Không thể tải danh sách sự kiện gần đây.</p>
                    </div>
                `);
            });
        }

        function loadUsers() {
            const role = $('#user-role').val();
            const status = $('#user-status').val();
            
            const filters = { role: role, status: status };
            
            // Hiển thị loading
            $('#users-tbody').html(`
                <tr>
                    <td colspan="7" style="text-align: center; padding: 40px;">
                        <i class="fas fa-spinner fa-spin" style="font-size: 24px; color: var(--primary); margin-bottom: 10px;"></i>
                        <p>Đang tải danh sách người dùng...</p>
                    </td>
                </tr>
            `);
            
            $.get('/admin/api/users', filters, function(users) {
                currentUsers = users;
                let html = '';
                
                if (users.length == 0) {
                    html = '<tr><td colspan="7" style="text-align: center; padding: 40px; color: var(--gray);">' +
                        '<i class="fas fa-users" style="font-size: 48px; margin-bottom: 15px;"></i>' +
                        '<h3>Không tìm thấy người dùng</h3>' +
                        '<p>Không có người dùng nào phù hợp với bộ lọc của bạn.</p>' +
                        '</td></tr>';
                } else {
                    users.forEach(function(user) {
                        // Xử lý dữ liệu thực tế từ server
                        const statusClass = user.trangThai == 'active' ? 'active' : 'inactive';
                        const statusText = user.trangThai == 'active' ? 'Đang hoạt động' : 'Đã khóa';
                        const registrationDate = user.ngayTao ? new Date(user.ngayTao).toLocaleDateString('vi-VN') : 'N/A';
                        
                        html += '<tr>' +
                            '<td>' + (user.hoTen) + '</td>' +
                            '<td>' + user.email + '</td>' +
                            '<td>' + (user.soDienThoai) + '</td>' +
                            '<td>' + user.vaiTro + '</td>' +
                            '<td>' + registrationDate + '</td>' +
                            '<td><span class="status ' + statusClass + '">' + statusText + '</span></td>' +
                            '<td class="action-buttons">' +
                                '<div class="action-btn btn-view-user" data-user-id="' + user.nguoiDungId + '" title="Xem chi tiết">' +
                                    '<i class="fas fa-eye"></i>' +
                                '</div>' +
                                '<div class="action-btn btn-toggle-user-status" data-user-id="' + user.nguoiDungId + '" data-is-active="' + (user.trangThai == 'active') + '" title="' + (user.trangThai == 'active' ? 'Khóa' : 'Mở khóa') + ' tài khoản">' +
                                    '<i class="fas ' + (user.trangThai == 'active' ? 'fa-lock' : 'fa-unlock') + '"></i>' +
                                '</div>' +
                            '</td>' +
                        '</tr>';
                    });
                }
                $('#users-tbody').html(html);
            }).fail(function(xhr, status, error) {
                console.error('Error loading users:', error);
                $('#users-tbody').html(`
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 40px; color: var(--danger);">
                            <i class="fas fa-exclamation-triangle" style="font-size: 48px; margin-bottom: 15px;"></i>
                            <h3>Lỗi tải dữ liệu</h3>
                            <p>Không thể tải danh sách người dùng.</p>
                        </td>
                    </tr>
                `);
            });
        }

        function loadEvents() {
            const status = $('#event-status').val();
            const type = $('#event-type').val();
            
            const filters = { status: status, type: type };
            
            $.get('/admin/api/events', filters, function(events) {
                currentEvents = events;
                let html = '';
                
                if (events.length == 0) {
                    html = '<tr><td colspan="7" style="text-align: center; padding: 40px; color: var(--gray);">' +
                        '<i class="fas fa-calendar-times" style="font-size: 48px; margin-bottom: 15px;"></i>' +
                        '<h3>Không tìm thấy sự kiện</h3>' +
                        '<p>Không có sự kiện nào phù hợp với bộ lọc của bạn.</p>' +
                        '</td></tr>';
                } else {
                    events.forEach(function(event) {
                        const statusClass = getEventStatusClass(event.trangThai);
                        const statusText = getEventStatusText(event.trangThai);
                        const eventDate = event.thoiGianBatDau ? new Date(event.thoiGianBatDau).toLocaleDateString('vi-VN') : 'N/A';
                        const eventType = event.loaiSuKien == 'CongKhai' ? 'Công khai' : 'Riêng tư';
                        
                        html += '<tr class="event-row" data-event-id="' + event.suKienId + '">' +
                            '<td>' + event.tenSuKien + '</td>' +
                            '<td>' + event.organizerName + '</td>' +
                            '<td>' + eventDate + '</td>' +
                            '<td>' + event.diaDiem + '</td>' +
                            '<td>' + eventType + '</td>' +
                            '<td><span class="status ' + statusClass + '">' + statusText + '</span></td>' +
                            '<td class="action-buttons">' +
                                '<div class="action-btn btn-view-event" data-event-id="' + event.suKienId + '" title="Xem chi tiết">' +
                                    '<i class="fas fa-eye"></i>' +
                                '</div>' +
                                '<div class="action-btn" title="Chỉnh sửa">' +
                                    '<i class="fas fa-edit"></i>' +
                                '</div>' +
                                '<div class="action-btn btn-delete-event" data-event-id="' + event.suKienId + '" title="Xóa">' +
                                    '<i class="fas fa-trash"></i>' +
                                '</div>' +
                            '</td>' +
                        '</tr>';
                    });
                }
                $('#events-tbody').html(html);
            }).fail(function() {
                showError('Lỗi tải danh sách sự kiện');
            });
        }

        function loadPendingEvents() {
            $.get('/admin/api/events/pending', function(data) {
                $('#pending-count').text(data.length + ' sự kiện chờ duyệt');
                let html = '';
                
                if (data.length == 0) {
                    html = '<div class="no-events" style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--gray);">' +
                        '<i class="fas fa-clipboard-check" style="font-size: 48px; margin-bottom: 15px;"></i>' +
                        '<h3>Không có sự kiện chờ duyệt</h3>' +
                        '<p>Tất cả sự kiện đã được xử lý.</p>' +
                        '</div>';
                } else {
                    data.forEach(function(event) {
                        const eventDate = event.thoiGianBatDau ? new Date(event.thoiGianBatDau).toLocaleDateString('vi-VN') : 'N/A';
                        
                        html += '<div class="event-card" data-event-id="' + event.suKienId + '">' +
                            '<div class="event-image">' +
                                '<i class="fas fa-calendar-alt"></i>' +
                            '</div>' +
                            '<div class="event-content">' +
                                '<h4 class="event-title">' + event.tenSuKien + '</h4>' +
                                '<div class="event-meta">' +
                                    '<span><i class="far fa-calendar"></i> ' + eventDate + '</span>' +
                                    '<span><i class="fas fa-map-marker-alt"></i> ' + event.diaDiem + '</span>' +
                                '</div>' +
                                '<p>' + (event.moTa ? (event.moTa.length > 100 ? event.moTa.substring(0, 100) + '...' : event.moTa) : 'Không có mô tả') + '</p>' +
                                '<div class="event-footer">' +
                                    '<div class="action-buttons">' +
                                        '<div class="action-btn btn-approve-event" data-event-id="' + event.suKienId + '" title="Phê duyệt">' +
                                            '<i class="fas fa-check"></i>' +
                                        '</div>' +
                                        '<div class="action-btn btn-reject-event" data-event-id="' + event.suKienId + '" title="Từ chối">' +
                                            '<i class="fas fa-times"></i>' +
                                        '</div>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                        '</div>';
                    });
                }
                $('#pending-events-list').html(html);
            }).fail(function() {
                showError('Lỗi tải sự kiện chờ duyệt');
            });
        }

        function displayRecentEvents(events) {
            let html = '';
            
            if (events.length == 0) {
                html = '<div class="no-events" style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--gray);">' +
                    '<i class="fas fa-calendar-times" style="font-size: 48px; margin-bottom: 15px;"></i>' +
                    '<h3>Không có sự kiện gần đây</h3>' +
                    '<p>Hiện tại không có sự kiện nào để hiển thị.</p>' +
                    '</div>';
            } else {
                events.forEach(function(event) {
                    const statusClass = getEventStatusClass(event.trangThai);
                    const statusText = getEventStatusText(event.trangThai);
                    const eventDate = event.thoiGianBatDau ? new Date(event.thoiGianBatDau).toLocaleDateString('vi-VN') : 'N/A';
                    
                    html += '<div class="event-card" data-event-id="' + event.suKienId + '">' +
                        '<div class="event-image">' +
                            '<i class="fas fa-calendar-alt"></i>' +
                        '</div>' +
                        '<div class="event-content">' +
                            '<h4 class="event-title">' + event.tenSuKien + '</h4>' +
                            '<div class="event-meta">' +
                                '<span><i class="far fa-calendar"></i> ' + eventDate + '</span>' +
                                '<span><i class="fas fa-map-marker-alt"></i> ' + event.diaDiem + '</span>' +
                            '</div>' +
                            '<p>' + (event.moTa ? (event.moTa.length > 100 ? event.moTa.substring(0, 100) + '...' : event.moTa) : 'Không có mô tả') + '</p>' +
                            '<div class="event-footer">' +
                                '<span class="status ' + statusClass + '">' + statusText + '</span>' +
                                '<span><i class="fas fa-users"></i> ' + (event.soLuongDaDangKy || 0) + ' người</span>' +
                            '</div>' +
                        '</div>' +
                    '</div>';
                });
            }
            $('#recent-events').html(html);
        }
                
        // Action Functions - Sửa hàm viewUser
        function viewUser(userId) {
            $.get('/admin/api/users/' + userId, function(user) {
                const registrationDate = user.ngayTao ? new Date(user.ngayTao).toLocaleDateString('vi-VN') : 'N/A';
                const statusText = user.trangThai == 'active' ? 'Đang hoạt động' : 'Đã khóa';
                
                let html = '';
                html += '<div style="display: flex; align-items: center; gap: 15px; margin-bottom: 20px;">' +
                    '<div class="user-avatar" style="width: 80px; height: 80px; font-size: 32px;">' +
                        (user.hoTen ? user.hoTen.charAt(0).toUpperCase() : 'U') +
                    '</div>' +
                    '<div>' +
                        '<h4 style="margin-bottom: 5px;">' + user.hoTen + '</h4>' +
                        '<p>' + user.vaiTro + '</p>' +
                    '</div>' +
                '</div>' +
                
                '<div class="form-row">' +
                    '<div class="form-group">' +
                        '<label>Email:</label>' +
                        '<p>' + user.email + '</p>' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label>Số điện thoại:</label>' +
                        '<p>' + (user.soDienThoai || 'N/A') + '</p>' +
                    '</div>' +
                '</div>' +
                
                '<div class="form-group">' +
                    '<label>Địa chỉ:</label>' +
                    '<p>' + (user.diaChi || 'N/A') + '</p>' +
                '</div>' +
                
                '<div class="form-row">' +
                    '<div class="form-group">' +
                        '<label>Ngày đăng ký:</label>' +
                        '<p>' + registrationDate + '</p>' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label>Trạng thái:</label>' +
                        '<p><span class="status ' + (user.trangThai == 'active' ? 'active' : 'inactive') + '">' + statusText + '</span></p>' +
                    '</div>' +
                '</div>' +
                
                '<div class="form-group" style="margin-top: 20px;">' +
                    '<button class="btn btn-primary">' +
                        '<i class="fas fa-edit"></i> Chỉnh sửa' +
                    '</button>' +
                    '<button class="btn ' + (user.trangThai == 'active' ? 'btn-danger' : 'btn-success') + ' btn-toggle-user-status" data-user-id="' + user.nguoiDungId + '" data-is-active="' + (user.trangThai == 'active') + '" style="margin-left: 10px;">' +
                        '<i class="fas ' + (user.trangThai == 'active' ? 'fa-lock' : 'fa-unlock') + '"></i>' +
                        (user.trangThai == 'active' ? ' Khóa' : ' Mở khóa') + ' tài khoản' +
                    '</button>' +
                '</div>';
                
                $('#user-modal-content').html(html);
                $('#user-modal').show();
            }).fail(function() {
                showError('Lỗi tải thông tin người dùng');
            });
        }

        // Action Functions - Sửa hàm viewEvent
        function viewEvent(eventId) {
            $.get('/admin/api/events/' + eventId, function(event) {
                const startDate = event.thoiGianBatDau ? new Date(event.thoiGianBatDau).toLocaleString('vi-VN') : 'N/A';
                const endDate = event.thoiGianKetThuc ? new Date(event.thoiGianKetThuc).toLocaleString('vi-VN') : 'N/A';
                const eventType = event.loaiSuKien == 'CongKhai' ? 'Công khai' : 'Riêng tư';
                const statusClass = getEventStatusClass(event.trangThai);
                const statusText = getEventStatusText(event.trangThai);
                
                let html = '';
                html += '<div style="margin-bottom: 20px;">' +
                    '<h4 style="margin-bottom: 10px;">' + event.tenSuKien + '</h4>' +
                    '<p>' + (event.moTa || 'Không có mô tả') + '</p>' +
                '</div>' +
                
                '<div class="form-row">' +
                    '<div class="form-group">' +
                        '<label>Người tổ chức:</label>' +
                        '<p>' + event.organizerName + '</p>' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label>Địa điểm:</label>' +
                        '<p>' + event.diaDiem + '</p>' +
                    '</div>' +
                '</div>' +
                
                '<div class="form-row">' +
                    '<div class="form-group">' +
                        '<label>Thời gian bắt đầu:</label>' +
                        '<p>' + startDate + '</p>' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label>Thời gian kết thúc:</label>' +
                        '<p>' + endDate + '</p>' +
                    '</div>' +
                '</div>' +
                
                '<div class="form-row">' +
                    '<div class="form-group">' +
                        '<label>Loại sự kiện:</label>' +
                        '<p>' + eventType + '</p>' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label>Trạng thái:</label>' +
                        '<p><span class="status ' + statusClass + '">' + statusText + '</span></p>' +
                    '</div>' +
                '</div>' +
                
                '<div class="form-row">' +
                    '<div class="form-group">' +
                        '<label>Số lượng tối đa:</label>' +
                        '<p>' + event.soLuongToiDa + '</p>' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label>Đã đăng ký:</label>' +
                        '<p>' + event.soLuongDaDangKy + '</p>' +
                    '</div>' +
                '</div>';
                
                // Thêm nút hành động cho modal sự kiện
                if (event.trangThai === 'SapDienRa') {
                    html += '<div class="form-group" style="margin-top: 20px;">' +
                        '<button class="btn btn-success btn-approve-event" data-event-id="' + event.suKienId + '" style="margin-right: 10px;">' +
                            '<i class="fas fa-check"></i> Phê duyệt' +
                        '</button>' +
                        '<button class="btn btn-danger btn-reject-event" data-event-id="' + event.suKienId + '">' +
                            '<i class="fas fa-times"></i> Từ chối' +
                        '</button>' +
                    '</div>';
                } else {
                    html += '<div class="form-group" style="margin-top: 20px;">' +
                        '<button class="btn btn-primary">' +
                            '<i class="fas fa-edit"></i> Chỉnh sửa' +
                        '</button>' +
                        '<button class="btn btn-danger btn-delete-event" data-event-id="' + event.suKienId + '" style="margin-left: 10px;">' +
                            '<i class="fas fa-trash"></i> Xóa sự kiện' +
                        '</button>' +
                    '</div>';
                }
                
                $('#event-modal-content').html(html);
                $('#event-modal').show();
            }).fail(function() {
                showError('Lỗi tải thông tin sự kiện');
            });
        }

        // Thêm event delegation cho các nút trong modal
        $(document).on('click', '.btn-approve-event', function() {
            const eventId = $(this).data('event-id');
            $('#event-modal').hide();
            approveEvent(eventId);
        });

        $(document).on('click', '.btn-reject-event', function() {
            const eventId = $(this).data('event-id');
            $('#event-modal').hide();
            rejectEvent(eventId);
        });

        // Utility Functions - Thêm status class cho các trạng thái còn thiếu
        function getEventStatusClass(status) {
            const classes = {
                'SapDienRa': 'pending',
                'DangDienRa': 'active',
                'DaKetThuc': 'completed',
                'Huy': 'cancelled'
            };
            return classes[status] || 'pending';
        }

        function getEventStatusText(status) {
            const texts = {
                'SapDienRa': 'Sắp diễn ra',
                'DangDienRa': 'Đang diễn ra',
                'DaKetThuc': 'Đã kết thúc',
                'Huy': 'Đã hủy'
            };
            return texts[status] || status;
        }
        
        function toggleUserStatus(userId, isActive) {
            const action = isActive ? 'lock' : 'unlock';
            const confirmMessage = isActive ? 
                'Bạn có chắc chắn muốn khóa tài khoản này?' : 
                'Bạn có chắc chắn muốn mở khóa tài khoản này?';
            
            if (confirm(confirmMessage)) {
                $.post('/admin/api/users/' + userId + '/status', { action: action }, function() {
                    showSuccess(`Đã ${isActive ? 'khóa' : 'mở khóa'} tài khoản thành công`);
                    loadUsers();
                    $('#user-modal').hide();
                }).fail(function() {
                    showError('Lỗi cập nhật trạng thái người dùng');
                });
            }
        }

        function approveEvent(eventId) {
            if (confirm('Bạn có chắc chắn muốn phê duyệt sự kiện này?')) {
                $.post('/admin/api/events/' + eventId + '/approve', function() {
                    showSuccess('Đã phê duyệt sự kiện thành công');
                    loadPendingEvents();
                    loadDashboardData();
                }).fail(function() {
                    showError('Lỗi phê duyệt sự kiện');
                });
            }
        }

        function rejectEvent(eventId) {
            if (confirm('Bạn có chắc chắn muốn từ chối sự kiện này?')) {
                $.post('/admin/api/events/' + eventId + '/reject', function() {
                    showSuccess('Đã từ chối sự kiện thành công');
                    loadPendingEvents();
                    loadDashboardData();
                }).fail(function() {
                    showError('Lỗi từ chối sự kiện');
                });
            }
        }

        function deleteEvent(eventId) {
            if (confirm('Bạn có chắc chắn muốn xóa sự kiện này?')) {
                $.ajax({
                    url: '/admin/api/events/' + eventId,
                    method: 'DELETE',
                    success: function() {
                        showSuccess('Đã xóa sự kiện thành công');
                        loadEvents();
                        $('#event-modal').hide();
                    },
                    error: function() {
                        showError('Lỗi xóa sự kiện');
                    }
                });
            }
        }

        // Utility Functions
        function getEventStatusClass(status) {
            const classes = {
                'SapDienRa': 'pending',
                'DangDienRa': 'approved',
                'DaKetThuc': 'completed',
                'Huy': 'cancelled'
            };
            return classes[status] || 'pending';
        }

        function getEventStatusText(status) {
            const texts = {
                'SapDienRa': 'Sắp diễn ra',
                'DangDienRa': 'Đang diễn ra',
                'DaKetThuc': 'Đã kết thúc',
                'Huy': 'Đã hủy'
            };
            return texts[status] || status;
        }

        function filterTables(searchTerm) {
            // Filter users table
            $('#users-tbody tr').each(function() {
                const text = $(this).text().toLowerCase();
                $(this).toggle(text.includes(searchTerm));
            });

            // Filter events table
            $('#events-tbody tr').each(function() {
                const text = $(this).text().toLowerCase();
                $(this).toggle(text.includes(searchTerm));
            });
        }

        function showSuccess(message) {
            alert('Thành công: ' + message); // Có thể thay bằng toast notification
        }

        function showError(message) {
            alert('Lỗi: ' + message); // Có thể thay bằng toast notification
        }

        // Export and other functions
        function exportUsers() {
            window.open('/admin/api/users/export', '_blank');
        }

        function exportEvents() {
            window.open('/admin/api/events/export', '_blank');
        }

        function downloadReport() {
            window.open('/admin/api/analytics/report', '_blank');
        }

        function saveSuggestionConfig() {
            const algorithm = $('#suggestion-algorithm').val();
            const factors = {
                history: $('#factor-history').is(':checked'),
                participation: $('#factor-participation').is(':checked'),
                preferences: $('#factor-preferences').is(':checked')
            };

            $.ajax({
                url: '/admin/api/suggestions/config',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ algorithm: algorithm, factors: factors }),
                success: function() {
                    showSuccess('Đã lưu cấu hình gợi ý');
                },
                error: function() {
                    showError('Lỗi lưu cấu hình');
                }
            });
        }

        function saveSystemSettings() {
            const systemName = $('#system-name').val();
            const systemDescription = $('#system-description').val();

            $.ajax({
                url: '/admin/api/settings',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ 
                    systemName: systemName, 
                    systemDescription: systemDescription 
                }),
                success: function() {
                    showSuccess('Đã lưu cài đặt hệ thống');
                    },
                error: function() {
                    showError('Lỗi lưu cài đặt');
                }
            });
        }

        function loadAllEvents() {
            // Switch to events tab and load all events
            $('.menu-link[data-target="events"]').click();
        }

        function loadAnalytics() {
            $.get('/admin/api/analytics', function(data) {
                $('#stat-total-users').text(data.totalUsers);
                $('#stat-active-events').text(data.activeEvents);
                $('#stat-pending-events').text(data.pendingEvents);
                $('#stat-avg-participation').text(data.avgParticipation + '%');

                // Phần mới: Render charts từ base64
                renderChart('eventsByStatusChart', data.eventsByStatusChart);
                renderChart('registrationsByEventChart', data.registrationsByEventChart);
                renderChart('registrationsOverTimeChart', data.registrationsOverTimeChart);
            }).fail(function() {
                showError('Lỗi tải dữ liệu thống kê');
            });
        }

        // Function mới: Render chart với fallback
        function renderChart(chartId, base64Data) {
            const imgElem = $('#' + chartId);
            const placeholderElem = $('#' + chartId + 'Placeholder');
            if (base64Data && base64Data.length > 0) {
                imgElem.attr('src', 'data:image/png;base64,' + base64Data);
                imgElem.show();
                placeholderElem.hide();
            } else {
                imgElem.hide();
                placeholderElem.text('Không thể tải biểu đồ (lỗi generation)').show();
            }
        }

    
    </script>
</body>
</html>