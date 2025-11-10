<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHub - Người tham gia sự kiện</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4CAF50;
            --primary-light: #E8F5E9;
            --secondary: #FF9800;
            --success: #4CAF50;
            --warning: #FFC107;
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
            background-color: #f5f9f5;
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
            background: linear-gradient(180deg, var(--primary) 0%, #43A047 100%);
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
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
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
            background-color: rgba(255, 193, 7, 0.15);
            color: var(--warning);
        }

        .card-icon.secondary {
            background-color: rgba(255, 152, 0, 0.15);
            color: var(--secondary);
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
            background-color: #43A047;
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
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
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

        /* Notification List */
        .notification-list {
            list-style: none;
        }

        .notification-item {
            padding: 15px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            display: flex;
            align-items: flex-start;
            gap: 15px;
        }

        .notification-item:last-child {
            border-bottom: none;
        }

        .notification-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 16px;
            flex-shrink: 0;
        }

        .notification-icon.info {
            background-color: var(--primary);
        }

        .notification-icon.warning {
            background-color: var(--warning);
        }

        .notification-icon.success {
            background-color: var(--success);
        }

        .notification-content {
            flex: 1;
        }

        .notification-title {
            font-weight: 600;
            margin-bottom: 5px;
        }

        .notification-time {
            font-size: 12px;
            color: var(--gray);
        }

        .notification-unread {
            background-color: rgba(76, 175, 80, 0.05);
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
                        <span>Trang chủ</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="events">
                        <i class="fas fa-calendar-week"></i>
                        <span>Sự kiện</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="myEvents">
                        <i class="fas fa-ticket-alt"></i>
                        <span>Sự kiện của tôi</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="notifications">
                        <i class="fas fa-bell"></i>
                        <span>Thông báo</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="suggestions">
                        <i class="fas fa-lightbulb"></i>
                        <span>Đề xuất sự kiện</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" data-target="history">
                        <i class="fas fa-history"></i>
                        <span>Lịch sử hoạt động</span>
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
                    <h2 id="page-title">Trang chủ</h2>
                    <p id="page-subtitle">Khám phá các sự kiện thú vị</p>
                </div>
                <div class="header-actions">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="search-input" placeholder="Tìm kiếm sự kiện...">
                    </div>
                    <div class="notification">
                        <i class="fas fa-bell"></i>
                        <div class="notification-badge" id="notification-count">
                            <c:out value="${unreadNotificationCount}" default="0"/>
                        </div>
                    </div>
                    <div class="user-info">
                        <div class="user-avatar" id="user-avatar">
                            <c:if test="${not empty user.hoTen}">
                                <c:out value="${fn:substring(user.hoTen, 0, 1)}${fn:substring(user.hoTen, fn:indexOf(user.hoTen, ' ') + 1, fn:indexOf(user.hoTen, ' ') + 2)}"/>
                            </c:if>
                        </div>
                        <div class="user-details">
                            <h4 id="user-name"><c:out value="${user.hoTen}"/></h4>
                            <p id="user-role">Người tham gia</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div id="dashboard" class="content-section active">
                <div class="dashboard-cards">
                    <div class="card">
                        <div class="card-icon primary">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <h3 id="events-attended"><c:out value="${stats.eventsAttended}"/></h3>
                        <p>Sự kiện đã tham gia</p>
                    </div>
                    <div class="card">
                        <div class="card-icon success">
                            <i class="fas fa-ticket-alt"></i>
                        </div>
                        <h3 id="upcoming-events"><c:out value="${stats.upcomingEvents}"/></h3>
                        <p>Sự kiện sắp tới</p>
                    </div>
                    <div class="card">
                        <div class="card-icon warning">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h3 id="pending-events"><c:out value="${stats.pendingEvents}"/></h3>
                        <p>Sự kiện đang chờ</p>
                    </div>
                    <div class="card">
                        <div class="card-icon secondary">
                            <i class="fas fa-star"></i>
                        </div>
                        <h3 id="suggestions-sent"><c:out value="${stats.suggestionsSent}"/></h3>
                        <p>Sự kiện đã đề xuất</p>
                    </div>
                </div>

                <div class="section-header">
                    <h3 class="section-title">Sự kiện nổi bật</h3>
                    <button class="btn btn-outline" id="view-all-featured">
                        <i class="fas fa-eye"></i> Xem tất cả
                    </button>
                </div>

                <div class="events-grid" id="featured-events-grid">
                    <c:forEach var="event" items="${featuredEvents}">
                        <div class="event-card" data-event-id="${event.suKienId}">
                            <div class="event-image">
                                <img src="<c:out value='${not empty event.anhBia ? event.anhBia : "/default-image.jpg"}'/>" 
                                     alt="<c:out value='${event.tenSuKien}'/>">
                            </div>
                            <div class="event-content">
                                <h4 class="event-title"><c:out value="${event.tenSuKien}"/></h4>
                                <div class="event-meta">
                                    <span><i class="far fa-calendar"></i> 
                                        <!--<fmt:formatDate value="${event.thoiGianBatDau}" pattern="dd/MM/yyyy HH:mm"/>-->
                                    </span>
                                    <span><i class="fas fa-map-marker-alt"></i> <c:out value="${event.diaDiem}"/></span>
                                </div>
                                <p><c:out value="${event.moTa}"/></p>
                                <div class="event-footer">
                                    <span class="status ${fn:toLowerCase(event.trangThai)}">
                                        <c:out value="${event.trangThai}"/>
                                    </span>
                                    <span><i class="fas fa-users"></i> 
                                        <c:out value="${event.soLuongDaDangKy}"/>/<c:out value="${event.soLuongToiDa}"/>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Events Content -->
            <div id="events" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Tất cả sự kiện</h3>
                </div>

                <div class="filter-section">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="eventType">Loại sự kiện</label>
                            <select id="eventType">
                                <option value="">Tất cả loại</option>
                                <c:forEach var="type" items="${eventTypes}">
                                    <option value="${type.loaiSuKienId}"><c:out value="${type.tenLoai}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="eventDate">Ngày diễn ra</label>
                            <select id="eventDate">
                                <option value="">Tất cả ngày</option>
                                <option value="week">Tuần này</option>
                                <option value="month">Tháng này</option>
                                <option value="upcoming">Sắp diễn ra</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="eventLocation">Địa điểm</label>
                            <select id="eventLocation">
                                <option value="">Tất cả địa điểm</option>
                                <option value="hanoi">Hà Nội</option>
                                <option value="hcm">TP.HCM</option>
                                <option value="danang">Đà Nẵng</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="eventSort">Sắp xếp</label>
                            <select id="eventSort">
                                <option value="newest">Mới nhất</option>
                                <option value="popular">Phổ biến</option>
                                <option value="upcoming">Sắp diễn ra</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="events-grid" id="all-events-grid">
                    <c:forEach var="event" items="${allEvents}">
                        <div class="event-card" data-event-id="${event.suKienId}">
                            <div class="event-image">
                                <img src="<c:out value='${not empty event.anhBia ? event.anhBia : "/default-image.jpg"}'/>" 
                                     alt="<c:out value='${event.tenSuKien}'/>">
                            </div>
                            <div class="event-content">
                                <h4 class="event-title"><c:out value="${event.tenSuKien}"/></h4>
                                <div class="event-meta">
                                    <span><i class="far fa-calendar"></i> 
                                        <!--<fmt:formatDate value="${event.thoiGianBatDau}" pattern="dd/MM/yyyy HH:mm"/>-->
                                    </span>
                                    <span><i class="fas fa-map-marker-alt"></i> <c:out value="${event.diaDiem}"/></span>
                                </div>
                                <p><c:out value="${event.moTa}"/></p>
                                <div class="event-footer">
                                    <button class="btn btn-primary btn-sm btn-join-event" 
                                            data-event-id="${event.suKienId}" 
                                            data-event-name="<c:out value='${event.tenSuKien}'/>">
                                        <i class="fas fa-plus"></i> Tham gia
                                    </button>
                                    <span><i class="fas fa-users"></i> 
                                        <c:out value="${event.soLuongDaDangKy}"/>/<c:out value="${event.soLuongToiDa}"/>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- My Events Content -->
            <div id="myEvents" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Sự kiện của tôi</h3>
                </div>

                <div class="table-container">
                    <table id="my-events-table">
                        <thead>
                            <tr>
                                <th>Tên sự kiện</th>
                                <th>Ngày diễn ra</th>
                                <th>Địa điểm</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="reg" items="${myEvents}">
                                <tr>
                                    <td><c:out value="${reg.suKien.tenSuKien}"/></td>
                                    <td>
                                        <fmt:formatDate value="${reg.suKien.thoiGianBatDau}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td><c:out value="${reg.suKien.diaDiem}"/></td>
                                    <td>
                                        <span class="status ${fn:toLowerCase(reg.trangThai)}">
                                            <c:out value="${reg.trangThai}"/>
                                        </span>
                                    </td>
                                    <td class="action-buttons">
                                        <div class="action-btn btn-view-event" 
                                            data-event-id="${reg.suKien.suKienId}" 
                                            title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </div>
                                        <c:if test="${reg.trangThai != 'DaDuyet'}">
                                            <div class="action-btn btn-cancel-registration" 
                                                data-registration-id="${reg.dangKyId}" 
                                                title="Hủy đăng ký">
                                                <i class="fas fa-times"></i>
                                            </div>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Notifications Content -->
            <div id="notifications" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Thông báo</h3>
                    <button class="btn btn-outline" id="mark-all-read">
                        <i class="fas fa-check-double"></i> Đánh dấu đã đọc tất cả
                    </button>
                </div>

                <ul class="notification-list" id="notification-list">
                    <c:forEach var="notification" items="${notifications}">
                        <li class="notification-item ${not notification.daDoc ? 'notification-unread' : ''}" 
                            data-notification-id="${notification.thongBaoId}">
                            <div class="notification-icon info">
                                <i class="fas fa-info-circle"></i>
                            </div>
                            <div class="notification-content">
                                <div class="notification-title">Tiêu đề: </div>
                                <p><c:out value="${notification.noiDung}"/></p>
                                <div class="notification-time">
                                    <!--<fmt:formatDate value="${notification.thoiGian}" pattern="dd/MM/yyyy HH:mm"/>-->
                                </div>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <!-- Suggestions Content -->
            <div id="suggestions" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Đề xuất sự kiện</h3>
                </div>

                <form id="suggestion-form">
                    <div class="form-group">
                        <label for="suggestion-title">Tiêu đề sự kiện mong muốn *</label>
                        <input type="text" id="suggestion-title" placeholder="Ví dụ: Workshop nhiếp ảnh cơ bản" required>
                    </div>

                    <div class="form-group">
                        <label for="suggestion-description">Mô tả chi tiết *</label>
                        <textarea id="suggestion-description" placeholder="Mô tả chi tiết về sự kiện bạn mong muốn..." required></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="suggestion-type">Loại sự kiện *</label>
                            <select id="suggestion-type" required>
                                <option value="">Chọn loại sự kiện</option>
                                <c:forEach var="type" items="${eventTypes}">
                                    <option value="${type.loaiSuKienId}"><!--<c:out value="${type.tenLoai}"/>--></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="suggestion-location">Địa điểm mong muốn</label>
                            <input type="text" id="suggestion-location" placeholder="Thành phố, địa điểm cụ thể">
                        </div>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary" id="submit-suggestion">
                            <i class="fas fa-paper-plane"></i> Gửi đề xuất
                        </button>
                        <button type="reset" class="btn btn-outline" id="reset-suggestion">
                            <i class="fas fa-redo"></i> Đặt lại
                        </button>
                    </div>
                </form>

                <div class="section-header" style="margin-top: 40px;">
                    <h3 class="section-title">Đề xuất đã gửi</h3>
                </div>

                <div class="table-container">
                    <table id="suggestions-table">
                        <thead>
                            <tr>
                                <th>Tiêu đề</th>
                                <th>Loại sự kiện</th>
                                <th>Ngày gửi</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="suggestion" items="${suggestions}">
                                <tr>
                                    <td><c:out value="${suggestion.moTa}"/></td>
                                    <td><c:out value="${suggestion.loaiSuKienId}"/></td>
                                    <td>
                                        <!--<fmt:formatDate value="${suggestion.thoiGianTao}" pattern="dd/MM/yyyy HH:mm"/>-->
                                    </td>
                                    <td>
                                        <span class="status ${fn:toLowerCase(suggestion.trangThai)}">
                                            <c:out value="${suggestion.trangThai}"/>
                                        </span>
                                    </td>
                                    <td class="action-buttons">
                                        <div class="action-btn" title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- History Content -->
            <div id="history" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Lịch sử hoạt động</h3>
                </div>

                <div class="table-container">
                    <table id="history-table">
                        <thead>
                            <tr>
                                <th>Hoạt động</th>
                                <th>Chi tiết</th>
                                <th>Thời gian</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="history" items="${histories}">
                                <tr>
                                    <td><c:out value="${history.loaiHoatDong}"/></td>
                                    <td><c:out value="${history.chiTiet}"/></td>
                                    <td>
                                        <!--<fmt:formatDate value="${history.thoiGian}" pattern="dd/MM/yyyy HH:mm"/>-->
                                    </td>
                                </tr>
                            </c:forEach>
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
                                    <c:if test="${not empty user.hoTen}">
                                        <c:out value="${fn:substring(user.hoTen, 0, 1)}${fn:substring(user.hoTen, fn:indexOf(user.hoTen, ' ') + 1, fn:indexOf(user.hoTen, ' ') + 2)}"/>
                                    </c:if>
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
                            <input type="text" id="first-name" value="${fn:split(user.hoTen, ' ')[0]}" required>
                        </div>
                        <div class="form-group">
                            <label for="last-name">Tên *</label>
                            <input type="text" id="last-name" value="${fn:split(user.hoTen, ' ')[1]}" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="user-email">Email *</label>
                            <input type="email" id="user-email" value="<c:out value='${user.email}'/>" required>
                        </div>
                        <div class="form-group">
                            <label for="user-phone">Số điện thoại *</label>
                            <input type="tel" id="user-phone" value="<c:out value='${user.soDienThoai}'/>" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="user-address">Địa chỉ</label>
                        <input type="text" id="user-address" value="<c:out value='${user.diaChi}'/>">
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary" id="save-account">
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
                <!-- Nội dung sẽ được load bằng AJAX -->
            </div>
        </div>
    </div>

    <!-- Registration Modal -->
    <div class="modal" id="registration-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Đăng ký tham gia sự kiện</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <h4 id="modal-event-title"></h4>
                
                <form id="registration-form">
                    <div class="form-group">
                        <label for="reg-note">Ghi chú cho người tổ chức (tùy chọn)</label>
                        <textarea id="reg-note" placeholder="Nhập ghi chú nếu có..."></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="reg-guests">Số lượng khách đi cùng</label>
                        <select id="reg-guests">
                            <option value="0">0</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary" style="width: 100%;" id="submit-registration">
                            <i class="fas fa-paper-plane"></i> Gửi đăng ký
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            // Navigation functionality
            $('.menu-link').click(function(e) {
                e.preventDefault();
                
                $('.menu-link').removeClass('active');
                $('.content-section').removeClass('active');
                
                $(this).addClass('active');
                
                const target = $(this).data('target');
                $('#' + target).addClass('active');
                
                const pageTitle = $('#page-title');
                const pageSubtitle = $('#page-subtitle');
                
                switch(target) {
                    case 'dashboard':
                        pageTitle.text('Trang chủ');
                        pageSubtitle.text('Khám phá các sự kiện thú vị');
                        break;
                    case 'events':
                        pageTitle.text('Sự kiện');
                        pageSubtitle.text('Tìm kiếm và đăng ký sự kiện');
                        break;
                    case 'myEvents':
                        pageTitle.text('Sự kiện của tôi');
                        pageSubtitle.text('Quản lý sự kiện đã đăng ký');
                        break;
                    case 'notifications':
                        pageTitle.text('Thông báo');
                        pageSubtitle.text('Cập nhật mới nhất từ hệ thống');
                        break;
                    case 'suggestions':
                        pageTitle.text('Đề xuất sự kiện');
                        pageSubtitle.text('Gửi đề xuất sự kiện mong muốn');
                        break;
                    case 'history':
                        pageTitle.text('Lịch sử hoạt động');
                        pageSubtitle.text('Xem lại các hoạt động của bạn');
                        break;
                    case 'account':
                        pageTitle.text('Tài khoản');
                        pageSubtitle.text('Quản lý thông tin cá nhân');
                        break;
                }
            });           
            

            // Submit suggestion form
            $('#submit-suggestion').click(function(e) {
                e.preventDefault();
                const suggestion = {
                    moTaNhuCau: $('#suggestion-title').val() + ": " + $('#suggestion-description').val(),
                    loaiSuKienId: $('#suggestion-type').val(),
                    diaDiem: $('#suggestion-location').val()
                };
                $.ajax({
                    url: '/participant/api/suggestions',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(suggestion),
                    success: function(response) {
                        if (response.success) {
                            alert(response.message);
                            location.reload();
                        }
                    }
                });
            });
            /*
            // Save account form
            $('#save-account').click(function(e) {
                e.preventDefault();
                const user = {
                    nguoiDungId: ${user.nguoiDungId},
                    hoTen: $('#first-name').val() + ' ' + $('#last-name').val(),
                    email: $('#user-email').val(),
                    soDienThoai: $('#user-phone').val(),
                    diaChi: $('#user-address').val()
                };
                $.ajax({
                    url: '/participant/api/account/update',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(user),
                    success: function(response) {
                        if (response.success) {
                            alert(response.message);
                            location.reload();
                        }
                    }
                });
            });
            */
            // Modal functionality
            $('.close-modal').click(function() {
                $('#event-modal').css('display', 'none');
                $('#registration-modal').css('display', 'none');
            });

            $(window).click(function(e) {
                if (e.target.id === 'event-modal' || e.target.id === 'registration-modal') {
                    $('#event-modal').css('display', 'none');
                    $('#registration-modal').css('display', 'none');
                }
            });

            // Search functionality
            $('#search-input').on('input', function() {
                const searchTerm = $(this).val().toLowerCase();
                $('.event-card').each(function() {
                    const title = $(this).find('.event-title').text().toLowerCase();
                    const description = $(this).find('p').text().toLowerCase();
                    $(this).css('display', (title.includes(searchTerm) || description.includes(searchTerm)) ? 'block' : 'none');
                });
            });

            // Mark all notifications as read
            $('#mark-all-read').click(function() {
                $.post('/participant/api/notifications/mark-all-read', function() {
                    location.reload();
                });
            });

            // Filter events
            $('.filter-section select').change(function() {
                const filters = {
                    type: $('#eventType').val(),
                    date: $('#eventDate').val(),
                    location: $('#eventLocation').val(),
                    sort: $('#eventSort').val()
                };
                
                $.get('/participant/api/events', { ...filters }, function(data) {
                    let html = '';
                    data.forEach(function(event) {
                        html += '<div class="event-card" data-event-id="' + event.suKienId + '">' +
                            '<div class="event-image">' +
                                '<img src="' + (event.anhBia || '/default-image.jpg') + '" alt="' + event.tenSuKien + '">' +
                            '</div>' +
                            '<div class="event-content">' +
                                '<h4 class="event-title">' + event.tenSuKien + '</h4>' +
                                '<div class="event-meta">' +
                                    '<span><i class="far fa-calendar"></i> ' + event.thoiGianBatDau + '</span>' +
                                    '<span><i class="fas fa-map-marker-alt"></i> ' + event.diaDiem + '</span>' +
                                '</div>' +
                                '<p>' + event.moTa + '</p>' +
                                '<div class="event-footer">' +
                                    '<button class="btn btn-primary btn-sm btn-join-event" ' +
                                            'data-event-id="' + event.suKienId + '" ' +
                                            'data-event-name="' + event.tenSuKien + '">' +
                                        '<i class="fas fa-plus"></i> Tham gia' +
                                    '</button>' +
                                    '<span><i class="fas fa-users"></i> ' + (event.soLuongDaDangKy || 0) + '/' + event.soLuongToiDa + '</span>' +
                                '</div>' +
                            '</div>' +
                        '</div>';
                    });
                    $('#all-events-grid').html(html);
                });
            });
        });


        $(document).ready(function() {
    // Xem chi tiết sự kiện (từ cả 2 nơi)
    $(document).on('click', '.btn-view-event', function() {
        const eventId = $(this).data('event-id');
        $.get('/participant/api/events/' + eventId, function(event) {
            const formatDate = (date) => {
                if (!date) return 'Chưa xác định';
                const d = new Date(date);
                return d.toLocaleDateString('vi-VN') + ' ' + d.toLocaleTimeString('vi-VN', {hour: '2-digit', minute: '2-digit'});
            };

            const html = `
                <div class="event-image" style="margin-bottom: 20px;">
                    <img src="${event.anhBia || '/default-image.jpg'}" alt="${event.tenSuKien}" style="width:100%; border-radius:8px;">
                </div>
                <h4 style="margin-bottom: 15px; color: #2c3e50;">${event.tenSuKien}</h4>
                <div class="event-meta" style="margin-bottom: 15px; color: #7f8c8d;">
                    <span><i class="far fa-calendar"></i> ${formatDate(event.thoiGianBatDau)}</span><br>
                    <span><i class="fas fa-map-marker-alt"></i> ${event.diaDiem || 'Chưa xác định'}</span>
                </div>
                <p style="margin-bottom: 20px; line-height: 1.6;">${event.moTa || 'Không có mô tả'}</p>
                <div class="form-row">
                    <div class="form-group">
                        <label>Trạng thái:</label>
                        <span class="status ${event.trangThai.toLowerCase()}">${event.trangThai}</span>
                    </div>
                    <div class="form-group">
                        <label>Số người tham gia:</label>
                        <span>${event.soLuongDaDangKy || 0}/${event.soLuongToiDa || 0}</span>
                    </div>
                </div>
            `;
            $('#event-modal-body').html(html);
            $('#event-modal').css('display', 'flex');
        }).fail(() => alert('Không tải được thông tin sự kiện'));
    });

    // Tham gia sự kiện
    $(document).on('click', '.btn-join-event', function() {
        const eventId = $(this).data('event-id');
        const eventName = $(this).data('event-name');
        $('#modal-event-title').text(eventName);
        $('#registration-form').data('suKienId', eventId);
        $('#registration-modal').css('display', 'flex');
    });

    // Gửi đăng ký
    $('#submit-registration').click(function(e) {
        e.preventDefault();
        const suKienId = $('#registration-form').data('suKienId');
        const payload = {
            suKienId: suKienId,
            ghiChu: $('#reg-note').val(),
            soLuongKhach: $('#reg-guests').val()
        };

        $.ajax({
            url: '/participant/api/register-event',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(payload),
            success: function(res) {
                alert(res.message);
                $('#registration-modal').css('display', 'none');
                location.reload();
            },
            error: function() {
                alert('Đăng ký thất bại');
            }
        });
    });

    // Hủy đăng ký
    $(document).on('click', '.btn-cancel-registration', function() {
        const dangKyId = $(this).data('registration-id');
        if (confirm('Bạn có chắc muốn hủy đăng ký sự kiện này?')) {
            $.ajax({
                url: '/participant/api/cancel-registration',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ dangKyId: dangKyId }),
                success: function(res) {
                    alert(res.message);
                    location.reload();
                }
            });
        }
    });

    // Đóng modal
    $('.close-modal, #event-modal, #registration-modal').click(function(e) {
        if (e.target === this) {
            $(this).css('display', 'none');
        }
    });
});
    </script>
</body>
</html>