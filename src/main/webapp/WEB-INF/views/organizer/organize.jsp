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
            position: relative;
        }

        .notification-bell {
            position: relative;
            cursor: pointer;
            font-size: 20px;
            color: var(--dark);
            padding: 8px;
            border-radius: 50%;
            transition: var(--transition);
        }

        .notification-bell:hover {
            background-color: var(--primary-light);
            color: var(--primary);
        }

        .notification-count {
            position: absolute;
            top: -5px;
            right: -5px;
            background-color: var(--danger);
            color: white;
            font-size: 12px;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
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
            cursor: pointer;
        }

        .user-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            min-width: 200px;
            z-index: 1000;
            display: none;
        }

        .user-dropdown.show {
            display: block;
        }

        .user-dropdown-item {
            padding: 12px 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            transition: var(--transition);
        }

        .user-dropdown-item:hover {
            background-color: var(--primary-light);
        }

        .user-dropdown-item i {
            color: var(--primary);
            width: 20px;
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

        .status.attended {
            background-color: rgba(46, 204, 113, 0.15);
            color: var(--success);
        }

        .status.not-attended {
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
            cursor: pointer;
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
            overflow: hidden;
        }

        .event-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
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

        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 2000;
            pointer-events: none;
        }

        .toast {
            background: #06d6a0;
            color: #fff;
            padding: 12px 20px;
            border-radius: 5px;
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 10000;
            transition: all 0.5s ease;
            opacity: 0;
            transform: translateY(-20px);
            max-width: 300px;
            word-wrap: break-word;
        }

        .detail-section {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
        }

        .detail-section h5 {
            color: var(--primary);
            margin-bottom: 15px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 12px;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 8px 0;
            border-bottom: 1px solid rgba(0,0,0,0.02);
        }

        .detail-item strong {
            color: var(--dark);
            min-width: 140px;
            font-weight: 600;
        }

        .detail-item span {
            color: var(--gray);
            text-align: right;
            flex: 1;
        }

        .detail-content {
            background: var(--primary-light);
            padding: 15px;
            border-radius: 8px;
            line-height: 1.6;
            white-space: pre-wrap;
        }

        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid var(--primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Notification Panel */
        .notification-panel {
            position: absolute;
            top: 100%;
            right: 0;
            width: 400px;
            max-height: 500px;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            z-index: 1001;
            display: none;
            overflow: hidden;
        }

        .notification-panel.show {
            display: flex;
            flex-direction: column;
        }

        .notification-header {
            padding: 15px 20px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .notification-header h4 {
            margin: 0;
            font-size: 16px;
            color: var(--dark);
        }

        .notification-body {
            flex: 1;
            overflow-y: auto;
            max-height: 400px;
        }

        .notification-item {
            padding: 15px 20px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            cursor: pointer;
            transition: var(--transition);
        }

        .notification-item:hover {
            background-color: var(--primary-light);
        }

        .notification-item.unread {
            background-color: rgba(74, 107, 255, 0.05);
        }

        .notification-title {
            font-weight: 600;
            margin-bottom: 5px;
            color: var(--dark);
        }

        .notification-content {
            font-size: 14px;
            color: var(--gray);
            margin-bottom: 5px;
            line-height: 1.4;
        }

        .notification-time {
            font-size: 12px;
            color: #999;
        }

        .notification-footer {
            padding: 15px 20px;
            border-top: 1px solid rgba(0,0,0,0.05);
            text-align: center;
        }

        .notification-footer a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }

        /* Biểu tượng điểm danh */
        .attendance-icon {
            font-size: 14px;
            padding: 4px 8px;
            border-radius: 4px;
            margin-right: 5px;
        }

        .attended-icon {
            background-color: rgba(46, 204, 113, 0.2);
            color: var(--success);
        }

        .not-attended-icon {
            background-color: rgba(231, 76, 60, 0.2);
            color: var(--danger);
        }

        .approve-registration {
            background-color: #28a745;
            color: white;
        }

        .reject-registration {
            background-color: #dc3545;
            color: white;
        }

        .approve-registration:hover {
            background-color: #218838;
        }

        .reject-registration:hover {
            background-color: #c82333;
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
                    <a href="#" class="menu-link" data-target="event-suggestions">
                        <i class="fas fa-lightbulb"></i>
                        <span>Đề xuất sự kiện</span>
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
                    <!-- Thông báo -->
                    <div class="notification-bell" id="notification-bell">
                        <i class="fas fa-bell"></i>
                        <span class="notification-count" id="notification-count">0</span>
                        
                        <!-- Panel thông báo -->
                        <div class="notification-panel" id="notification-panel">
                            <div class="notification-header">
                                <h4>Thông báo</h4>
                                <button class="btn btn-outline btn-sm" id="mark-all-notifications-read">
                                    <i class="fas fa-check-double"></i> Đánh dấu đã đọc
                                </button>
                            </div>
                            <div class="notification-body" id="notification-list">
                                <!-- Thông báo sẽ được tải ở đây -->
                            </div>
                            <div class="notification-footer">
                                <a href="#" id="view-all-notifications">Xem tất cả thông báo</a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="user-avatar" id="user-avatar">
                        <c:out value="${fn:substring(user.hoTen, 0, 1)}${fn:substring(user.hoTen, fn:indexOf(user.hoTen, ' ') + 1, fn:indexOf(user.hoTen, ' ') + 2)}"/>
                    </div>
                    <div class="user-details">
                        <h4 id="user-name"><c:out value="${user.hoTen}"/></h4>
                        <p id="user-role"><c:out value="${user.vaiTro}"/></p>
                    </div>
                    
                    <!-- Dropdown user -->
                    <div class="user-dropdown" id="user-dropdown">
                        <div class="user-dropdown-item" id="logout-link">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Đăng xuất</span>
                        </div>
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
                    <!-- <div class="card">
                        <div class="card-icon danger">
                            <i class="fas fa-exclamation-circle"></i>
                        </div>
                        <h3 id="attention-events"><c:out value="${stats.attentionEvents}"/></h3>
                        <p>Sự kiện cần chú ý</p>
                    </div> -->
                </div>

                <div class="section-header">
                    <h3 class="section-title">Sự kiện sắp diễn ra</h3>
                </div>

                <div class="events-grid" id="upcoming-events-grid">
                    <c:forEach var="event" items="${upcomingEvents}">
                        <div class="event-card" data-event-id="<c:out value="${event.suKienId}"/>">
                            <div class="event-image">
                                <c:choose>
                                    <c:when test="${not empty event.anhBia}">
                                        <img src="<c:out value="${event.anhBia}"/>" alt="<c:out value="${event.tenSuKien}"/>">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-calendar-alt"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="event-content">
                                <h4 class="event-title"><c:out value="${event.tenSuKien}"/></h4>
                                <div class="event-meta">
                                    <span><i class="far fa-calendar"></i> <fmt:formatDate value="${event.thoiGianBatDau}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    <span><i class="fas fa-map-marker-alt"></i> <c:out value="${event.diaDiem}"/></span>
                                </div>
                                <p><c:out value="${fn:substring(event.moTa, 0, 100)}${fn:length(event.moTa) > 100 ? '...' : ''}"/></p>
                                <div class="event-footer">
                                    <span class="status <c:out value="${fn:toLowerCase(event.trangThaiThoigian)}"/>">
                                        <c:choose>
                                            <c:when test="${event.trangThaiThoigian == 'DangDienRa'}">Đang diễn ra</c:when>
                                            <c:when test="${event.trangThaiThoigian == 'DaKetThuc'}">Đã kết thúc</c:when>
                                            <c:when test="${event.trangThaiThoigian == 'SapDienRa'}">Sắp diễn ra</c:when>
                                            <c:otherwise>Không xác định</c:otherwise>
                                        </c:choose>
                                    </span>
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
                                        <span class="status <c:out value='${fn:toLowerCase(event.trangThaiThoigian)}'/>">
                                            <c:choose>
                                                <c:when test="${event.trangThaiThoigian == 'DangDienRa'}">Đang Diễn Ra</c:when>
                                                <c:when test="${event.trangThaiThoigian == 'DaKetThuc'}">Đã Kết Thúc</c:when>
                                                <c:when test="${event.trangThaiThoigian == 'SapDienRa'}">Sắp Diễn Ra</c:when>
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
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- Event Suggestions Content -->
            <div id="event-suggestions" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Quản lý đề xuất sự kiện</h3>
                    <button class="btn btn-outline" id="refresh-suggestions">
                        <i class="fas fa-sync-alt"></i> Làm mới
                    </button>
                </div>

                <!-- Bộ lọc -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="filter-suggestion-type">Loại sự kiện</label>
                        <select id="filter-suggestion-type">
                            <option value="">Tất cả loại</option>
                            <c:forEach var="type" items="${eventTypes}">
                                <option value="<c:out value="${type.loaiSuKienId}"/>"><c:out value="${type.tenLoai}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="filter-suggestion-location">Địa điểm</label>
                        <input type="text" id="filter-suggestion-location" placeholder="Nhập địa điểm">
                    </div>
                    <div class="form-group">
                        <label for="filter-suggestion-guests">Số lượng khách</label>
                        <select id="filter-suggestion-guests">
                            <option value="">Tất cả</option>
                            <option value="0-50">Dưới 50 người</option>
                            <option value="50-100">50-100 người</option>
                            <option value="100-200">100-200 người</option>
                            <option value="200-500">200-500 người</option>
                            <option value="500">Trên 500 người</option>
                        </select>
                    </div>
                </div>
                <div class="table-container">
                    <table id="suggestions-table">
                        <thead>
                            <tr>
                                <th>Tiêu đề</th>
                                <th>Loại sự kiện</th>
                                <th>Địa điểm</th>
                                <th>Thời gian dự kiến</th>
                                <th>Số lượng khách</th>
                                <th>Giá cả mong muốn</th>
                                <th>Người đề xuất</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Dữ liệu sẽ được tải bằng AJAX -->
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Create Event Content -->
            <div id="create-event" class="content-section">
                <div class="section-header">
                    <h3 class="section-title" id="create-event-title">Tạo sự kiện mới</h3>
                </div>

                <form id="event-form" enctype="multipart/form-data">
                    <input type="hidden" id="edit-event-id">
                    
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
                        <small class="form-text" id="current-image-info"></small>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary" id="save-event-btn">
                            <i class="fas fa-save"></i> Lưu sự kiện
                        </button>
                        <button type="reset" class="btn btn-outline" id="reset-event-form">
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
            </div>

            <!-- Participants Content -->
            <div id="participants" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Quản lý người tham gia</h3>
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
                                    <c:out value="${fn:substring(user.hoTen, 0, 1)}${fn:substring(user.hoTen, fn:indexOf(user.hoTen, ' ') + 1, fn:indexOf(user.hoTen, ' ') + 2)}"/>
                                </div>
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

    <!-- Change Password Modal -->
    <div class="modal" id="change-password-modal">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header">
                <h3>Đổi mật khẩu</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="change-password-form" method ="POST" action="javascript:void(0);">
                    <div class="form-group">
                        <label for="change-current-password">Mật khẩu hiện tại *</label>
                        <input type="password" id="change-current-password" name="currentPassword" placeholder="Nhập mật khẩu hiện tại" required>
                        <div class="error-message" id="current-password-error-modal"></div>
                    </div>

                    <div class="form-group">
                        <label for="change-new-password">Mật khẩu mới *</label>
                        <input type="password" id="change-new-password" name="newPassword" placeholder="Nhập mật khẩu mới" required>
                        <div class="error-message" id="new-password-error-modal"></div>
                    </div>

                    <div class="form-group">
                        <label for="change-confirm-password">Xác nhận mật khẩu mới *</label>
                        <input type="password" id="change-confirm-password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                        <div class="error-message" id="confirm-password-error-modal"></div>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary" id="submit-change-password" style="width: 100%;">
                            <i class="fas fa-key"></i> Đổi mật khẩu
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Event Suggestion Detail Modal -->
    <div class="modal" id="suggestion-detail-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Chi tiết đề xuất sự kiện</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body" id="suggestion-detail-body">
                <!-- Nội dung sẽ load bằng AJAX -->
            </div>
        </div>
    </div>

    <!-- Accept/Reject Suggestion Modal -->
    <div class="modal" id="suggestion-action-modal">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header">
                <h3 id="suggestion-action-title">Xử lý đề xuất</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="suggestion-action-form">
                    <input type="hidden" id="action-suggestion-id">
                    <input type="hidden" id="action-type">
                    
                    <div class="form-group" id="accept-fields" style="display: none;">
                        <label for="suggestion-response">Thông báo chấp nhận</label>
                        <textarea id="suggestion-response" placeholder="Thông báo sẽ được gửi đến người đề xuất...">Đề xuất sự kiện của bạn đã được chấp nhận. Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất!</textarea>
                    </div>
                    
                    <div class="form-group" id="reject-fields" style="display: none;">
                        <label for="suggestion-reject-reason">Lý do từ chối</label>
                        <textarea id="suggestion-reject-reason" placeholder="Nhập lý do từ chối..." required></textarea>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-success" id="submit-suggestion-action" style="width: 100%;">
                            <i class="fas fa-check"></i> Xác nhận
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

   <script>
    $(document).ready(function() {
        // Thêm toast container vào body nếu chưa có
        if ($('#toast-container').length == 0) {
            $('body').append('<div class="toast-container" id="toast-container"></div>');
        }

        // Hàm hiển thị modal
        function showModal(modalId) {
            $('#' + modalId).css('display', 'flex');
            $('body').css('overflow', 'hidden');
        }

        // Hàm ẩn modal
        function hideModal(modalId) {
            $('#' + modalId).hide();
            $('body').css('overflow', 'auto');
        }

        // Hàm hiển thị thông báo toast
        function showToast(message, isSuccess = false) {
            const toast = $('<div class="toast"></div>')
                .text(message)
                .css({
                    'background': isSuccess ? '#06d6a0' : '#dc3545',
                    'color': '#fff',
                    'padding': '12px 20px',
                    'border-radius': '5px',
                    'position': 'fixed',
                    'top': '20px',
                    'right': '20px',
                    'z-index': '10000',
                    'transition': 'all 0.5s ease',
                    'opacity': '0',
                    'transform': 'translateY(-20px)',
                    'max-width': '300px',
                    'word-wrap': 'break-word'
                });

            $('#toast-container').append(toast);
            
            setTimeout(() => {
                toast.css({
                    'opacity': '1',
                    'transform': 'translateY(0)'
                });
            }, 100);

            setTimeout(() => {
                toast.css({
                    'opacity': '0',
                    'transform': 'translateY(-20px)'
                });
                setTimeout(() => toast.remove(), 500);
            }, 3000);
        }

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
                    case 'account':
                        pageTitle.textContent = 'Tài khoản';
                        pageSubtitle.textContent = 'Quản lý thông tin cá nhân của bạn';
                        loadAccount();
                        break;
                    case 'event-suggestions':
                        pageTitle.textContent = 'Đề xuất sự kiện';
                        pageSubtitle.textContent = 'Quản lý các đề xuất sự kiện từ người dùng';
                        loadEventSuggestions();
                        break;
                }
            });
        }

        // Toggle user dropdown
        $('#user-avatar').click(function(e) {
            e.stopPropagation();
            $('#user-dropdown').toggleClass('show');
        });

        // Đóng dropdown khi click bên ngoài
        $(document).click(function() {
            $('#user-dropdown').removeClass('show');
            $('#notification-panel').removeClass('show');
        });

        // Toggle notification panel
        $('#notification-bell').click(function(e) {
            e.stopPropagation();
            $('#notification-panel').toggleClass('show');
            loadNotifications();
        });

        // Đăng xuất
        $('#logout-link').click(function() {
            if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                $.post('/organizer/logout', function(response) {
                    if (response.success) {
                        window.location.href = '/login';
                    } else {
                        showToast('Đăng xuất thất bại', false);
                    }
                }).fail(function() {
                    showToast('Lỗi kết nối', false);
                });
            }
        });

        // Load notifications
        function loadNotifications() {
            $.get('/organizer/api/notifications', function(data) {
                var html = '';
                var unreadCount = 0;
                
                if (data && data.length > 0) {
                    for (var i = 0; i < data.length; i++) {
                        var noti = data[i];
                        var isUnread = noti.daDoc == 0;
                        if (isUnread) unreadCount++;
                        
                        html += '<div class="notification-item ' + (isUnread ? 'unread' : '') + '" data-noti-id="' + noti.thongBaoId + '">' +
                                    '<div class="notification-title">' + escapeHtml(noti.tieuDe) + '</div>' +
                                    '<div class="notification-content">' + escapeHtml(noti.noiDung) + '</div>' +
                                    '<div class="notification-time">' + new Date(noti.thoiGian).toLocaleString('vi-VN') + '</div>' +
                                '</div>';
                    }
                } else {
                    html = '<div class="notification-item" style="text-align: center; padding: 20px;">Không có thông báo</div>';
                }
                
                $('#notification-list').html(html);
                $('#notification-count').text(unreadCount);
                
                // Thêm sự kiện click cho từng thông báo
                $('.notification-item').click(function() {
                    var notiId = $(this).data('noti-id');
                    markNotificationAsRead(notiId);
                });
            }).fail(function() {
                showToast('Lỗi tải thông báo', false);
            });
        }

        // Đánh dấu thông báo đã đọc
        function markNotificationAsRead(notiId) {
            $.post('/organizer/api/notifications/mark-as-read', { thongBaoId: notiId }, function(response) {
                if (response.success) {
                    loadNotifications();
                }
            });
        }

        // Đánh dấu tất cả thông báo đã đọc
        $('#mark-all-notifications-read').click(function() {
            $.post('/organizer/api/notifications/mark-all-read', function(response) {
                if (response.success) {
                    showToast('Đã đánh dấu tất cả thông báo là đã đọc', true);
                    loadNotifications();
                }
            });
        });

        // Xem tất cả thông báo
        $('#view-all-notifications').click(function(e) {
            e.preventDefault();
            // Có thể mở một trang riêng hoặc modal lớn hơn
            showToast('Chức năng đang phát triển', false);
        });

        // Load dashboard
        function loadDashboard() {
            $.get('/organizer/api/events/upcoming', function(data) {
                var html = '';
                for (var i = 0; i < data.length; i++) {
                    var event = data[i];
                    html += '<div class="event-card" data-event-id="' + event.suKienId + '">' +
                                '<div class="event-image">' +
                                    (event.anhBia ? 
                                        '<img src="' + event.anhBia + '" alt="' + event.tenSuKien + '">' :
                                        '<i class="fas fa-calendar-alt"></i>') +
                                '</div>' +
                                '<div class="event-content">' +
                                    '<h4 class="event-title">' + event.tenSuKien + '</h4>' +
                                    '<div class="event-meta">' +
                                        '<span><i class="far fa-calendar"></i> ' + new Date(event.thoiGianBatDau).toLocaleString('vi-VN') + '</span>' +
                                        '<span><i class="fas fa-map-marker-alt"></i> ' + event.diaDiem + '</span>' +
                                    '</div>' +
                                    '<p>' + (event.moTa ? (event.moTa.length > 100 ? event.moTa.substring(0, 100) + '...' : event.moTa) : '') + '</p>' +
                                    '<div class="event-footer">' +
                                        '<span class="status ' + event.trangThaiThoigian.toLowerCase() + '">' + 
                                            (event.trangThaiThoigian == 'DangDienRa' ? 'Đang diễn ra' : 
                                             event.trangThaiThoigian == 'DaKetThuc' ? 'Đã kết thúc' : 
                                             event.trangThaiThoigian == 'SapDienRa' ? 'Sắp diễn ra' : 'Không xác định') + 
                                        '</span>' +
                                        '<span><i class="fas fa-users"></i> ' + event.soLuongDaDangKy + ' / ' + event.soLuongToiDa + '</span>' +
                                    '</div>' +
                                '</div>' +
                            '</div>';
                }
                $('#upcoming-events-grid').html(html);
            }).fail(function(xhr, status, error) {
                console.error('Error loading upcoming events:', error);
                showToast('Lỗi tải sự kiện sắp diễn ra: ' + error, false);
            });

            // Load stats
            $.get('/organizer/api/analytics/stats', function(data) {
                $('#active-events').text(data.activeEvents);
                $('#total-participants').text(data.totalParticipants);
                $('#upcoming-events').text(data.upcomingEvents);
                $('#attention-events').text(data.attentionEvents);
            }).fail(function(xhr, status, error) {
                console.error('Error loading stats:', error);
                showToast('Lỗi tải thống kê: ' + error, false);
            });
        }

        // Load events
        function loadEvents() {
            $.get('/organizer/api/events', function(data) {
                var html = '';

                for (var i = 0; i < data.length; i++) {
                    var event = data[i];
                    var trangThaiText = '';
                    switch(event.trangThaiThoigian) {
                        case 'DangDienRa': trangThaiText = 'Đang diễn ra'; break;
                        case 'SapDienRa': trangThaiText = 'Sắp diễn ra'; break;
                        case 'DaKetThuc': trangThaiText = 'Đã kết thúc'; break;
                        default: trangThaiText = 'Không xác định';
                    }

                    html += '<tr data-event-id="' + event.suKienId + '">' +
                                '<td>' + event.tenSuKien + '</td>' +
                                '<td>' + new Date(event.thoiGianBatDau).toLocaleString('vi-VN') + '</td>' +
                                '<td>' + event.diaDiem + '</td>' +
                                '<td><span class="status ' + event.trangThaiThoigian.toLowerCase() + '">' + trangThaiText + '</span></td>' +
                                '<td>' + event.soLuongDaDangKy + ' / ' + event.soLuongToiDa + '</td>' +
                                '<td class="action-buttons">' +
                                    '<div class="action-btn edit-event" data-event-id="' + event.suKienId + '" title="Chỉnh sửa">' +
                                        '<i class="fas fa-edit"></i>' +
                                    '</div>' +
                                    '<div class="action-btn delete-event" data-event-id="' + event.suKienId + '" title="Xóa">' +
                                        '<i class="fas fa-trash"></i>' +
                                    '</div>' +
                                '</td>' +
                            '</tr>';
                }

                $('#events-table tbody').html(html);
            }).fail(function(xhr, status, error) {
                console.error('Error loading events:', error);
                showToast('Lỗi tải danh sách sự kiện: ' + error, false);
            });
        }

        function editEvent(suKienId) {
            if (!suKienId) {
                showToast("ID sự kiện không hợp lệ!", false);
                return;
            }

            $.get('/organizer/api/events/' + suKienId, function(event) {
                if (!event) {
                    showToast("Không tìm thấy sự kiện!", false);
                    return;
                }

                // Điền thông tin vào form
                $('#edit-event-id').val(event.suKienId);
                $('#event-name').val(event.tenSuKien);
                $('#event-type').val(event.loaiSuKienId);
                $('#event-description').val(event.moTa);
                $('#event-start-date').val(formatDateTimeForInput(event.thoiGianBatDau));
                $('#event-end-date').val(formatDateTimeForInput(event.thoiGianKetThuc));
                $('#event-location').val(event.diaDiem);
                $('#event-capacity').val(event.soLuongToiDa);
                $('#event-privacy').val(event.loaiSuKien);

                // Hiển thị thông tin ảnh hiện tại
                if (event.anhBia) {
                    $('#current-image-info').html('<i class="fas fa-info-circle"></i> Ảnh hiện tại: ' + event.anhBia);
                } else {
                    $('#current-image-info').html('<i class="fas fa-info-circle"></i> Chưa có ảnh');
                }

                // Hiển thị và điền mã riêng tư nếu sự kiện là riêng tư
                if (event.loaiSuKien == 'RiengTu') {
                    $('#private-event-id-group').show();
                    $('#private-event-id').val(event.matKhauSuKienRiengTu || '').prop('required', true);
                } else {
                    $('#private-event-id-group').hide();
                    $('#private-event-id').prop('required', false);
                }

                // Cập nhật tiêu đề form
                $('#create-event-title').text('Chỉnh sửa sự kiện');
                $('#save-event-btn').html('<i class="fas fa-save"></i> Cập nhật sự kiện');
                
                // Chuyển đến tab create-event
                document.querySelector('[data-target="create-event"]').click();
            })
            .fail(function(xhr) {
                showToast("Không tải được thông tin sự kiện (mã lỗi " + xhr.status + ")", false);
            });
        }

        function formatDateTimeForInput(dateTimeStr) {
            if (!dateTimeStr) return '';
            var date = new Date(dateTimeStr);
            return date.toISOString().slice(0, 16);
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
                            showToast(response.message, true);
                            loadEvents();
                            loadDashboard();
                        } else {
                            showToast(response.message || 'Lỗi xóa sự kiện', false);
                        }
                    },
                    error: function(xhr, status, error) {
                        showToast('Lỗi xóa sự kiện: ' + error, false);
                    }
                });
            }
        }

        // Attach events for events table
        $('#events-table tbody').on('click', '.action-btn', function() {
            var target = $(this);
            var eventId = target.data('event-id');
            if (target.hasClass('edit-event')) {
                editEvent(eventId);
            } else if (target.hasClass('delete-event')) {
                deleteEvent(eventId);
            }
        });

        // Hiển thị/ẩn trường mã sự kiện riêng tư
        $('#event-privacy').on('change', function() {
            if (this.value == 'RiengTu') {
                $('#private-event-id-group').show();
                $('#private-event-id').prop('required', true);
            } else {
                $('#private-event-id-group').hide();
                $('#private-event-id').prop('required', false);
            }
        });

        // Reset form khi click nút đặt lại
        $('#reset-event-form').on('click', function() {
            $('#edit-event-id').val('');
            $('#create-event-title').text('Tạo sự kiện mới');
            $('#save-event-btn').html('<i class="fas fa-save"></i> Lưu sự kiện');
            $('#current-image-info').html('');
            $('#private-event-id-group').hide();
            $('#private-event-id').prop('required', false);
        });

        // Submit event form (create or edit)
        $('#event-form').on('submit', function(e) {
            e.preventDefault();
            var eventId = $('#edit-event-id').val();
            var isEdit = eventId !== '';
            
            var formData = new FormData();
            var event = {
                suKienId: isEdit ? parseInt(eventId) : null,
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
            if ($('#event-privacy').val() == 'RiengTu') {
                event.matKhauSuKienRiengTu = $('#private-event-id').val();
            }
            
            formData.append('event', JSON.stringify(event));
            var imageFile = $('#event-image')[0].files[0];
            if (imageFile) {
                formData.append('anhBiaFile', imageFile);
            }
            
            // Sửa URL để bao gồm ID khi update
            var url = isEdit ? '/organizer/api/events/update/' + eventId : '/organizer/api/events/create';
            
            $.ajax({
                url: url,
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    if (response.success) {
                        showToast(isEdit ? 'Cập nhật thành công!' : 'Tạo thành công!', true);
                        
                        // Reset form
                        $('#event-form')[0].reset();
                        $('#edit-event-id').val('');
                        $('#create-event-title').text('Tạo sự kiện mới');
                        $('#save-event-btn').html('<i class="fas fa-save"></i> Lưu sự kiện');
                        $('#current-image-info').html('');
                        $('#private-event-id-group').hide();
                        $('#private-event-id').prop('required', false);
                        
                        // Cập nhật danh sách
                        loadEvents();
                        loadDashboard();
                        
                        // Quay lại tab quản lý sự kiện
                        document.querySelector('[data-target="events"]').click();
                    } else {
                        showToast(response.message || 'Lỗi xảy ra!', false);
                    }
                },
                error: function(xhr, status, error) {
    console.error('Error details:', xhr.responseJSON); // Thêm dòng này để debug
    
    if (xhr.status === 401) {
        showToast('Bạn cần đăng nhập để thực hiện thao tác này', false);
        return;
    }
    
    // Kiểm tra nếu backend trả về JSON với message
    if (xhr.responseJSON && xhr.responseJSON.message) {
        showToast(xhr.responseJSON.message, false);
    } 
    // Nếu là lỗi 400 nhưng không có responseJSON
    else if (xhr.status === 400) {
        showToast('Dữ liệu không hợp lệ. Vui lòng kiểm tra lại thông tin nhập vào.', false);
    }
    else {
        showToast('Lỗi xử lý sự kiện: ' + error, false);
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
            }).fail(function(xhr, status, error) {
                console.error('Error loading attendance events:', error);
                showToast('Lỗi tải danh sách sự kiện: ' + error, false);
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
                        var isAttended = reg.trangThaiDiemDanh == 'DaThamGia';
                        var statusClass = isAttended ? 'attended' : 'not-attended';
                        var diemDanhText = isAttended ? 'Đã tham gia' : 'Chưa tham gia';
                        var toggleIcon = isAttended ? 'fa-times' : 'fa-check';
                        var newStatus = !isAttended;
                        
                        html += '<tr data-reg-id="' + reg.dangKyId + '">' +
                                    '<td>' + (reg.user ? reg.user.hoTen : 'N/A') + '</td>' +
                                    '<td>' + (reg.user ? reg.user.email : 'N/A') + '</td>' +
                                    '<td>' + (reg.user ? reg.user.soDienThoai : 'N/A') + '</td>' +
                                    '<td>' + new Date(reg.thoiGianDangKy).toLocaleString('vi-VN') + '</td>' +
                                    '<td><span class="status ' + statusClass + '">' + diemDanhText + '</span></td>' +
                                    '<td class="action-buttons">' +
                                        '<div class="action-btn toggle-attendance" data-reg-id="' + reg.dangKyId + '" data-current-status="' + isAttended + '" title="' + (isAttended ? 'Đánh dấu vắng' : 'Đánh dấu tham gia') + '">' +
                                            '<i class="fas ' + toggleIcon + '"></i>' +
                                        '</div>' +
                                    '</td>' +
                                '</tr>';
                    }
                    $('#attendance-table tbody').html(html);
                }).fail(function(xhr, status, error) {
                    console.error('Error loading attendance data:', error);
                    showToast('Lỗi tải dữ liệu điểm danh: ' + error, false);
                });
            }
        });

        // Attach toggle attendance
        $('#attendance-table tbody').on('click', '.toggle-attendance', function() {
            var target = $(this);
            var dangKyId = target.data('reg-id');
            var currentStatus = target.data('current-status');
            var newStatus = !currentStatus;
            
            toggleAttendance(dangKyId, newStatus);
        });

        function toggleAttendance(dangKyId, newStatus) {
            $.ajax({
                url: '/organizer/api/attendance/update',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ 
                    dangKyId: dangKyId, 
                    trangThaiDiemDanh: newStatus 
                }),
                success: function(response) {
                    if (response.success) {
                        showToast('Cập nhật điểm danh thành công', true);
                        
                        // Cập nhật trực tiếp trên giao diện
                        var row = $('tr[data-reg-id="' + dangKyId + '"]');
                        var statusCell = row.find('td:nth-child(5)');
                        var actionBtn = row.find('.toggle-attendance');
                        
                        if (newStatus) {
                            statusCell.html('<span class="status attended">Đã tham gia</span>');
                            actionBtn.find('i').removeClass('fa-check').addClass('fa-times');
                            actionBtn.attr('title', 'Đánh dấu vắng');
                            actionBtn.data('current-status', true);
                        } else {
                            statusCell.html('<span class="status not-attended">Chưa tham gia</span>');
                            actionBtn.find('i').removeClass('fa-times').addClass('fa-check');
                            actionBtn.attr('title', 'Đánh dấu tham gia');
                            actionBtn.data('current-status', false);
                        }
                    } else {
                        showToast(response.message || 'Lỗi cập nhật điểm danh', false);
                    }
                },
                error: function(xhr, status, error) {
                    showToast('Lỗi cập nhật điểm danh: ' + error, false);
                }
            });
        }

        // Save attendance (if batch)
        $('#save-attendance').on('click', function() {
            showToast('Điểm danh đã lưu!', true);
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
                showToast('Không thể tải danh sách sự kiện: ' + error, false);
            });
        }

        // Load participants for selected event
        $('#filter-event-participants').on('change', function() {
            var suKienId = this.value;
            
            var url = suKienId ? '/organizer/api/registrations?suKienId=' + suKienId : '/organizer/api/registrations';
            
            $.get(url, function(data) {
                var html = '';
                
                if (data && data.length > 0) {
                    for (var i = 0; i < data.length; i++) {
                        var reg = data[i];
                        var hoTen = reg.user ? reg.user.hoTen : 'N/A';
                        var email = reg.user ? reg.user.email : 'N/A';
                        var soDienThoai = reg.user ? reg.user.soDienThoai : 'N/A';
                        var tenSuKien = reg.event ? reg.event.tenSuKien : 'N/A';
                        
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
                                        '</div>';
                                        
                                // Thêm nút phê duyệt nếu đang chờ duyệt
                                if (trangThaiGoc === 'ChoDuyet') {
                                    html += '<div class="action-btn approve-registration" data-reg-id="' + reg.dangKyId + '" title="Phê duyệt">' +
                                                '<i class="fas fa-check"></i>' +
                                            '</div>' +
                                            '<div class="action-btn reject-registration" data-reg-id="' + reg.dangKyId + '" title="Từ chối">' +
                                                '<i class="fas fa-times"></i>' +
                                            '</div>';
                                }
                                // Thêm nút từ chối nếu đã duyệt (để hủy phê duyệt)
                                else if (trangThaiGoc === 'DaDuyet') {
                                    html += '<div class="action-btn reject-registration" data-reg-id="' + reg.dangKyId + '" title="Hủy phê duyệt">' +
                                                '<i class="fas fa-ban"></i>' +
                                            '</div>';
                                }
                                // Thêm nút phê duyệt nếu đã từ chối (để phê duyệt lại)
                                else if (trangThaiGoc === 'TuChoi') {
                                    html += '<div class="action-btn approve-registration" data-reg-id="' + reg.dangKyId + '" title="Phê duyệt lại">' +
                                                '<i class="fas fa-check"></i>' +
                                            '</div>';
                                }
                                
                                html += '</td></tr>';
                    }
                } else {
                    html = '<tr><td colspan="6" style="text-align: center;">Không có dữ liệu người tham gia</td></tr>';
                }
                
                $('#participants-table tbody').html(html);
            }).fail(function(xhr, status, error) {
                console.error('Lỗi khi load participants:', error);
                showToast('Không thể tải danh sách người tham gia: ' + error, false);
                $('#participants-table tbody').html('<tr><td colspan="6" style="text-align: center; color: red;">Lỗi khi tải dữ liệu</td></tr>');
            });
        });


        // Thêm sự kiện cho nút phê duyệt
        $('#participants-table tbody').on('click', '.approve-registration', function() {
            var regId = $(this).data('reg-id');
            updateRegistrationStatus(regId, 'DaDuyet');
        });

        // Thêm sự kiện cho nút từ chối
        $('#participants-table tbody').on('click', '.reject-registration', function() {
            var regId = $(this).data('reg-id');
            updateRegistrationStatus(regId, 'TuChoi');
        });

        // Hàm cập nhật trạng thái
        function updateRegistrationStatus(regId, trangThai) {
            var actionText = trangThai === 'DaDuyet' ? 'phê duyệt' : 'từ chối';
            
            if (!confirm('Bạn có chắc chắn muốn ' + actionText + ' người tham gia này?')) {
                return;
            }
            
            $.ajax({
                url: '/organizer/api/registrations/update-status',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ 
                    dangKyId: regId, 
                    trangThai: trangThai 
                }),
                success: function(response) {
                    if (response.success) {
                        showToast(response.message, true);
                        // Tải lại danh sách
                        $('#filter-event-participants').trigger('change');
                    } else {
                        showToast(response.message || 'Lỗi cập nhật trạng thái', false);
                    }
                },
                error: function(xhr, status, error) {
                    showToast('Lỗi cập nhật trạng thái: ' + error, false);
                }
            });
        }

        // Attach events for participants table
        $('#participants-table tbody').on('click', '.action-btn', function() {
            var target = $(this);
            var suKienId = $('#filter-event-participants').val();
            var regId = target.data('reg-id');
            if (target.hasClass('view-participant-detail')) {
                openParticipantDetailModal(regId, suKienId);
            }
        });

        function loadAccount() {
            $.get('/organizer/api/account', function(user) {
                var names = user.hoTen.split(' ');
                var fullName = (user?.hoTen || '').trim();
                var i = fullName.indexOf(' ');
                $('#first-name').val(i !== -1 ? fullName.substring(0, i) : fullName);
                $('#last-name').val(i !== -1 ? fullName.substring(i + 1) : '');
                $('#user-email').val(user.email);
                $('#user-phone').val(user.soDienThoai);
                $('#user-address').val(user.diaChi);
                var avatarText = user.hoTen.split(' ').map(function(name) {
                    return name[0];
                }).join('');
                $('#account-avatar').text(avatarText);
            }).fail(function(xhr, status, error) {
                console.error('Error loading account:', error);
                showToast('Lỗi tải thông tin tài khoản: ' + error, false);
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
                diaChi: $('#user-address').val()
            };
            $.ajax({
                url: '/organizer/api/account/update',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(user),
                success: function(response) {
                    if (response.success) {
                        showToast(response.message, true);
                        loadAccount();
                    } else {
                        showToast(response.message || 'Lỗi cập nhật thông tin', false);
                    }
                },
                error: function(xhr, status, error) {
                    showToast('Lỗi cập nhật thông tin: ' + error, false);
                }
            });
        });

        // Modal functionality
        $('.close-modal').on('click', function() {
            var modalId = $(this).closest('.modal').attr('id');
            hideModal(modalId);
        });

        $(window).on('click', function(e) {
            if ($(e.target).hasClass('modal')) {
                var modalId = $(e.target).attr('id');
                hideModal(modalId);
            }
        });

        function openEventModal(suKienId) {
            $.get('/organizer/api/events/' + suKienId, function(event) {
                var trangThaiHienThi = '';

                switch (event.trangThaiThoigian) {
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
                                (event.anhBia ? 
                                    '<img src="' + event.anhBia + '" alt="' + event.tenSuKien + '" style="width: 100%; height: 200px; object-fit: cover;">' :
                                    '<div style="height: 200px; background-color: var(--primary-light); display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 40px;">' +
                                        '<i class="fas fa-calendar-alt"></i>' +
                                    '</div>') +
                            '</div>' +
                            '<h4 style="margin-bottom: 15px;">' + event.tenSuKien + '</h4>' +
                            '<div class="event-meta" style="margin-bottom: 15px;">' +
                                '<span><i class="far fa-calendar"></i> ' + new Date(event.thoiGianBatDau).toLocaleString('vi-VN') + '</span>' +
                                '<span><i class="fas fa-map-marker-alt"></i> ' + event.diaDiem + '</span>' +
                            '</div>' +
                            '<p style="margin-bottom: 20px;">' + event.moTa + '</p>' +
                            '<div class="form-row">' +
                                '<div class="form-group">' +
                                    '<label>Trạng thái:</label>' +
                                    '<span class="status ' + event.trangThaiThoigian.toLowerCase() + '">' + trangThaiHienThi + '</span>' +
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
                            '</div>';
                $('#event-modal-body').html(html);
                showModal('event-modal');
            }).fail(function(xhr, status, error) {
                console.error('Error loading event details:', error);
                showToast('Lỗi tải chi tiết sự kiện: ' + error, false);
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
                hideModal('event-modal');
                editEvent(eventId);
            }
        });

        // Open participant detail modal
        function openParticipantDetailModal(regId, suKienId) {
            $.get('/organizer/api/registrations/' + regId, { suKienId: suKienId }, function(reg) {
                var item = reg[0];
                
                // Format giới tính
                var gioiTinhText = item.user.gioiTinh == 'Nam' ? 'Nam' : 
                                item.user.gioiTinh == 'Nu' ? 'Nữ' : 'Không xác định';
                
                // Format trạng thái
                var trangThaiText = '';
                switch(item.trangThai) {
                    case 'ChoDuyet':
                        trangThaiText = 'Chờ duyệt';
                        break;
                    case 'DaDuyet':
                        trangThaiText = 'Đã duyệt';
                        break;
                    case 'TuChoi':
                        trangThaiText = 'Từ chối';
                        break;
                    case 'DaThamGia':
                        trangThaiText = 'Đã tham gia';
                        break;
                    default:
                        trangThaiText = item.trangThai;
                }

                var html = '<div class="participant-detail-content">' +
                            '<div class="participant-header">' +
                                '<div class="participant-avatar" style="width: 60px; height: 60px; border-radius: 50%; background: var(--primary); color: white; display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: bold; margin-bottom: 15px;">' +
                                    (item.user.hoTen ? item.user.hoTen.split(' ').map(n => n[0]).join('').toUpperCase() : 'NN') +
                                '</div>' +
                                '<h4>' + (item.user.hoTen || 'Không có tên') + '</h4>' +
                                '<p class="participant-email" style="color: var(--gray); margin-bottom: 20px;">' + (item.user.email || 'Không có email') + '</p>' +
                            '</div>' +
                            
                            '<div class="participant-info-grid" style="display: grid; gap: 15px;">' +
                                '<div class="info-item">' +
                                    '<strong><i class="fas fa-phone" style="margin-right: 8px; color: var(--primary);"></i>Số điện thoại:</strong>' +
                                    '<span>' + (item.user.soDienThoai || 'Chưa cập nhật') + '</span>' +
                                '</div>' +
                                
                                '<div class="info-item">' +
                                    '<strong><i class="fas fa-map-marker-alt" style="margin-right: 8px; color: var(--primary);"></i>Địa chỉ:</strong>' +
                                    '<span>' + (item.user.diaChi || 'Chưa cập nhật') + '</span>' +
                                '</div>' +
                                
                                '<div class="info-item">' +
                                    '<strong><i class="fas fa-venus-mars" style="margin-right: 8px; color: var(--primary);"></i>Giới tính:</strong>' +
                                    '<span>' + gioiTinhText + '</span>' +
                                '</div>' +
                                
                                '<div class="info-item">' +
                                    '<strong><i class="fas fa-calendar-check" style="margin-right: 8px; color: var(--primary);"></i>Sự kiện:</strong>' +
                                    '<span>' + (item.event.tenSuKien || 'N/A') + '</span>' +
                                '</div>' +
                                
                                '<div class="info-item">' +
                                    '<strong><i class="fas fa-clock" style="margin-right: 8px; color: var(--primary);"></i>Thời gian đăng ký:</strong>' +
                                    '<span>' + new Date(item.thoiGianDangKy).toLocaleString('vi-VN') + '</span>' +
                                '</div>' +
                                
                                '<div class="info-item">' +
                                    '<strong><i class="fas fa-info-circle" style="margin-right: 8px; color: var(--primary);"></i>Trạng thái:</strong>' +
                                    '<span class="status ' + (item.trangThai || '').toLowerCase() + '">' + trangThaiText + '</span>' +
                                '</div>' +
                            '</div>';
                
                // Thêm ghi chú nếu có
                if (item.ghiChu) {
                    html += '<div class="info-item" style="margin-top: 15px; padding-top: 15px; border-top: 1px solid rgba(0,0,0,0.1);">' +
                            '<strong><i class="fas fa-sticky-note" style="margin-right: 8px; color: var(--primary);"></i>Ghi chú:</strong>' +
                            '<p style="margin: 8px 0 0 0; padding: 10px; background: var(--primary-light); border-radius: 5px;">' + item.ghiChu + '</p>' +
                            '</div>';
                }
                
                html += '</div>';

                $('#participant-detail-body').html(html);
                showModal('participant-detail-modal');

            }).fail(function(xhr, status, error) {
                console.error('Error loading participant details:', error);
                showToast('Lỗi tải chi tiết người tham gia: ' + error, false);
            });
        }

        // Mở modal đổi mật khẩu
        $('#change-password').click(function(e) {
            e.preventDefault();
            showModal('change-password-modal');
        });

        // Xử lý form đổi mật khẩu
        $('#change-password-form').submit(function(e) {
            e.preventDefault();
            
            const submitBtn = $('#submit-change-password');
            submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Đang xử lý...');

            const formData = {
                currentPassword: $('#change-current-password').val(),
                newPassword: $('#change-new-password').val(),
                confirmPassword: $('#change-confirm-password').val()
            };

            $.ajax({
                url: '/organizer/api/change-password',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(formData),
                success: function(response) {
                    submitBtn.prop('disabled', false).html('<i class="fas fa-key"></i> Đổi mật khẩu');
                    
                    if (response.success) {
                        showToast(response.message, true);
                        hideModal('change-password-modal');
                        $('#change-password-form')[0].reset();
                    } else {
                        showToast(response.message, false);
                    }
                },
                error: function(xhr) {
                    submitBtn.prop('disabled', false).html('<i class="fas fa-key"></i> Đổi mật khẩu');
                    const errorMsg = xhr.responseJSON?.message || 'Lỗi kết nối đến server';
                    showToast('Đổi mật khẩu thất bại: ' + errorMsg, false);
                }
            });
        });

        // ---------------------- Lọc và hiển thị danh sách đề xuất sự kiện
        // Hàm tải danh sách đề xuất
        function loadEventSuggestions() {
            showLoading('#suggestions-table tbody');
            
            var filters = {
                loaiSuKienId: $('#filter-suggestion-type').val(),
                diaDiem: $('#filter-suggestion-location').val(),
                soLuongKhach: $('#filter-suggestion-guests').val(),
                trangThai: $('#filter-suggestion-status').val()
            };
            
            $.get('/organizer/api/event-suggestions', filters)
            .done(function(data) {
                renderSuggestionsTable(data);
            })
            .fail(function(xhr, status, error) {
                console.error('Error loading event suggestions:', error);
                showToast('Lỗi tải danh sách đề xuất: ' + error, false);
                $('#suggestions-table tbody').html('<tr><td colspan="9" style="text-align: center; color: red;">Lỗi khi tải dữ liệu</td></tr>');
            });
        }

        // Hàm hiển thị bảng đề xuất
        function renderSuggestionsTable(suggestions) {
            var html = '';
            
            if (suggestions && suggestions.length > 0) {
                suggestions.forEach(function(suggestion) {
                    // Chỉ hiển thị những đề xuất có trạng thái phê duyệt
                    if (!suggestion.trangThaiPheDuyet) {
                        return;
                    }
                    
                    var trangThaiMap = {
                        'ChoDuyet': { text: 'Chờ duyệt', class: 'pending' },
                        'DaDuyet': { text: 'Đã duyệt', class: 'approved' },
                        'TuChoi': { text: 'Từ chối', class: 'cancelled' }
                    };
                    
                    var status = trangThaiMap[suggestion.trangThaiPheDuyet] || { text: suggestion.trangThaiPheDuyet, class: 'pending' };
                    var thoiGian = suggestion.thoiGianDuKien ? new Date(suggestion.thoiGianDuKien).toLocaleDateString('vi-VN') : 'Chưa xác định';
                    
                    // Format hiển thị giá cả
                    var giaCaDisplay = 'Thương lượng';
                    if (suggestion.giaCaLong) {
                        if (suggestion.giaCaLong.toLowerCase().includes('triệu') || 
                            suggestion.giaCaLong.toLowerCase().includes('tr') ||
                            suggestion.giaCaLong.match(/\d/)) {
                            giaCaDisplay = suggestion.giaCaLong;
                        } else {
                            giaCaDisplay = suggestion.giaCaLong;
                        }
                    }
                    
                    html += '<tr data-suggestion-id="' + suggestion.dangSuKienId + '">' +
                                '<td>' + escapeHtml(suggestion.tieuDe || 'Không có tiêu đề') + '</td>' +
                                '<td>' + escapeHtml(suggestion.loaiSuKienTen || 'N/A') + '</td>' +
                                '<td>' + escapeHtml(suggestion.diaDiem || 'Chưa xác định') + '</td>' +
                                '<td>' + thoiGian + '</td>' +
                                '<td>' + (suggestion.soLuongKhach || 0) + '</td>' +
                                '<td>' + escapeHtml(giaCaDisplay) + '</td>' +
                                '<td>' + escapeHtml(suggestion.user ? suggestion.user.hoTen : 'N/A') + '</td>' +
                                '<td class="action-buttons">' +
                                    '<div class="action-btn view-suggestion" data-suggestion-id="' + suggestion.dangSuKienId + '" title="Xem chi tiết">' +
                                        '<i class="fas fa-eye"></i>' +
                                    '</div>';
                    
                    // if (suggestion.trangThai === 'ChoDuyet') {
                    //     html += '<div class="action-btn accept-suggestion" data-suggestion-id="' + suggestion.dangSuKienId + '" title="Chấp nhận">' +
                    //                 '<i class="fas fa-check"></i>' +
                    //             '</div>' +
                    //             '<div class="action-btn reject-suggestion" data-suggestion-id="' + suggestion.dangSuKienId + '" title="Từ chối">' +
                    //                 '<i class="fas fa-times"></i>' +
                    //             '</div>';
                    // }

                        html += '<div class="action-btn accept-suggestion" data-suggestion-id="' + suggestion.dangSuKienId + '" title="Chấp nhận">' +
                                    '<i class="fas fa-check"></i>' +
                                '</div>';
                    
                    html += '</td></tr>';
                });
            } else {
                html = '<tr><td colspan="9" style="text-align: center;">Không có đề xuất nào</td></tr>';
            }
            
            $('#suggestions-table tbody').html(html);
        }


        // Hàm mở modal chi tiết đề xuất
        function openSuggestionDetailModal(suggestionId) {
            $.get('/organizer/api/event-suggestions/' + suggestionId)
            .done(function(suggestion) {
                var trangThaiMap = {
                    'ChoDuyet': { text: 'Chờ duyệt', class: 'pending' },
                    'DaDuyet': { text: 'Đã duyệt', class: 'approved' },
                    'TuChoi': { text: 'Từ chối', class: 'cancelled' }
                };
                
                var status = trangThaiMap[suggestion.trangThaiPheDuyet] || { text: suggestion.trangThaiPheDuyet, class: 'pending' };
                var thoiGianDuKien = suggestion.thoiGianDuKien ? new Date(suggestion.thoiGianDuKien).toLocaleString('vi-VN') : 'Chưa xác định';
                var thoiGianTao = suggestion.thoiGianTao ? new Date(suggestion.thoiGianTao).toLocaleString('vi-VN') : 'N/A';
                
                var html = '<div class="suggestion-detail-content">' +
                            '<h4 style="color: var(--primary); margin-bottom: 20px;">' + escapeHtml(suggestion.tieuDe) + '</h4>' +
                            
                            '<div class="detail-section">' +
                                '<h5><i class="fas fa-info-circle"></i> Thông tin chung</h5>' +
                                '<div class="detail-grid">' +
                                    '<div class="detail-item">' +
                                        '<strong>Loại sự kiện:</strong>' +
                                        '<span>' + escapeHtml(suggestion.loaiSuKienTen) + '</span>' +
                                    '</div>' +
                                    '<div class="detail-item">' +
                                        '<strong>Địa điểm:</strong>' +
                                        '<span>' + escapeHtml(suggestion.diaDiem) + '</span>' +
                                    '</div>' +
                                    '<div class="detail-item">' +
                                        '<strong>Thời gian dự kiến:</strong>' +
                                        '<span>' + thoiGianDuKien + '</span>' +
                                    '</div>' +
                                    '<div class="detail-item">' +
                                        '<strong>Số lượng khách:</strong>' +
                                        '<span>' + suggestion.soLuongKhach + ' người</span>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                            
                            '<div class="detail-section">' +
                                '<h5><i class="fas fa-money-bill-wave"></i> Thông tin tài chính</h5>' +
                                '<div class="detail-item">' +
                                    '<strong>Giá cả mong muốn:</strong>' +
                                    '<span>' + escapeHtml(suggestion.giaCaLong || 'Thương lượng') + '</span>' +
                                '</div>' +
                            '</div>' +
                            
                            '<div class="detail-section">' +
                                '<h5><i class="fas fa-file-alt"></i> Mô tả chi tiết</h5>' +
                                '<div class="detail-content">' +
                                    escapeHtml(suggestion.moTaNhuCau || 'Không có mô tả') +
                                '</div>' +
                            '</div>' +
                            
                            '<div class="detail-section">' +
                                '<h5><i class="fas fa-user"></i> Thông tin người đề xuất</h5>' +
                                '<div class="detail-grid">' +
                                    '<div class="detail-item">' +
                                        '<strong>Họ tên:</strong>' +
                                        '<span>' + escapeHtml(suggestion.user.hoTen) + '</span>' +
                                    '</div>' +
                                    '<div class="detail-item">' +
                                        '<strong>Email:</strong>' +
                                        '<span>' + escapeHtml(suggestion.user.email) + '</span>' +
                                    '</div>' +
                                    '<div class="detail-item">' +
                                        '<strong>Số điện thoại:</strong>' +
                                        '<span>' + escapeHtml(suggestion.user.soDienThoai || 'Chưa cập nhật') + '</span>' +
                                    '</div>' +
                                    '<div class="detail-item">' +
                                        '<strong>Thông tin liên hệ:</strong>' +
                                        '<span>' + escapeHtml(suggestion.thongTinLienLac || 'Không có') + '</span>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                            
                            '<div class="detail-section">' +
                                '<h5><i class="fas fa-history"></i> Thông tin hệ thống</h5>' +
                                '<div class="detail-grid">' +
                                    '<div class="detail-item">' +
                                        '<strong>Trạng thái phê duyệt:</strong>' +
                                        '<span class="status ' + status.class + '">' + status.text + '</span>' +
                                    '</div>' +
                                    '<div class="detail-item">' +
                                        '<strong>Thời gian tạo:</strong>' +
                                        '<span>' + thoiGianTao + '</span>' +
                                    '</div>';
                
                if (suggestion.thoiGianPhanHoi) {
                    html += '<div class="detail-item">' +
                                '<strong>Thời gian phản hồi:</strong>' +
                                '<span>' + new Date(suggestion.thoiGianPhanHoi).toLocaleString('vi-VN') + '</span>' +
                            '</div>';
                }
                
                html += '</div></div>';
                
                // Thêm nút hành động nếu đang chờ duyệt
                if (suggestion.trangThaiPheDuyet == 'ChoDuyet') {
                    html += '<div class="action-buttons" style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee; text-align: center;">' +
                                '<button class="btn btn-success accept-suggestion-from-modal" data-suggestion-id="' + suggestion.dangSuKienId + '">' +
                                    '<i class="fas fa-check"></i> Chấp nhận' +
                                '</button>' +
                                '<button class="btn btn-danger reject-suggestion-from-modal" data-suggestion-id="' + suggestion.dangSuKienId + '">' +
                                    '<i class="fas fa-times"></i> Từ chối' +
                                '</button>' +
                            '</div>';
                }
                
                html += '</div>';
                
                $('#suggestion-detail-body').html(html);
                showModal('suggestion-detail-modal');
            })
            .fail(function(xhr, status, error) {
                console.error('Error loading suggestion details:', error);
                showToast('Lỗi tải chi tiết đề xuất: ' + error, false);
            });
        }

        // Hàm mở modal hành động (chấp nhận/từ chối)
        function openSuggestionActionModal(suggestionId, actionType) {
            $('#action-suggestion-id').val(suggestionId);
            $('#action-type').val(actionType);
            
            if (actionType == 'accept') {
                $('#suggestion-action-title').text('Chấp nhận đề xuất');
                $('#accept-fields').show();
                $('#reject-fields').hide();
                $('#suggestion-reject-reason').prop('required', false);
            } else {
                $('#suggestion-action-title').text('Từ chối đề xuất');
                $('#accept-fields').hide();
                $('#reject-fields').show();
                $('#suggestion-reject-reason').prop('required', true);
            }
            
            showModal('suggestion-action-modal');
        }

        // Hàm xử lý hành động đề xuất
        function processSuggestionAction() {
            var suggestionId = $('#action-suggestion-id').val();
            var actionType = $('#action-type').val();
            var responseMessage = actionType == 'accept' ? 
                $('#suggestion-response').val() : 
                $('#suggestion-reject-reason').val();
            
            var requestData = {
                dangSuKienId: suggestionId,
                action: actionType,
                message: responseMessage
            };
            
            $('#submit-suggestion-action').prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Đang xử lý...');
            
            $.ajax({
                url: '/organizer/api/event-suggestions/process',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(requestData),
                success: function(response) {
                    $('#submit-suggestion-action').prop('disabled', false).html('<i class="fas fa-check"></i> Xác nhận');
                    
                    if (response.success) {
                        showToast(response.message, true);
                        hideModal('suggestion-action-modal');
                        hideModal('suggestion-detail-modal');
                        loadEventSuggestions();
                        
                        // Reset form
                        $('#suggestion-action-form')[0].reset();
                    } else {
                        showToast(response.message, false);
                    }
                },
                error: function(xhr, status, error) {
                    $('#submit-suggestion-action').prop('disabled', false).html('<i class="fas fa-check"></i> Xác nhận');
                    showToast('Lỗi xử lý đề xuất: ' + error, false);
                }
            });
        }

        // Hàm hiển thị loading
        function showLoading(selector) {
            $(selector).html(
                '<tr>' +
                    '<td colspan="9" style="text-align: center; padding: 40px;">' +
                        '<div class="loading-spinner" style="display: inline-block; width: 30px; height: 30px; border: 3px solid #f3f3f3; border-top: 3px solid var(--primary); border-radius: 50%; animation: spin 1s linear infinite;"></div>' +
                        '<p style="margin-top: 10px; color: var(--gray);">Đang tải dữ liệu...</p>' +
                    '</td>' +
                '</tr>'
            );
        }

        // Escape HTML để tránh XSS
        function escapeHtml(unsafe) {
            if (unsafe == null) return '';
            return unsafe
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#039;");
        }

        // Event Handlers cho tính năng đề xuất sự kiện
        $(document).ready(function() {
            // Refresh suggestions
            $('#refresh-suggestions').on('click', function() {
                loadEventSuggestions();
            });

            // Lọc theo các tiêu chí (bao gồm cả trạng thái phê duyệt)
            $('#filter-suggestion-type, #filter-suggestion-location, #filter-suggestion-guests, #filter-suggestion-status').on('change', function() {
                loadEventSuggestions();
            });

            // Event handlers cho bảng đề xuất
            $('#suggestions-table tbody').on('click', '.action-btn', function() {
                var target = $(this);
                var suggestionId = target.data('suggestion-id');
                
                if (target.hasClass('view-suggestion')) {
                    openSuggestionDetailModal(suggestionId);
                } else if (target.hasClass('accept-suggestion')) {
                    openSuggestionActionModal(suggestionId, 'accept');
                } else if (target.hasClass('reject-suggestion')) {
                    openSuggestionActionModal(suggestionId, 'reject');
                }
            });

            // Event handlers từ modal chi tiết
            $('#suggestion-detail-body').on('click', '.accept-suggestion-from-modal, .reject-suggestion-from-modal', function() {
                var target = $(this);
                var suggestionId = target.data('suggestion-id');
                var actionType = target.hasClass('accept-suggestion-from-modal') ? 'accept' : 'reject';
                
                hideModal('suggestion-detail-modal');
                openSuggestionActionModal(suggestionId, actionType);
            });

            // Submit form hành động
            $('#suggestion-action-form').on('submit', function(e) {
                e.preventDefault();
                processSuggestionAction();
            });
        });

        // Create event button
        document.getElementById('create-event-btn').addEventListener('click', function() {
            document.querySelector('[data-target="create-event"]').click();
        });

        // Initial load
        loadDashboard();
        loadNotifications();
    });
    </script>
</body>
</html>