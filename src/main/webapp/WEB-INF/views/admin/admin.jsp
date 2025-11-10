<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHub - Quản trị viên</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                        <input type="text" placeholder="Tìm kiếm...">
                    </div>
                    <div class="notification">
                        <i class="fas fa-bell"></i>
                        <div class="notification-badge">5</div>
                    </div>
                    <div class="user-info">
                        <div class="user-avatar">QA</div>
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
                        <h3>1,254</h3>
                        <p>Tổng số người dùng</p>
                    </div>
                    <div class="card">
                        <div class="card-icon success">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <h3>342</h3>
                        <p>Sự kiện đang hoạt động</p>
                    </div>
                    <div class="card">
                        <div class="card-icon warning">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h3>28</h3>
                        <p>Sự kiện chờ duyệt</p>
                    </div>
                    <div class="card">
                        <div class="card-icon danger">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <h3>12</h3>
                        <p>Sự kiện vi phạm</p>
                    </div>
                </div>

                <div class="chart-container">
                    <div class="section-header">
                        <h3 class="section-title">Thống kê hoạt động</h3>
                        <div>
                            <select id="chart-period">
                                <option value="week">Tuần này</option>
                                <option value="month">Tháng này</option>
                                <option value="quarter">Quý này</option>
                                <option value="year">Năm nay</option>
                            </select>
                        </div>
                    </div>
                    <div class="chart-placeholder">
                        Biểu đồ thống kê hoạt động hệ thống
                    </div>
                </div>

                <div class="section-header">
                    <h3 class="section-title">Sự kiện gần đây</h3>
                    <button class="btn btn-outline">
                        <i class="fas fa-eye"></i> Xem tất cả
                    </button>
                </div>

                <div class="events-grid">
                    <div class="event-card">
                        <div class="event-image">
                            <i class="fas fa-music"></i>
                        </div>
                        <div class="event-content">
                            <h4 class="event-title">Lễ hội âm nhạc mùa hè 2023</h4>
                            <div class="event-meta">
                                <span><i class="far fa-calendar"></i> 15/07/2023</span>
                                <span><i class="fas fa-map-marker-alt"></i> Công viên Văn hóa</span>
                            </div>
                            <p>Lễ hội âm nhạc lớn nhất mùa hè với sự tham gia của nhiều nghệ sĩ nổi tiếng.</p>
                            <div class="event-footer">
                                <span class="status approved">Đã duyệt</span>
                                <span><i class="fas fa-users"></i> 150 người</span>
                            </div>
                        </div>
                    </div>

                    <div class="event-card">
                        <div class="event-image">
                            <i class="fas fa-graduation-cap"></i>
                        </div>
                        <div class="event-content">
                            <h4 class="event-title">Hội thảo khởi nghiệp công nghệ</h4>
                            <div class="event-meta">
                                <span><i class="far fa-calendar"></i> 22/07/2023</span>
                                <span><i class="fas fa-map-marker-alt"></i> Trung tâm Hội nghị Quốc gia</span>
                            </div>
                            <p>Hội thảo dành cho các startup và nhà đầu tư trong lĩnh vực công nghệ.</p>
                            <div class="event-footer">
                                <span class="status pending">Chờ duyệt</span>
                                <span><i class="fas fa-users"></i> 80 người</span>
                            </div>
                        </div>
                    </div>

                    <div class="event-card">
                        <div class="event-image">
                            <i class="fas fa-utensils"></i>
                        </div>
                        <div class="event-content">
                            <h4 class="event-title">Lễ hội ẩm thực đường phố</h4>
                            <div class="event-meta">
                                <span><i class="far fa-calendar"></i> 30/07/2023</span>
                                <span><i class="fas fa-map-marker-alt"></i> Phố đi bộ Nguyễn Huệ</span>
                            </div>
                            <p>Trải nghiệm ẩm thực đường phố đa dạng từ khắp các vùng miền Việt Nam.</p>
                            <div class="event-footer">
                                <span class="status approved">Đã duyệt</span>
                                <span><i class="fas fa-users"></i> 200 người</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Users Management Content -->
            <div id="users" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Quản lý người dùng</h3>
                    <button class="btn btn-outline">
                        <i class="fas fa-file-export"></i> Xuất báo cáo
                    </button>
                </div>

                <div class="filter-section">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="user-role">Vai trò</label>
                            <select id="user-role">
                                <option value="">Tất cả vai trò</option>
                                <option value="organizer">Người tổ chức</option>
                                <option value="participant">Người tham gia</option>
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
                        <div class="filter-group">
                            <label for="user-register-date">Ngày đăng ký</label>
                            <select id="user-register-date">
                                <option value="">Tất cả thời gian</option>
                                <option value="week">Tuần này</option>
                                <option value="month">Tháng này</option>
                                <option value="quarter">Quý này</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="user-sort">Sắp xếp</label>
                            <select id="user-sort">
                                <option value="newest">Mới nhất</option>
                                <option value="oldest">Cũ nhất</option>
                                <option value="name">Theo tên</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="table-container">
                    <table>
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
                        <tbody>
                            <tr>
                                <td>Nguyễn Văn Tổ Chức</td>
                                <td>tochuc@example.com</td>
                                <td>0912345678</td>
                                <td>Người tổ chức</td>
                                <td>15/05/2023</td>
                                <td><span class="status active">Đang hoạt động</span></td>
                                <td class="action-buttons">
                                    <div class="action-btn" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </div>
                                    <div class="action-btn" title="Khóa tài khoản">
                                        <i class="fas fa-lock"></i>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Trần Thị Tham Gia</td>
                                <td>thamgia@example.com</td>
                                <td>0923456789</td>
                                <td>Người tham gia</td>
                                <td>20/05/2023</td>
                                <td><span class="status active">Đang hoạt động</span></td>
                                <td class="action-buttons">
                                    <div class="action-btn" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </div>
                                    <div class="action-btn" title="Khóa tài khoản">
                                        <i class="fas fa-lock"></i>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Lê Văn Vi Phạm</td>
                                <td>vipham@example.com</td>
                                <td>0934567890</td>
                                <td>Người tổ chức</td>
                                <td>10/04/2023</td>
                                <td><span class="status inactive">Đã khóa</span></td>
                                <td class="action-buttons">
                                    <div class="action-btn" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </div>
                                    <div class="action-btn" title="Mở khóa tài khoản">
                                        <i class="fas fa-unlock"></i>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Events Management Content -->
            <div id="events" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Quản lý sự kiện</h3>
                    <button class="btn btn-outline">
                        <i class="fas fa-file-export"></i> Xuất báo cáo
                    </button>
                </div>

                <div class="filter-section">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="event-status">Trạng thái</label>
                            <select id="event-status">
                                <option value="">Tất cả trạng thái</option>
                                <option value="approved">Đã duyệt</option>
                                <option value="pending">Chờ duyệt</option>
                                <option value="cancelled">Đã hủy</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="event-type">Loại sự kiện</label>
                            <select id="event-type">
                                <option value="">Tất cả loại</option>
                                <option value="music">Âm nhạc</option>
                                <option value="conference">Hội thảo</option>
                                <option value="food">Ẩm thực</option>
                                <option value="art">Nghệ thuật</option>
                                <option value="sports">Thể thao</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="event-date">Ngày diễn ra</label>
                            <select id="event-date">
                                <option value="">Tất cả ngày</option>
                                <option value="week">Tuần này</option>
                                <option value="month">Tháng này</option>
                                <option value="upcoming">Sắp diễn ra</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="event-sort">Sắp xếp</label>
                            <select id="event-sort">
                                <option value="newest">Mới nhất</option>
                                <option value="oldest">Cũ nhất</option>
                                <option value="popular">Phổ biến</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="table-container">
                    <table>
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
                        <tbody>
                            <tr>
                                <td>Lễ hội âm nhạc mùa hè 2023</td>
                                <td>Nguyễn Văn Tổ Chức</td>
                                <td>15/07/2023</td>
                                <td>Công viên Văn hóa</td>
                                <td>Âm nhạc</td>
                                <td><span class="status approved">Đã duyệt</span></td>
                                <td class="action-buttons">
                                    <div class="action-btn" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </div>
                                    <div class="action-btn" title="Chỉnh sửa">
                                        <i class="fas fa-edit"></i>
                                    </div>
                                    <div class="action-btn" title="Xóa">
                                        <i class="fas fa-trash"></i>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Hội thảo khởi nghiệp công nghệ</td>
                                <td>Lê Văn Vi Phạm</td>
                                <td>22/07/2023</td>
                                <td>Trung tâm Hội nghị Quốc gia</td>
                                <td>Hội thảo</td>
                                <td><span class="status pending">Chờ duyệt</span></td>
                                <td class="action-buttons">
                                    <div class="action-btn" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </div>
                                    <div class="action-btn" title="Phê duyệt">
                                        <i class="fas fa-check"></i>
                                    </div>
                                    <div class="action-btn" title="Từ chối">
                                        <i class="fas fa-times"></i>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Approvals Content -->
            <div id="approvals" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Phê duyệt sự kiện</h3>
                    <div>
                        <span class="status pending" style="font-size: 14px;">28 sự kiện chờ duyệt</span>
                    </div>
                </div>

                <div class="events-grid">
                    <div class="event-card">
                        <div class="event-image">
                            <i class="fas fa-graduation-cap"></i>
                        </div>
                        <div class="event-content">
                            <h4 class="event-title">Hội thảo khởi nghiệp công nghệ</h4>
                            <div class="event-meta">
                                <span><i class="far fa-calendar"></i> 22/07/2023</span>
                                <span><i class="fas fa-map-marker-alt"></i> Trung tâm Hội nghị Quốc gia</span>
                            </div>
                            <p>Hội thảo dành cho các startup và nhà đầu tư trong lĩnh vực công nghệ.</p>
                            <div class="event-footer">
                                <div class="action-buttons">
                                    <div class="action-btn" title="Phê duyệt">
                                        <i class="fas fa-check"></i>
                                    </div>
                                    <div class="action-btn" title="Từ chối">
                                        <i class="fas fa-times"></i>
                                    </div>
                                    <div class="action-btn" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Analytics Content -->
            <div id="analytics" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Thống kê hệ thống</h3>
                    <button class="btn btn-outline">
                        <i class="fas fa-download"></i> Tải báo cáo
                    </button>
                </div>

                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-value">1,254</div>
                        <div class="stat-label">Tổng số người dùng</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">342</div>
                        <div class="stat-label">Sự kiện đang hoạt động</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">28</div>
                        <div class="stat-label">Sự kiện chờ duyệt</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">85%</div>
                        <div class="stat-label">Tỷ lệ tham gia trung bình</div>
                    </div>
                </div>

                <div class="chart-container">
                    <div class="section-header">
                        <h3 class="section-title">Phân tích người dùng</h3>
                        <div>
                            <select id="user-analytics-period">
                                <option value="week">Tuần này</option>
                                <option value="month">Tháng này</option>
                                <option value="quarter">Quý này</option>
                                <option value="year">Năm nay</option>
                            </select>
                        </div>
                    </div>
                    <div class="chart-placeholder">
                        Biểu đồ phân tích người dùng
                    </div>
                </div>
            </div>

            <!-- Suggestions Content -->
            <div id="suggestions" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Quản lý gợi ý sự kiện</h3>
                    <button class="btn btn-primary">
                        <i class="fas fa-cog"></i> Cấu hình thuật toán
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
                    <label for="suggestion-factors">Yếu tố ưu tiên</label>
                    <div style="display: flex; flex-wrap: wrap; gap: 15px; margin-top: 10px;">
                        <label style="display: flex; align-items: center; gap: 5px;">
                            <input type="checkbox" checked> Lịch sử tìm kiếm
                        </label>
                        <label style="display: flex; align-items: center; gap: 5px;">
                            <input type="checkbox" checked> Sự kiện đã tham gia
                        </label>
                        <label style="display: flex; align-items: center; gap: 5px;">
                            <input type="checkbox" checked> Sở thích người dùng
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <button class="btn btn-primary">
                        <i class="fas fa-save"></i> Lưu cấu hình
                    </button>
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
                    <button class="btn btn-primary">
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
                <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 20px;">
                    <div class="user-avatar" style="width: 80px; height: 80px; font-size: 32px;">NT</div>
                    <div>
                        <h4 style="margin-bottom: 5px;">Nguyễn Văn Tổ Chức</h4>
                        <p>Người tổ chức sự kiện</p>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Email:</label>
                        <p>tochuc@example.com</p>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại:</label>
                        <p>0912345678</p>
                    </div>
                </div>
                
                <div class="form-group" style="margin-top: 20px;">
                    <button class="btn btn-primary">
                        <i class="fas fa-edit"></i> Chỉnh sửa
                    </button>
                    <button class="btn btn-danger">
                        <i class="fas fa-lock"></i> Khóa tài khoản
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Navigation functionality - FIXED VERSION
        document.querySelectorAll('.menu-link').forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault(); // Ngăn chặn hành vi mặc định của thẻ <a>
                
                // Remove active class from all links and sections
                document.querySelectorAll('.menu-link').forEach(item => {
                    item.classList.remove('active');
                });
                document.querySelectorAll('.content-section').forEach(section => {
                    section.classList.remove('active');
                });
                
                // Add active class to clicked link
                this.classList.add('active');
                
                // Show corresponding section
                const target = this.getAttribute('data-target');
                const targetSection = document.getElementById(target);
                if (targetSection) {
                    targetSection.classList.add('active');
                }
                
                // Update page title
                const pageTitle = document.getElementById('page-title');
                const pageSubtitle = document.getElementById('page-subtitle');
                
                switch(target) {
                    case 'dashboard':
                        pageTitle.textContent = 'Tổng quan hệ thống';
                        pageSubtitle.textContent = 'Quản lý và giám sát toàn bộ hệ thống EventHub';
                        break;
                    case 'users':
                        pageTitle.textContent = 'Quản lý người dùng';
                        pageSubtitle.textContent = 'Quản lý tài khoản người dùng và phân quyền';
                        break;
                    case 'events':
                        pageTitle.textContent = 'Quản lý sự kiện';
                        pageSubtitle.textContent = 'Quản lý và giám sát tất cả sự kiện';
                        break;
                    case 'approvals':
                        pageTitle.textContent = 'Phê duyệt sự kiện';
                        pageSubtitle.textContent = 'Xem xét và phê duyệt sự kiện mới';
                        break;
                    case 'analytics':
                        pageTitle.textContent = 'Thống kê hệ thống';
                        pageSubtitle.textContent = 'Phân tích và báo cáo hệ thống';
                        break;
                    case 'suggestions':
                        pageTitle.textContent = 'Gợi ý sự kiện';
                        pageSubtitle.textContent = 'Quản lý thuật toán gợi ý sự kiện';
                        break;
                    case 'settings':
                        pageTitle.textContent = 'Cài đặt hệ thống';
                        pageSubtitle.textContent = 'Cấu hình hệ thống và tùy chọn';
                        break;
                }
            });
        });

        // Modal functionality
        const userModal = document.getElementById('user-modal');
        const closeModals = document.querySelectorAll('.close-modal');
        
        // Open user modal when clicking on user rows
        document.querySelectorAll('#users .action-btn .fa-eye').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                userModal.style.display = 'flex';
            });
        });
        
        // Close modals
        closeModals.forEach(closeBtn => {
            closeBtn.addEventListener('click', function() {
                userModal.style.display = 'none';
            });
        });
        
        window.addEventListener('click', function(e) {
            if (e.target === userModal) {
                userModal.style.display = 'none';
            }
        });

        // Search functionality
        const searchInput = document.querySelector('.search-box input');
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const userRows = document.querySelectorAll('#users tbody tr');
            const eventRows = document.querySelectorAll('#events tbody tr');
            
            // Search in users table
            userRows.forEach(row => {
                const name = row.cells[0].textContent.toLowerCase();
                const email = row.cells[1].textContent.toLowerCase();
                
                if (name.includes(searchTerm) || email.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
            
            // Search in events table
            eventRows.forEach(row => {
                const title = row.cells[0].textContent.toLowerCase();
                const organizer = row.cells[1].textContent.toLowerCase();
                
                if (title.includes(searchTerm) || organizer.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });

        // User account actions
        document.querySelectorAll('#users .action-btn .fa-lock').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                const row = this.closest('tr');
                const statusCell = row.querySelector('.status');
                
                if (statusCell.textContent === 'Đang hoạt động') {
                    if (confirm('Bạn có chắc chắn muốn khóa tài khoản này?')) {
                        statusCell.textContent = 'Đã khóa';
                        statusCell.className = 'status inactive';
                        this.className = 'fas fa-unlock';
                        this.parentNode.title = 'Mở khóa tài khoản';
                    }
                } else {
                    if (confirm('Bạn có chắc chắn muốn mở khóa tài khoản này?')) {
                        statusCell.textContent = 'Đang hoạt động';
                        statusCell.className = 'status active';
                        this.className = 'fas fa-lock';
                        this.parentNode.title = 'Khóa tài khoản';
                    }
                }
            });
        });

        // Event approval actions
        document.querySelectorAll('#approvals .action-btn .fa-check').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                const card = this.closest('.event-card');
                if (confirm('Bạn có chắc chắn muốn phê duyệt sự kiện này?')) {
                    card.style.opacity = '0.5';
                    setTimeout(() => {
                        card.remove();
                        // Update pending count
                        const pendingCount = document.querySelector('#approvals .status.pending');
                        if (pendingCount) {
                            const currentCount = parseInt(pendingCount.textContent);
                            pendingCount.textContent = (currentCount - 1) + ' sự kiện chờ duyệt';
                        }
                    }, 500);
                }
            });
        });

        document.querySelectorAll('#approvals .action-btn .fa-times').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                const card = this.closest('.event-card');
                if (confirm('Bạn có chắc chắn muốn từ chối sự kiện này?')) {
                    card.style.opacity = '0.5';
                    setTimeout(() => {
                        card.remove();
                        // Update pending count
                        const pendingCount = document.querySelector('#approvals .status.pending');
                        if (pendingCount) {
                            const currentCount = parseInt(pendingCount.textContent);
                            pendingCount.textContent = (currentCount - 1) + ' sự kiện chờ duyệt';
                        }
                    }, 500);
                }
            });
        });
    </script>
</body>
</html>