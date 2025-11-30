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
            background: linear-gradient(180deg, var(--primary) 0%, #62ea69 100%);
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

        .search-container {
            position: relative;
            width: 300px;
        }

        #search-input {
            width: 100%;
            padding: 10px 40px 10px 36px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }

        #search-suggestions {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 1px solid #ddd;
            border-top: none;
            border-radius: 0 0 8px 8px;
            max-height: 300px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .suggestion-item {
            padding: 12px 16px;
            border-bottom: 1px solid #eee;
            cursor: pointer;
            transition: background 0.2s;
        }

        .suggestion-item:hover {
            background: #f8f9fa;
        }

        .suggestion-item:last-child {
            border-bottom: none;
        }

        .suggestion-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 4px;
        }

        .suggestion-meta {
            font-size: 12px;
            color: #7f8c8d;
        }

        .no-results {
            padding: 16px;
            text-align: center;
            color: #999;
            font-style: italic;
        }

        /* Tùy chỉnh thêm cho phần tìm kiếm */
        .search-container {
            position: relative;
            width: 300px;
        }

        #search-input {
            width: 100%;
            padding: 10px 15px 10px 40px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }

        /* Cải thiện hiển thị ảnh sự kiện */
        .event-image {
            height: 160px;
            overflow: hidden;
        }

        .event-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .event-card:hover .event-image img {
            transform: scale(1.05);
        }

        /* Cải thiện phần thông báo */
        .notification-actions {
            display: flex;
            gap: 8px;
        }

        .btn-mark-read, .btn-delete-notification {
            background: none;
            border: none;
            color: var(--gray);
            cursor: pointer;
            font-size: 14px;
            transition: color 0.2s;
        }

        .btn-mark-read:hover {
            color: var(--success);
        }

        .btn-delete-notification:hover {
            color: var(--danger);
        }

        /* Hiệu ứng cho các phần tử tương tác */
        .menu-link, .action-btn, .btn, .event-card, .card {
            transition: all 0.3s ease;
        }

        .menu-link:hover, .action-btn:hover, .btn:hover {
            transform: translateY(-2px);
        }

        /* Tùy chỉnh responsive */
        @media (max-width: 768px) {
            .search-container {
                width: 100%;
            }
            
            .notification-actions {
                flex-direction: column;
            }
            
            .section-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .section-header > div {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }
        }

        /* CSS cho form đề xuất */
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        /* CSS cho chi tiết đề xuất */
        .suggestion-detail {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .detail-row {
            display: flex;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .detail-row label {
            font-weight: 600;
            min-width: 150px;
            color: var(--dark);
        }

        .detail-row span {
            flex: 1;
            color: var(--gray);
        }

        /* Notification toast */
        .notification-toast {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 8px;
            color: white;
            z-index: 10000;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: var(--box-shadow);
            animation: slideIn 0.3s ease;
        }

        .notification-toast.success {
            background-color: var(--success);
        }

        .notification-toast.error {
            background-color: var(--danger);
        }

        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .detail-row {
                flex-direction: column;
                gap: 5px;
            }
            
            .detail-row label {
                min-width: auto;
            }
        }

        /* Status styles */
        .status.choduyet { background-color: #fff3cd; color: #856404; }
        .status.daduyet { background-color: #d1edff; color: #004085; }
        .status.tuchoi { background-color: #f8d7da; color: #721c24; }

        /* Filter active state */
        .btn-outline.active {
            background-color: var(--primary);
            color: white;
        }

        /* Modal footer */
        .modal-footer {
            padding: 15px 20px;
            border-top: 1px solid var(--border-color);
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        /* Detail rows */
        .detail-row {
            display: flex;
            margin-bottom: 12px;
            padding-bottom: 12px;
            border-bottom: 1px solid #f0f0f0;
        }

        .detail-row label {
            font-weight: 600;
            min-width: 150px;
            color: #555;
        }

        .detail-row span {
            flex: 1;
            color: #333;
        }

        /* Modal chi tiết sự kiện - CẢI THIỆN */
        .event-detail-modal {
            max-width: 700px;
        }

        .event-detail-header {
            padding: 25px 30px 20px;
            border-bottom: 1px solid #f0f0f0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px 12px 0 0;
        }

        .event-detail-header h3 {
            margin: 0;
            font-size: 24px;
            font-weight: 700;
        }

        .event-detail-body {
            padding: 0;
        }

        .event-detail-hero {
            position: relative;
            height: 300px;
            overflow: hidden;
        }

        .event-detail-hero img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .event-detail-hero-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.7));
            padding: 30px;
            color: white;
        }

        .event-detail-title {
            font-size: 28px;
            font-weight: 700;
            margin: 0 0 10px 0;
            line-height: 1.2;
        }

        .event-detail-meta {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 10px;
        }

        .event-detail-meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }

        .event-detail-meta-item i {
            font-size: 16px;
            opacity: 0.9;
        }

        .event-detail-content {
            padding: 30px;
        }

        .event-detail-section {
            margin-bottom: 25px;
        }

        .event-detail-section:last-child {
            margin-bottom: 0;
        }

        .event-detail-section h4 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .event-detail-section h4 i {
            color: var(--primary);
        }

        .event-detail-description {
            line-height: 1.7;
            color: #555;
            font-size: 15px;
            white-space: pre-wrap;
        }

        .event-detail-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .event-detail-stat {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            border-left: 4px solid var(--primary);
        }

        .event-detail-stat-value {
            font-size: 20px;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 5px;
        }

        .event-detail-stat-label {
            font-size: 12px;
            color: var(--gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .event-detail-tags {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .event-detail-tag {
            background: var(--primary-light);
            color: var(--primary);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .event-detail-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            padding: 20px 30px;
            border-top: 1px solid #f0f0f0;
            background: #fafbfc;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .event-detail-modal {
                margin: 20px;
                width: calc(100% - 40px);
            }
            
            .event-detail-hero {
                height: 200px;
            }
            
            .event-detail-title {
                font-size: 22px;
            }
            
            .event-detail-meta {
                flex-direction: column;
                gap: 10px;
            }
            
            .event-detail-content {
                padding: 20px;
            }
            
            .event-detail-stats {
                grid-template-columns: 1fr;
            }
            
            .event-detail-actions {
                flex-direction: column;
            }
            
            .event-detail-actions .btn {
                width: 100%;
                justify-content: center;
            }
        }

        /* Animation cho modal */
        @keyframes modalSlideUp {
            from {
                opacity: 0;
                transform: translateY(50px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .modal-content {
            animation: modalSlideUp 0.3s ease;
        }

        /* CSS cho trường mã sự kiện riêng tư */
        #event-code-group {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid var(--primary);
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        #event-code-group label {
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
            display: block;
            font-size: 15px;
        }

        #event-code {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            background-color: #fff;
            font-family: 'Courier New', monospace;
            font-weight: 600;
            letter-spacing: 1px;
        }

        #event-code:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
            outline: none;
        }

        #event-code-group small {
            display: block;
            margin-top: 8px;
            color: #7f8c8d;
            font-size: 13px;
            line-height: 1.4;
        }

        /* Hiệu ứng khi hiển thị */
        #event-code-group.show {
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Trạng thái lỗi */
        #event-code.error {
            border-color: var(--danger);
            background-color: #fff5f5;
        }

        #event-code.success {
            border-color: var(--success);
            background-color: #f0fff4;
        }

        /* Icon cho trường mã */
        .code-input-container {
            position: relative;
        }

        .code-input-container i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray);
        }

        .code-input-container:focus-within i {
            color: var(--primary);
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
                    <div class="search-container">
                        <i class="fas fa-search" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--gray); z-index: 10;"></i>
                        <input type="text" id="search-input" placeholder="Tìm kiếm sự kiện...">
                        <div id="search-suggestions" class="search-suggestions"></div>
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
                        <h3 id="suggestions-sent"><c:out value="${suggestedEvents.size()}"/></h3>
                        <p>Sự kiện đã đề xuất</p>
                    </div>
                </div>

                <!-- ================== SỰ KIỆN GỢI Ý TỪ MÔ HÌNH ML ================== -->
                <div class="section-header">
                    <h3 class="section-title">Sự kiện gợi ý cho bạn</h3>
                    <!--
                    <button class="btn btn-outline" id="view-all-suggested">
                        <i class="fas fa-eye"></i> Xem tất cả
                    </button>
                    -->
                </div>

                <div class="events-grid" id="suggested-events-grid">
                    <c:choose>
                        <c:when test="${not empty suggestedEvents}">
                            <c:forEach var="event" items="${suggestedEvents}">
                                <div class="event-card" data-event-id="${event.suKienId}">
                                    <div class="event-image">
                                        <c:choose>
                                            <c:when test="${not empty event.anhBia}">
                                                <img src="<c:out value='${event.anhBia}'/>" 
                                                    alt="<c:out value='${event.tenSuKien}'/>" 
                                                    style="width: 100%; height: 100%; object-fit: cover;">
                                            </c:when>
                                            <c:otherwise>
                                                <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background-color: var(--primary-light); color: var(--primary);">
                                                    <i class="fas fa-calendar-alt" style="font-size: 40px;"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="event-content">
                                        <h4 class="event-title"><c:out value="${event.tenSuKien}"/></h4>
                                        <div class="event-meta">
                                            <span><i class="far fa-calendar"></i> 
                                                <fmt:formatDate value="${event.thoiGianBatDau}" pattern="dd/MM/yyyy HH:mm"/>
                                            </span>
                                            <span><i class="fas fa-map-marker-alt"></i> <c:out value="${event.diaDiem}"/></span>
                                        </div>
                                        <p class="event-description"><c:out value="${fn:substring(event.moTa, 0, 100)}${fn:length(event.moTa) > 100 ? '...' : ''}"/></p>
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
                        </c:when>
                        <c:otherwise>
                            <div class="no-events" style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--gray);">
                                <i class="fas fa-lightbulb" style="font-size: 48px; margin-bottom: 15px;"></i>
                                <h3>Chưa có gợi ý sự kiện</h3>
                                <p>Tham gia thêm sự kiện để hệ thống gợi ý phù hợp hơn!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <!-- ================== KẾT THÚC PHẦN GỢI Ý AI ================== -->
            </div>

            <!-- Events Content -->
            <div id="events" class="content-section">
                <div class="section-header">
                    <h3 class="section-title">Tất cả sự kiện</h3>
                </div>

                <div class="filter-section">
                    <div class="filter-header">
                        <h4><i class="fas fa-filter"></i> Bộ lọc nâng cao</h4>
                        <button class="btn btn-outline btn-sm" id="reset-filters">
                            <i class="fas fa-redo"></i> Đặt lại
                        </button>
                    </div>
                    
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="filter-keyword">Từ khóa</label>
                            <input type="text" id="filter-keyword" placeholder="Tìm theo tên, mô tả...">
                        </div>
                        
                        <div class="filter-group">
                            <label for="filter-eventType">Loại sự kiện</label>
                            <select id="filter-eventType">
                                <option value="">Tất cả loại</option>
                                <option value="CongKhai">Công khai</option>
                                <option value="RiengTu">Riêng tư</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label for="filter-category">Danh mục</label>
                            <select id="filter-category">
                                <option value="">Tất cả danh mục</option>
                                <c:forEach var="type" items="${eventTypes}">
                                    <option value="${type.loaiSuKienId}"><c:out value="${type.tenLoai}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label for="filter-status">Trạng thái</label>
                            <select id="filter-status">
                                <option value="">Tất cả trạng thái</option>
                                <option value="SapDienRa">Sắp diễn ra</option>
                                <option value="DangDienRa">Đang diễn ra</option>
                                <option value="DaKetThuc">Đã kết thúc</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="filter-startDate">Từ ngày</label>
                            <input type="date" id="filter-startDate">
                        </div>
                        
                        <div class="filter-group">
                            <label for="filter-endDate">Đến ngày</label>
                            <input type="date" id="filter-endDate">
                        </div>
                        
                        <div class="filter-group">
                            <label for="filter-location">Địa điểm</label>
                            <input type="text" id="filter-location" placeholder="Nhập địa điểm...">
                        </div>
                        
                        <div class="filter-group" style="align-self: flex-end;">
                            <button class="btn btn-primary" id="apply-filters" style="min-width: 120px;">
                                <i class="fas fa-search"></i> Áp dụng
                            </button>
                        </div>
                    </div>
                    
                    <div class="filter-results-info" id="filter-results-info" style="display: none;">
                        <span id="results-count">0</span> kết quả phù hợp
                        <button class="btn-clear-filters" id="clear-filters-text" style="margin-left: 10px;">
                            <i class="fas fa-times"></i> Xóa bộ lọc
                        </button>
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
                            <c:forEach var="registration" items="${myEvents}">
                                <tr>
                                    <td><c:out value="${registration.suKien.tenSuKien}"/></td>
                                    <td>
                                        <fmt:formatDate value="${registration.suKien.thoiGianBatDau}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td><c:out value="${registration.suKien.diaDiem}"/></td>
                                    <td>
                                        <span class="status ${fn:toLowerCase(registration.trangThai)}">
                                            <c:choose>
                                                <c:when test="${registration.trangThai == 'DaDuyet'}">
                                                    Đã duyệt
                                                </c:when>
                                                <c:when test="${registration.trangThai == 'ChoDuyet'}">
                                                    Chờ duyệt
                                                </c:when>
                                                <c:when test="${registration.trangThai == 'TuChoi'}">
                                                    Từ chối
                                                </c:when>
                                                <c:otherwise>
                                                    Không xác định
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td class="action-buttons">
                                        <div class="action-btn btn-view-event" 
                                             data-event-id="${registration.suKienId}" 
                                             title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </div>
                                        <div class="action-btn btn-cancel-registration" 
                                             data-registration-id="${registration.dangKyId}" 
                                             title="Hủy đăng ký">
                                            <i class="fas fa-times"></i>
                                        </div>
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
                    <div>
                        <button class="btn btn-outline" id="filter-unread">
                            <i class="fas fa-filter"></i> Chỉ xem chưa đọc
                        </button>
                        <button class="btn btn-outline" id="mark-all-read">
                            <i class="fas fa-check-double"></i> Đánh dấu đã đọc tất cả
                        </button>
                    </div>
                </div>

                <div class="notification-filters" style="margin-bottom: 20px;">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="notification-type">Loại thông báo</label>
                            <select id="notification-type">
                                <option value="">Tất cả</option>
                                <option value="event">Sự kiện</option>
                                <option value="system">Hệ thống</option>
                                <option value="reminder">Cá nhân</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="notification-date">Thời gian</label>
                            <select id="notification-date">
                                <option value="">Tất cả</option>
                                <option value="today">Hôm nay</option>
                                <option value="week">Tuần này</option>
                                <option value="month">Tháng này</option>
                            </select>
                        </div>
                    </div>
                </div>

                <ul class="notification-list" id="notification-list">
                    <c:choose>
                        <c:when test="${not empty notifications}">
                            <c:forEach var="notification" items="${notifications}">
                                <li class="notification-item ${notification.daDoc.intValue() == 0 ? 'notification-unread' : ''}" 
                                    data-notification-id="${notification.thongBaoId}">
                                    <div class="notification-icon ${notification.loaiThongBao}">
                                        <c:choose>
                                            <c:when test="${notification.loaiThongBao == 'event'}">
                                                <i class="fas fa-calendar-alt"></i>
                                            </c:when>
                                            <c:when test="${notification.loaiThongBao == 'system'}">
                                                <i class="fas fa-cog"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-bell"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="notification-content">
                                        <div class="notification-title"><c:out value="${notification.tieuDe}"/></div>
                                        <p><c:out value="${notification.noiDung}"/></p>
                                        <div class="notification-time">
                                            <fmt:formatDate value="${notification.thoiGian}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </div>
                                    <div class="notification-actions">
                                        <c:if test="${notification.daDoc.intValue() == 0}">
                                            <button class="btn-mark-read" title="Đánh dấu đã đọc">
                                                <i class="fas fa-check"></i>
                                            </button>
                                        </c:if>
                                        <button class="btn-delete-notification" title="Xóa thông báo">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <li class="no-notifications" style="text-align: center; padding: 40px; color: var(--gray);">
                                <i class="fas fa-bell-slash" style="font-size: 48px; margin-bottom: 15px;"></i>
                                <h3>Không có thông báo</h3>
                                <p>Bạn không có thông báo nào mới.</p>
                            </li>
                        </c:otherwise>
                    </c:choose>
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
                        <input type="text" id="suggestion-title" name="tieuDe" placeholder="Ví dụ: Workshop nhiếp ảnh cơ bản" required>
                    </div>

                    <div class="form-group">
                        <label for="suggestion-description">Mô tả nhu cầu chi tiết *</label>
                        <textarea id="suggestion-description" name="moTaNhuCau" placeholder="Mô tả chi tiết về sự kiện bạn mong muốn, nhu cầu cụ thể..." required></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="suggestion-type">Loại sự kiện *</label>
                            <select id="suggestion-type" name="loaiSuKienId" required>
                                <option value="">Chọn loại sự kiện</option>
                                <c:forEach var="type" items="${eventTypes}">
                                    <option value="${type.loaiSuKienId}"><c:out value="${type.tenLoai}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="suggestion-location">Địa điểm mong muốn *</label>
                            <input type="text" id="suggestion-location" name="diaDiem" placeholder="Thành phố, địa điểm cụ thể" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="suggestion-time">Thời gian dự kiến *</label>
                            <input type="datetime-local" id="suggestion-time" name="thoiGianDuKien" required>
                        </div>
                        <div class="form-group">
                            <label for="suggestion-guests">Số lượng khách dự kiến *</label>
                            <input type="number" id="suggestion-guests" name="soLuongKhach" min="1" max="1000" placeholder="Số lượng người tham gia" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="suggestion-budget">Khung giá dự kiến</label>
                            <select id="suggestion-budget" name="giaCaLong">
                                <option value="">Chọn khung giá</option>
                                <option value="MIEN_PHI">Miễn phí</option>
                                <option value="DUOI_500K">Dưới 500.000đ</option>
                                <option value="500K_1TR">500.000đ - 1.000.000đ</option>
                                <option value="1TR_3TR">1.000.000đ - 3.000.000đ</option>
                                <option value="TREN_3TR">Trên 3.000.000đ</option>
                                <option value="LIEN_HE">Thương lượng</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="suggestion-contact">Thông tin liên hệ *</label>
                            <input type="text" id="suggestion-contact" name="thongTinLienLac" placeholder="Email, số điện thoại..." required>
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
                                <th>Địa điểm</th>
                                <th>Thời gian DK</th>
                                <th>Số lượng</th>
                                <th>Trạng thái</th>
                                <th>Ngày gửi</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="suggestions-tbody">
                            <c:forEach var="suggestion" items="${suggestions}">
                                <c:set var="loaiSuKienTen" value=""/>
                                <c:forEach var="type" items="${eventTypes}">
                                    <c:if test="${type.loaiSuKienId == suggestion.loaiSuKienId}">
                                        <c:set var="loaiSuKienTen" value="${type.tenLoai}"/>
                                    </c:if>
                                </c:forEach>
                                <tr data-suggestion-id="${suggestion.dangSuKienId}">
                                    <td><c:out value="${suggestion.tieuDe}"/></td>
                                    <td><c:out value="${loaiSuKienTen}"/></td>
                                    <td><c:out value="${suggestion.diaDiem}"/></td>
                                    <td>
                                        <fmt:formatDate value="${suggestion.thoiGianDuKien}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td><c:out value="${suggestion.soLuongKhach}"/></td>
                                    <td>
                                        <span class="status ${fn:toLowerCase(suggestion.trangThai)}">
                                            <c:choose>
                                                <c:when test="${suggestion.trangThai == 'ChoDuyet'}">Chờ duyệt</c:when>
                                                <c:when test="${suggestion.trangThai == 'DaDuyet'}">Đã duyệt</c:when>
                                                <c:when test="${suggestion.trangThai == 'TuChoi'}">Từ chối</c:when>
                                                <c:otherwise><c:out value="${suggestion.trangThai}"/></c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${suggestion.thoiGianTao}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td class="action-buttons">
                                        <div class="action-btn btn-view-suggestion" title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </div>
                                        <c:if test="${suggestion.trangThai == 'CHO_DUYET'}">
                                            <div class="action-btn btn-edit-suggestion" title="Chỉnh sửa">
                                                <i class="fas fa-edit"></i>
                                            </div>
                                            <div class="action-btn btn-delete-suggestion" title="Xóa đề xuất">
                                                <i class="fas fa-trash"></i>
                                            </div>
                                        </c:if>
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
                                        <fmt:formatDate value="${history.thoiGian}" pattern="dd/MM/yyyy HH:mm"/>
                                    <td>
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
                <div class="event-details" style="margin-bottom: 20px; padding: 15px; background-color: var(--primary-light); border-radius: 8px;">
                    <div class="event-meta">
                        <span><i class="far fa-calendar"></i> <span id="modal-event-date"></span></span>
                        <span><i class="fas fa-map-marker-alt"></i> <span id="modal-event-location"></span></span>
                        <span><i class="fas fa-users"></i> <span id="modal-event-capacity"></span></span>
                    </div>
                </div>
                
                <form id="registration-form" action="POST">
                    <div class="form-group" id="event-code-group" style="display: none;">
                        <label for="event-code">Mã sự kiện (dành cho sự kiện riêng tư) *</label>
                        <input type="text" id="event-code" placeholder="Nhập mã sự kiện" >
                        <small style="color: var(--gray); font-size: 12px;">Mã sự kiện được cung cấp bởi người tổ chức</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="reg-note">Ghi chú cho người tổ chức (tùy chọn)</label>
                        <textarea id="reg-note" placeholder="Nhập ghi chú nếu có..."></textarea>
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

    <!-- Suggestion Detail Modal -->
    <div class="modal" id="suggestion-detail-modal">
        <div class="modal-content" style="max-width: 700px;">
            <div class="modal-header">
                <h3>Chi tiết đề xuất sự kiện</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body" id="suggestion-detail-body">
                <!-- Nội dung sẽ được load bằng JavaScript -->
            </div>
        </div>
    </div>

    <!-- Notification Detail Modal -->
    <div class="modal" id="notification-detail-modal">
        <div class="modal-content" style="max-width: 600px;">
            <div class="modal-header">
                <h3>Chi tiết thông báo</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body" id="notification-detail-body">
                <!-- Nội dung sẽ được load bằng JavaScript -->
            </div>
            <div class="modal-footer" id="notification-actions" style="display: none;">
                <button class="btn btn-success" id="btn-accept-notification">
                    <i class="fas fa-check"></i> Chấp nhận
                </button>
                <button class="btn btn-danger" id="btn-reject-notification">
                    <i class="fas fa-times"></i> Từ chối
                </button>
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
                        <i class="fas fa-eye input-icon toggle-password" data-target="change-current-password"></i>
                        <div class="error-message" id="current-password-error-modal"></div>
                    </div>

                    <div class="form-group">
                        <label for="change-new-password">Mật khẩu mới *</label>
                        <input type="password" id="change-new-password" name="newPassword" placeholder="Nhập mật khẩu mới" required>
                        <i class="fas fa-eye input-icon toggle-password" data-target="change-new-password"></i>
                        <div class="password-strength" id="change-password-strength">
                            <div class="password-strength-bar"></div>
                        </div>
                        <div class="password-requirements">
                            <div class="requirement unmet" id="change-length-req">
                                <i class="fas fa-circle"></i>
                                <span>Ít nhất 6 ký tự</span>
                            </div>
                        </div>
                        <div class="error-message" id="new-password-error-modal"></div>
                    </div>

                    <div class="form-group">
                        <label for="change-confirm-password">Xác nhận mật khẩu mới *</label>
                        <input type="password" id="change-confirm-password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                        <i class="fas fa-eye input-icon toggle-password" data-target="change-confirm-password"></i>
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

    <!-- Forgot Password Modal -->
    <div class="modal" id="forgot-password-modal">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header">
                <h3>Quên mật khẩu</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <p style="margin-bottom: 20px; color: var(--gray);">
                    Vui lòng nhập email hoặc tên đăng nhập của bạn. Chúng tôi sẽ gửi hướng dẫn reset mật khẩu qua email.
                </p>
                <form id="forgot-password-form">
                    <div class="form-group">
                        <label for="forgot-email">Email hoặc Tên đăng nhập *</label>
                        <input type="text" id="forgot-email" name="email" placeholder="Nhập email hoặc tên đăng nhập" required>
                        <div class="error-message" id="forgot-email-error"></div>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary" id="submit-forgot-password" style="width: 100%;">
                            <i class="fas fa-paper-plane"></i> Gửi yêu cầu
                        </button>
                    </div>
                </form>
                
                <div style="text-align: center; margin-top: 20px;">
                    <a href="#" id="back-to-login-from-forgot" style="color: var(--primary); text-decoration: none;">
                        <i class="fas fa-arrow-left"></i> Quay lại đăng nhập
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        // Thêm toast container vào body nếu chưa có
        if ($('#toast-container').length === 0) {
            $('body').append('<div class="toast-container" id="toast-container"></div>');
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

        // Modal functionality
        $('.close-modal').click(function() {
            $('.modal').css('display', 'none');
        });

        $(window).click(function(e) {
            if ($(e.target).hasClass('modal')) {
                $('.modal').css('display', 'none');
            }
        });

        // Search functionality với gợi ý
        let searchTimeout;
        $('#search-input').on('input', function() {
            clearTimeout(searchTimeout);
            const query = $(this).val().trim();

            if (query.length < 2) {
                $('#search-suggestions').hide().empty();
                return;
            }

            searchTimeout = setTimeout(function() {
                $.get('/participant/api/events/search', { q: query })
                    .done(function(events) {
                        const $suggestions = $('#search-suggestions').empty();

                        if (events.length == 0) {
                            $suggestions.append(
                                '<div class="no-results">Không tìm thấy sự kiện nào</div>'
                            );
                        } else {
                            events.forEach(function(event) {
                                const dateStr = event.thoiGianBatDau 
                                    ? new Date(event.thoiGianBatDau).toLocaleDateString('vi-VN')
                                    : 'Chưa xác định';

                                const item = 
                                    '<div class="suggestion-item" data-event-id="' + event.suKienId + '">' +
                                        '<div class="suggestion-title">' + event.tenSuKien + '</div>' +
                                        '<div class="suggestion-meta">' +
                                            '<i class="far fa-calendar"></i> ' + dateStr +
                                            ' <i class="fas fa-map-marker-alt"></i> ' + (event.diaDiem || 'Chưa xác định') +
                                        '</div>' +
                                    '</div>';
                                $suggestions.append(item);
                            });
                        }
                        $suggestions.show();
                    })
                    .fail(function() {
                        $('#search-suggestions').html('<div class="no-results">Lỗi tải dữ liệu</div>').show();
                    });
            }, 300);
        });

        // Click vào gợi ý tìm kiếm
        $(document).on('click', '.suggestion-item', function() {
            const eventId = $(this).data('event-id');
            $('#search-input').val($(this).find('.suggestion-title').text());
            $('#search-suggestions').hide();
            
            // Mở modal chi tiết sự kiện
            viewEventDetail(eventId);
        });

        // Ẩn gợi ý khi click ra ngoài
        $(document).on('click', function(e) {
            if (!$(e.target).closest('.search-container').length) {
                $('#search-suggestions').hide();
            }
        });

        // Xem chi tiết sự kiện
        $(document).on('click', '.btn-view-event, .event-card', function(e) {
            // Ngăn sự kiện khi click vào nút tham gia
            if ($(e.target).closest('.btn-join-event').length) {
                return;
            }
            const eventId = $(this).data('event-id');
            viewEventDetail(eventId);
        });

        // Hàm xem chi tiết sự kiện
        function viewEventDetail(eventId) {
            $.get('/participant/api/events/' + eventId)
                .done(function(event) {
                    if (!event) {
                        showToast('Không tìm thấy thông tin sự kiện', false);
                        return;
                    }

                    const formatDate = (dateStr) => {
                        if (!dateStr) return 'Chưa xác định';
                        try {
                            const date = new Date(dateStr);
                            if (isNaN(date.getTime())) return 'Chưa xác định';
                            return date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN');
                        } catch (e) {
                            return 'Chưa xác định';
                        }
                    };

                    // Mapping trạng thái sang tiếng Việt
                    const statusMap = {
                        'DangDienRa': 'Đang diễn ra',
                        'SapDienRa': 'Sắp diễn ra', 
                        'DaKetThuc': 'Đã kết thúc'
                    };
                    
                    const trangThaiText = statusMap[event.trangThai] || event.trangThai || 'Không xác định';

                    const html = 
                        '<div class="event-image" style="margin-bottom: 20px;">' +
                            '<img src="' + (event.anhBia || '/default-image.jpg') + '" alt="' + event.tenSuKien + '" style="width:100%; max-height: 300px; object-fit: cover; border-radius:8px;">' +
                        '</div>' +
                        '<h4 style="margin-bottom: 15px; color: #2c3e50;">' + event.tenSuKien + '</h4>' +
                        '<div class="event-meta" style="margin-bottom: 15px; color: #7f8c8d; display: flex; flex-direction: column; gap: 8px;">' +
                            '<span><i class="far fa-calendar"></i> ' + formatDate(event.thoiGianBatDau) + '</span>' +
                            '<span><i class="fas fa-map-marker-alt"></i> ' + (event.diaDiem || 'Chưa xác định') + '</span>' +
                            '<span><i class="fas fa-users"></i> ' + (event.soLuongDaDangKy || 0) + '/' + event.soLuongToiDa + ' người</span>' +
                        '</div>' +
                        '<p style="margin-bottom: 20px; line-height: 1.6; white-space: pre-wrap;">' + (event.moTa || 'Không có mô tả') + '</p>' +
                        '<div style="display: flex; gap: 20px; margin-bottom: 20px;">' +
                            '<div>' +
                                '<label style="font-weight: 600; color: #555;">Trạng thái:</label>' +
                                '<span class="status ' + (event.trangThai ? event.trangThai.toLowerCase() : '') + '" style="margin-left: 8px;">' + trangThaiText + '</span>' +
                            '</div>' +
                            '<div>' +
                                '<label style="font-weight: 600; color: #555;">Loại sự kiện:</label>' +
                                '<span style="margin-left: 8px;">' + (event.loaiSuKien == 'RiengTu' ? 'Riêng tư' : 'Công khai') + '</span>' +
                            '</div>' +
                        '</div>' +
                        '<div class="modal-actions" style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee;">' +
                            '<button class="btn btn-outline close-modal">Đóng</button>' +
                            '<button class="btn btn-primary btn-join-event-from-modal" data-event-id="' + event.suKienId + '" data-event-name="' + event.tenSuKien + '">' +
                                '<i class="fas fa-plus"></i> Tham gia ngay' +
                            '</button>' +
                        '</div>';
                    
                    $('#event-modal-body').html(html);
                    $('#event-modal').css('display', 'flex');
                })
                .fail(function(xhr, status, error) {
                    console.error('Error loading event detail:', error);
                    showToast('Không tải được thông tin sự kiện: ' + error, false);
                });
        }    

        // Tham gia sự kiện từ modal
        $(document).on('click', '.btn-join-event-from-modal', function() {
            const eventId = $(this).data('event-id');
            const eventName = $(this).data('event-name');
            $('#event-modal').css('display', 'none');
            openRegistrationModal(eventId, eventName);
        });

        // Tham gia sự kiện từ card
        $(document).on('click', '.btn-join-event', function(e) {
            e.stopPropagation();
            const eventId = $(this).data('event-id');
            const eventName = $(this).data('event-name');
            openRegistrationModal(eventId, eventName);
        });

        // Mở modal đăng ký
        function openRegistrationModal(eventId, eventName) {
            $.get('/participant/api/events/' + eventId)
                .done(function(event) {
                    if (!event) {
                        showToast('Không tìm thấy thông tin sự kiện', false);
                        return;
                    }

                    const formatDate = (dateStr) => {
                        if (!dateStr) return 'Chưa xác định';
                        const date = new Date(dateStr);
                        return date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN');
                    };

                    $('#modal-event-title').text(eventName);
                    $('#modal-event-date').text(formatDate(event.thoiGianBatDau));
                    $('#modal-event-location').text(event.diaDiem || 'Chưa xác định');
                    $('#modal-event-capacity').text((event.soLuongDaDangKy || 0) + '/' + event.soLuongToiDa + ' người');
                    
                    // Hiển thị mã sự kiện nếu là sự kiện riêng tư
                    if (event.loaiSuKien == 'RiengTu') {
                        $('#event-code-group').show();
                    } else {
                        $('#event-code-group').hide();
                    }

                    $('#registration-form').data('suKienId', eventId);
                    $('#registration-modal').css('display', 'flex');
                })
                .fail(function() {
                    showToast('Không tải được thông tin sự kiện', false);
                });
        }

        // Gửi đăng ký
        $('#registration-form').submit(function(e) {
            e.preventDefault();
            const suKienId = $(this).data('suKienId');
            const payload = {
                suKienId: suKienId,
                ghiChu: $('#reg-note').val(),
            };

            // Thêm mã sự kiện nếu là sự kiện riêng tư
            if ($('#event-code-group').is(':visible')) {
                payload.maSuKien = $('#event-code').val();
            }

            $.ajax({
                url: '/participant/api/register-event',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function(res) {
                    if (res.success) {
                        showToast(res.message, true);
                        $('#registration-modal').css('display', 'none');
                        // Làm mới danh sách sự kiện của tôi
                        loadMyEvents();
                    } else {
                        showToast(res.message, false);
                    }
                },
                error: function(xhr) {
                    showToast('Đăng ký thất bại: ' + (xhr.responseJSON?.message || 'Lỗi hệ thống'), false);
                }
            });
        });

        // Hủy đăng ký
        $(document).on('click', '.btn-cancel-registration', function(e) {
            e.stopPropagation();
            const dangKyId = $(this).data('registration-id');
            const eventName = $(this).closest('tr').find('td:first').text();
            
            if (confirm('Bạn có chắc muốn hủy đăng ký sự kiện "' + eventName + '"?')) {
                $.ajax({
                    url: '/participant/api/cancel-registration',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ dangKyId: dangKyId }),
                    success: function(res) {
                        if (res.success) {
                            showToast(res.message, true);
                            loadMyEvents();
                        } else {
                            showToast(res.message, false);
                        }
                    },
                    error: function() {
                        showToast('Hủy đăng ký thất bại', false);
                    }
                });
            }
        });

        // Xem chi tiết đề xuất sự kiện
        $(document).on('click', '.btn-view-suggestion', function(e) {
            e.stopPropagation();
            const suggestionId = $(this).closest('tr').data('suggestion-id');
            viewSuggestionDetail(suggestionId);
        });

        // Hàm xem chi tiết đề xuất
        function viewSuggestionDetail(suggestionId) {
            $.get('/participant/api/suggestions/' + suggestionId)
                .done(function(suggestion) {
                    if (!suggestion) {
                        showToast('Không tìm thấy thông tin đề xuất', false);
                        return;
                    }

                    const formatDate = (dateStr) => {
                        if (!dateStr) return 'Chưa xác định';
                        const date = new Date(dateStr);
                        return date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN');
                    };

                    const statusMap = {
                        'CHO_DUYET': 'Chờ duyệt',
                        'DA_DUYET': 'Đã duyệt',
                        'TU_CHOI': 'Từ chối'
                    };

                    const html = 
                        '<div class="suggestion-detail">' +
                            '<div class="detail-row">' +
                                '<label><strong>Tiêu đề:</strong></label>' +
                                '<span>' + (suggestion.tieuDe || 'Chưa có') + '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<label><strong>Mô tả nhu cầu:</strong></label>' +
                                '<span style="white-space: pre-wrap;">' + (suggestion.moTaNhuCau || 'Chưa có') + '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<label><strong>Loại sự kiện:</strong></label>' +
                                '<span>' + (suggestion.loaiSuKienTen || 'Chưa xác định') + '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<label><strong>Địa điểm:</strong></label>' +
                                '<span>' + (suggestion.diaDiem || 'Chưa xác định') + '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<label><strong>Thời gian dự kiến:</strong></label>' +
                                '<span>' + formatDate(suggestion.thoiGianDuKien) + '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<label><strong>Số lượng khách:</strong></label>' +
                                '<span>' + (suggestion.soLuongKhach || 0) + ' người</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<label><strong>Khung giá:</strong></label>' +
                                '<span>' + (suggestion.giaCaLong || 'Chưa xác định') + '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<label><strong>Thông tin liên hệ:</strong></label>' +
                                '<span>' + (suggestion.thongTinLienLac || 'Chưa có') + '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<label><strong>Trạng thái:</strong></label>' +
                                '<span class="status ' + (suggestion.trangThai ? suggestion.trangThai.toLowerCase() : '') + '">' + 
                                    (statusMap[suggestion.trangThai] || suggestion.trangThai || 'Chờ duyệt') + 
                                '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<label><strong>Ngày gửi:</strong></label>' +
                                '<span>' + formatDate(suggestion.thoiGianTao) + '</span>' +
                            '</div>';

                    if (suggestion.thoiGianPhanHoi) {
                        html += 
                            '<div class="detail-row">' +
                                '<label><strong>Thời gian phản hồi:</strong></label>' +
                                '<span>' + formatDate(suggestion.thoiGianPhanHoi) + '</span>' +
                            '</div>';
                    }

                    $('#suggestion-detail-body').html(html);
                    $('#suggestion-detail-modal').css('display', 'flex');
                })
                .fail(function(xhr, status, error) {
                    console.error('Error loading suggestion detail:', error);
                    showToast('Không tải được thông tin đề xuất: ' + error, false);
                });
        }

        // Xóa đề xuất sự kiện
        $(document).on('click', '.btn-delete-suggestion', function(e) {
            e.stopPropagation();
            const suggestionId = $(this).closest('tr').data('suggestion-id');
            const suggestionTitle = $(this).closest('tr').find('td:first').text();
            
            if (confirm('Bạn có chắc muốn xóa đề xuất "' + suggestionTitle + '"?')) {
                $.ajax({
                    url: '/participant/api/suggestions/' + suggestionId,
                    type: 'DELETE',
                    success: function(response) {
                        if (response.success) {
                            showToast('Xóa đề xuất thành công!', true);
                            // Xóa hàng khỏi bảng
                            $('tr[data-suggestion-id="' + suggestionId + '"]').remove();
                            
                            // Kiểm tra nếu không còn đề xuất nào
                            if ($('#suggestions-tbody tr').length == 0) {
                                $('#suggestions-tbody').html(
                                    '<tr><td colspan="8" style="text-align: center; padding: 20px; color: var(--gray);">' +
                                    '<i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 10px;"></i><br>' +
                                    'Không có đề xuất nào</td></tr>'
                                );
                            }
                        }
                    },
                    error: function(xhr) {
                        showToast('Xóa đề xuất thất bại!', false);
                    }
                });
            }
        });

        // Xử lý form đề xuất sự kiện
        $('#suggestion-form').submit(function(e) {
            e.preventDefault();
            
            console.log('== DEBUG: Form submit started ==');
            
            if (!validateSuggestionForm()) {
                console.log('== DEBUG: Form validation failed ==');
                return;
            }
            
            const submitBtn = $('#submit-suggestion');
            submitBtn.prop('disabled', true);
            submitBtn.html('<i class="fas fa-spinner fa-spin"></i> Đang gửi...');
            
            const formData = new FormData(this);
            
            // Lấy giá trị từ tất cả các trường
            const suggestionData = {
                tieuDe: $('#suggestion-title').val().trim(),
                moTaNhuCau: $('#suggestion-description').val().trim(),
                loaiSuKienId: parseInt($('#suggestion-type').val()),
                diaDiem: $('#suggestion-location').val().trim(),
                thoiGianDuKien: $('#suggestion-time').val(),
                soLuongKhach: parseInt($('#suggestion-guests').val()),
                giaCaLong: $('#suggestion-budget').val(),
                thongTinLienLac: $('#suggestion-contact').val().trim()
            };
            
            console.log('== DEBUG: Form Data ==', suggestionData);
            
            // Gửi request đến API
            $.ajax({
                url: '/participant/api/suggestions',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(suggestionData),
                success: function(response) {
                    console.log('== DEBUG: Response data ==', response);
                    showToast('Gửi đề xuất thành công!', true);
                    $('#suggestion-form')[0].reset();
                    // Tải lại danh sách đề xuất
                    loadSuggestions();
                },
                error: function(xhr, status, error) {
                    console.error('== DEBUG: Error ==', error);
                    showToast('Có lỗi xảy ra khi gửi đề xuất! ' + (xhr.responseJSON?.message || error), false);
                },
                complete: function() {
                    submitBtn.prop('disabled', false);
                    submitBtn.html('<i class="fas fa-paper-plane"></i> Gửi đề xuất');
                }
            });
        });

        // Validate form đề xuất
        function validateSuggestionForm() {
            const title = $('#suggestion-title').val().trim();
            const description = $('#suggestion-description').val().trim();
            const type = $('#suggestion-type').val();
            const location = $('#suggestion-location').val().trim();
            const time = $('#suggestion-time').val();
            const guests = $('#suggestion-guests').val();
            const contact = $('#suggestion-contact').val().trim();
            
            if (!title) {
                showToast('Vui lòng nhập tiêu đề sự kiện!', false);
                $('#suggestion-title').focus();
                return false;
            }
            
            if (!description) {
                showToast('Vui lòng nhập mô tả nhu cầu!', false);
                $('#suggestion-description').focus();
                return false;
            }
            
            if (!type) {
                showToast('Vui lòng chọn loại sự kiện!', false);
                $('#suggestion-type').focus();
                return false;
            }
            
            if (!location) {
                showToast('Vui lòng nhập địa điểm!', false);
                $('#suggestion-location').focus();
                return false;
            }
            
            if (!time) {
                showToast('Vui lòng chọn thời gian dự kiến!', false);
                $('#suggestion-time').focus();
                return false;
            }
            
            if (!guests || guests < 1) {
                showToast('Vui lòng nhập số lượng khách hợp lệ!', false);
                $('#suggestion-guests').focus();
                return false;
            }
            
            if (!contact) {
                showToast('Vui lòng nhập thông tin liên hệ!', false);
                $('#suggestion-contact').focus();
                return false;
            }
            
            // Kiểm tra thời gian không được trong quá khứ
            const selectedTime = new Date(time);
            const now = new Date();
            if (selectedTime < now) {
                showToast('Thời gian dự kiến không được trong quá khứ!', false);
                $('#suggestion-time').focus();
                return false;
            }
            
            return true;
        }

        // Reset form đề xuất
        $('#reset-suggestion').click(function() {
            $('#suggestion-form')[0].reset();
            showToast('Đã đặt lại form!', true);
        });

        // Xử lý thông báo
        // Xem chi tiết thông báo
        $(document).on('click', '.notification-item', function(e) {
            // Ngăn sự kiện khi click vào nút xóa hoặc đánh dấu đã đọc
            if ($(e.target).closest('.notification-actions').length) {
                return;
            }
            const notificationId = $(this).data('notification-id');
            viewNotificationDetail(notificationId);
        });

        // Hàm xem chi tiết thông báo
        function viewNotificationDetail(notificationId) {
            $.get('/participant/api/notifications/' + notificationId)
                .done(function(notification) {
                    if (!notification) {
                        showToast('Không tìm thấy thông tin thông báo', false);
                        return;
                    }

                    const formatDate = (dateStr) => {
                        if (!dateStr) return 'Chưa xác định';
                        const date = new Date(dateStr);
                        return date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN');
                    };

                    const html = 
                        '<div class="notification-detail">' +
                            '<div class="notification-header" style="display: flex; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid var(--border-color);">' +
                                '<div class="notification-icon ' + (notification.loaiThongBao || 'reminder') + '" style="font-size: 24px; margin-right: 15px; color: var(--primary);">' +
                                    '<i class="fas ' + getNotificationIcon(notification.loaiThongBao) + '"></i>' +
                                '</div>' +
                                '<div style="flex: 1;">' +
                                    '<h4 style="margin: 0 0 5px 0; color: var(--dark);">' + (notification.tieuDe || 'Không có tiêu đề') + '</h4>' +
                                    '<span style="color: var(--gray); font-size: 14px;">' + 
                                        formatDate(notification.thoiGian) + 
                                    '</span>' +
                                '</div>' +
                            '</div>' +
                            '<div class="notification-content" style="margin-bottom: 20px;">' +
                                '<p style="line-height: 1.6; white-space: pre-wrap; font-size: 16px;">' + (notification.noiDung || 'Không có nội dung') + '</p>' +
                            '</div>' +
                        '</div>';

                    $('#notification-detail-body').html(html);
                    
                    // Hiển thị nút hành động nếu là thông báo cá nhân
                    const $actions = $('#notification-actions');
                    if (notification.loaiThongBao == 'CaNhan' && notification.daDoc == 0) {
                        $actions.show().data('notification-id', notificationId);
                    } else {
                        $actions.hide();
                    }
                    
                    $('#notification-detail-modal').css('display', 'flex');
                    
                    // Đánh dấu đã đọc
                    if (notification.daDoc == 0) {
                        $.post('/participant/api/notifications/mark-read', { thongBaoId: notificationId });
                        $('.notification-item[data-notification-id="' + notificationId + '"]').removeClass('notification-unread');
                        
                        // Cập nhật badge
                        const currentCount = parseInt($('#notification-count').text());
                        if (currentCount > 0) {
                            $('#notification-count').text(currentCount - 1);
                        }
                    }
                })
                .fail(function(xhr, status, error) {
                    console.error('Error loading notification detail:', error);
                    showToast('Không tải được thông tin thông báo: ' + error, false);
                });
        }

        // Hàm lấy icon cho thông báo
        function getNotificationIcon(type) {
            switch(type) {
                case 'event': return 'fa-calendar-alt';
                case 'system': return 'fa-cog';
                default: return 'fa-bell';
            }
        }

        // Xử lý chấp nhận thông báo
        $('#btn-accept-notification').click(function() {
            const notificationId = $('#notification-actions').data('notification-id');
            processNotificationAction(notificationId, 'accept');
        });

        // Xử lý từ chối thông báo
        $('#btn-reject-notification').click(function() {
            const notificationId = $('#notification-actions').data('notification-id');
            processNotificationAction(notificationId, 'reject');
        });

        function processNotificationAction(notificationId, action) {
            $.post('/participant/api/notifications/' + notificationId + '/action', { action: action })
                .done(function(response) {
                    if (response.success) {
                        showToast('Đã ' + (action == 'accept' ? 'chấp nhận' : 'từ chối') + ' thông báo!', true);
                        $('#notification-detail-modal').css('display', 'none');
                        
                        // Xóa thông báo khỏi danh sách
                        $('.notification-item[data-notification-id="' + notificationId + '"]').remove();
                        
                        // Kiểm tra nếu không còn thông báo
                        if ($('#notification-list .notification-item').length == 0) {
                            $('#notification-list').html(
                                '<li class="no-notifications" style="text-align: center; padding: 40px; color: var(--gray);">' +
                                '<i class="fas fa-bell-slash" style="font-size: 48px; margin-bottom: 15px;"></i>' +
                                '<h3>Không có thông báo</h3>' +
                                '<p>Bạn không có thông báo nào mới.</p>' +
                                '</li>'
                            );
                        }
                    }
                })
                .fail(function() {
                    showToast('Xử lý thông báo thất bại!', false);
                });
        }

        // Xóa thông báo
        $(document).on('click', '.btn-delete-notification', function(e) {
            e.stopPropagation();
            const notificationId = $(this).closest('.notification-item').data('notification-id');
            
            if (confirm('Bạn có chắc muốn xóa thông báo này?')) {
                $.ajax({
                    url: '/participant/api/notifications/' + notificationId,
                    type: 'DELETE',
                    success: function(response) {
                        if (response.success) {
                            // Xóa thông báo khỏi danh sách
                            $('.notification-item[data-notification-id="' + notificationId + '"]').remove();
                            
                            // Cập nhật badge nếu là thông báo chưa đọc
                            const $deletedItem = $('.notification-item[data-notification-id="' + notificationId + '"]');
                            if ($deletedItem.hasClass('notification-unread')) {
                                const currentCount = parseInt($('#notification-count').text());
                                if (currentCount > 0) {
                                    $('#notification-count').text(Math.max(0, currentCount - 1));
                                }
                            }
                            
                            // Kiểm tra nếu không còn thông báo
                            if ($('#notification-list .notification-item').length == 0) {
                                $('#notification-list').html(
                                    '<li class="no-notifications" style="text-align: center; padding: 40px; color: var(--gray);">' +
                                    '<i class="fas fa-bell-slash" style="font-size: 48px; margin-bottom: 15px;"></i>' +
                                    '<h3>Không có thông báo</h3>' +
                                    '<p>Bạn không có thông báo nào mới.</p>' +
                                    '</li>'
                                );
                            }
                        }
                    },
                    error: function() {
                        showToast('Xóa thông báo thất bại!', false);
                    }
                });
            }
        });

        // Đánh dấu thông báo đã đọc
        $(document).on('click', '.btn-mark-read', function(e) {
            e.stopPropagation();
            const notificationId = $(this).closest('.notification-item').data('notification-id');
            const $notificationItem = $('.notification-item[data-notification-id="' + notificationId + '"]');
            
            $.post('/participant/api/notifications/mark-read', { thongBaoId: notificationId })
                .done(function() {
                    $notificationItem.removeClass('notification-unread');
                    $(e.target).closest('.btn-mark-read').remove();
                    
                    // Cập nhật badge
                    const currentCount = parseInt($('#notification-count').text());
                    if (currentCount > 0) {
                        $('#notification-count').text(currentCount - 1);
                    }
                    
                    showToast('Đã đánh dấu đã đọc!', true);
                })
                .fail(function() {
                    showToast('Đánh dấu đã đọc thất bại!', false);
                });
        });

        // Lọc thông báo
        $('#notification-type, #notification-date').change(function() {
            filterNotifications();
        });

        // Lọc chỉ xem chưa đọc
        $('#filter-unread').click(function() {
            $(this).toggleClass('active');
            filterNotifications();
        });

        function filterNotifications() {
            const typeFilter = $('#notification-type').val();
            const dateFilter = $('#notification-date').val();
            const showUnreadOnly = $('#filter-unread').hasClass('active');
            
            $('.notification-item').each(function() {
                const $item = $(this);
                const itemType = $item.data('notification-type') || 'reminder';
                const isUnread = $item.hasClass('notification-unread');
                const itemTime = new Date($item.find('.notification-time').text());
                const now = new Date();
                
                let typeMatch = !typeFilter || itemType == typeFilter;
                let unreadMatch = !showUnreadOnly || isUnread;
                let dateMatch = true;
                
                // Lọc theo thời gian
                if (dateFilter) {
                    switch(dateFilter) {
                        case 'today':
                            dateMatch = itemTime.toDateString() == now.toDateString();
                            break;
                        case 'week':
                            const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
                            dateMatch = itemTime >= weekAgo;
                            break;
                        case 'month':
                            const monthAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
                            dateMatch = itemTime >= monthAgo;
                            break;
                    }
                }
                
                $item.css('display', (typeMatch && unreadMatch && dateMatch) ? 'flex' : 'none');
            });
        }

        // Đánh dấu tất cả thông báo đã đọc
        $('#mark-all-read').click(function() {
            $.post('/participant/api/notifications/mark-all-read')
                .done(function() {
                    $('.notification-item').removeClass('notification-unread');
                    $('.btn-mark-read').remove();
                    $('#notification-count').text('0');
                    showToast('Đã đánh dấu tất cả thông báo đã đọc!', true);
                })
                .fail(function() {
                    showToast('Đánh dấu đã đọc thất bại!', false);
                });
        });

        // Các hàm load dữ liệu
        function loadMyEvents() {
            $.get('/participant/api/my-events')
                .done(function(registrations) {
                    // Cập nhật bảng sự kiện của tôi
                    // Triển khai theo nhu cầu cụ thể
                    console.log('Loaded my events:', registrations);
                })
                .fail(function(error) {
                    console.error('Error loading my events:', error);
                });
        }

        function loadSuggestions() {
            $.get('/participant/api/suggestions')
                .done(function(suggestions) {
                    // Cập nhật bảng đề xuất
                    // Triển khai theo nhu cầu cụ thể
                    console.log('Loaded suggestions:', suggestions);
                })
                .fail(function(error) {
                    console.error('Error loading suggestions:', error);
                });
        }

        // Xem tất cả sự kiện nổi bật
        $('#view-all-featured').click(function() {
            $('.menu-link[data-target="events"]').click();
        });

        // Xem tất cả sự kiện sắp diễn ra
        $('#view-all-upcoming').click(function() {
            $('.menu-link[data-target="events"]').click();
        });
        
        // Filter events
        $('.filter-section select').change(function() {
            const filters = {
                type: $('#eventType').val(),
                date: $('#eventDate').val(),
                location: $('#eventLocation').val(),
                sort: $('#eventSort').val()
            };
            
            $.get('/participant/api/events', filters, function(events) {
                let html = '';
                if (events.length == 0) {
                    html = '<div class="no-events" style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--gray);">' +
                        '<i class="fas fa-calendar-times" style="font-size: 48px; margin-bottom: 15px;"></i>' +
                        '<h3>Không tìm thấy sự kiện</h3>' +
                        '<p>Không có sự kiện nào phù hợp với bộ lọc của bạn.</p>' +
                        '</div>';
                } else {
                    events.forEach(function(event) {
                        const eventDate = event.thoiGianBatDau ? new Date(event.thoiGianBatDau).toLocaleString('vi-VN') : 'Chưa xác định';
                        
                        html += '<div class="event-card" data-event-id="' + event.suKienId + '">' +
                            '<div class="event-image">' +
                                '<img src="' + (event.anhBia || '/default-image.jpg') + '" alt="' + event.tenSuKien + '">' +
                            '</div>' +
                            '<div class="event-content">' +
                                '<h4 class="event-title">' + event.tenSuKien + '</h4>' +
                                '<div class="event-meta">' +
                                    '<span><i class="far fa-calendar"></i> ' + eventDate + '</span>' +
                                    '<span><i class="fas fa-map-marker-alt"></i> ' + event.diaDiem + '</span>' +
                                '</div>' +
                                '<p>' + (event.moTa ? (event.moTa.length > 100 ? event.moTa.substring(0, 100) + '...' : event.moTa) : 'Không có mô tả') + '</p>' +
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
                }
                $('#all-events-grid').html(html);
            });
        });

        // Hàm lọc sự kiện nâng cao
        function applyEventFilters() {
            const filters = {
                keyword: $('#filter-keyword').val(),
                eventType: $('#filter-eventType').val(),
                categoryId: $('#filter-category').val() || null,
                status: $('#filter-status').val(),
                startDate: $('#filter-startDate').val() || null,
                endDate: $('#filter-endDate').val() || null,
                location: $('#filter-location').val()
            };

            // Hiển thị loading
            $('#all-events-grid').html(
                '<div class="loading" style="grid-column: 1 / -1; text-align: center; padding: 40px;">' +
                '<i class="fas fa-spinner fa-spin" style="font-size: 24px; margin-bottom: 10px;"></i><br>' +
                'Đang tìm kiếm sự kiện...' +
                '</div>'
            );

            // Gọi API lọc
            $.ajax({
                url: '/participant/api/events/filter',
                type: 'GET',
                data: filters,
                success: function(response) {
                    if (response.success) {
                        displayFilteredEvents(response.data);
                        updateFilterResultsInfo(response.data.length);
                    } else {
                        showToast('Lỗi khi lọc sự kiện: ' + response.message, false);
                        $('#all-events-grid').html(
                            '<div class="no-events" style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--gray);">' +
                            '<i class="fas fa-exclamation-triangle" style="font-size: 48px; margin-bottom: 15px;"></i>' +
                            '<h3>Lỗi tải dữ liệu</h3>' +
                            '<p>Không thể tải danh sách sự kiện.</p>' +
                            '</div>'
                        );
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Filter error:', error);
                    showToast('Lỗi kết nối khi lọc sự kiện', false);
                    $('#all-events-grid').html(
                        '<div class="no-events" style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--gray);">' +
                        '<i class="fas fa-exclamation-triangle" style="font-size: 48px; margin-bottom: 15px;"></i>' +
                        '<h3>Lỗi kết nối</h3>' +
                        '<p>Không thể kết nối đến máy chủ.</p>' +
                        '</div>'
                    );
                }
            });
        }

        // Hiển thị kết quả lọc
        function displayFilteredEvents(events) {
            let html = '';
            
            if (events.length === 0) {
                html = '<div class="no-events" style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--gray);">' +
                    '<i class="fas fa-calendar-times" style="font-size: 48px; margin-bottom: 15px;"></i>' +
                    '<h3>Không tìm thấy sự kiện</h3>' +
                    '<p>Không có sự kiện nào phù hợp với tiêu chí lọc của bạn.</p>' +
                    '</div>';
            } else {
                events.forEach(function(event) {
                    const eventDate = event.thoiGianBatDau ? 
                        new Date(event.thoiGianBatDau).toLocaleDateString('vi-VN') + ' ' + 
                        new Date(event.thoiGianBatDau).toLocaleTimeString('vi-VN', {hour: '2-digit', minute:'2-digit'}) : 
                        'Chưa xác định';
                    
                    const description = event.moTa ? 
                        (event.moTa.length > 100 ? event.moTa.substring(0, 100) + '...' : event.moTa) : 
                        'Không có mô tả';
                    
                    html += '<div class="event-card" data-event-id="' + event.suKienId + '">' +
                        '<div class="event-image">' +
                            '<img src="' + (event.anhBia || '/default-image.jpg') + '" alt="' + event.tenSuKien + '">' +
                        '</div>' +
                        '<div class="event-content">' +
                            '<h4 class="event-title">' + event.tenSuKien + '</h4>' +
                            '<div class="event-meta">' +
                                '<span><i class="far fa-calendar"></i> ' + eventDate + '</span>' +
                                '<span><i class="fas fa-map-marker-alt"></i> ' + (event.diaDiem || 'Chưa xác định') + '</span>' +
                            '</div>' +
                            '<div class="event-categories">' +
                                '<span class="event-category">' + (event.loaiSuKienTen || 'Không phân loại') + '</span>' +
                                '<span class="event-type ' + event.loaiSuKien?.toLowerCase() + '">' + event.loaiSuKien + '</span>' +
                            '</div>' +
                            '<p class="event-description">' + description + '</p>' +
                            '<div class="event-footer">' +
                                '<span class="status ' + (event.trangThai ? event.trangThai.toLowerCase().replace(' ', '-') : '') + '">' + 
                                    event.trangThai + 
                                '</span>' +
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
            }
            
            $('#all-events-grid').html(html);
        }

        // Cập nhật thông tin kết quả lọc
        function updateFilterResultsInfo(count) {
            const $info = $('#filter-results-info');
            const $count = $('#results-count');
            
            $count.text(count);
            $info.show();
        }

        // Reset bộ lọc
        function resetFilters() {
            $('#filter-keyword').val('');
            $('#filter-eventType').val('');
            $('#filter-category').val('');
            $('#filter-status').val('');
            $('#filter-startDate').val('');
            $('#filter-endDate').val('');
            $('#filter-location').val('');
            
            $('#filter-results-info').hide();
            
            // Tải lại danh sách sự kiện mặc định
            loadDefaultEvents();
        }

        // Tải danh sách sự kiện mặc định
        function loadDefaultEvents() {
            $('#all-events-grid').html(
                '<div class="loading" style="grid-column: 1 / -1; text-align: center; padding: 20px;">' +
                '<i class="fas fa-spinner fa-spin"></i> Đang tải...' +
                '</div>'
            );
            
            $.get('/participant/api/events')
                .done(function(events) {
                    displayFilteredEvents(events);
                })
                .fail(function() {
                    showToast('Lỗi tải danh sách sự kiện', false);
                });
        }

        // Thêm CSS cho phần loại sự kiện
        const filterStyles = `
        <style>
        .event-categories {
            display: flex;
            gap: 8px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }

        .event-category {
            background: var(--primary-light);
            color: var(--primary);
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .event-type {
            background: var(--secondary-light);
            color: var(--secondary);
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .event-type.congkhai {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .event-type.riengtu {
            background: #fff3e0;
            color: #ef6c00;
        }

        .filter-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border-color);
        }

        .filter-results-info {
            margin-top: 15px;
            padding: 10px 15px;
            background: var(--primary-light);
            border-radius: 8px;
            font-weight: 500;
        }

        .btn-clear-filters {
            background: none;
            border: none;
            color: var(--primary);
            cursor: pointer;
            font-size: 14px;
        }

        .btn-clear-filters:hover {
            text-decoration: underline;
        }

        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 2000;
            pointer-events: none;
        }
        </style>
        `;

        // Thêm CSS vào document
        $(filterStyles).appendTo('head');

        // Gắn sự kiện cho các nút lọc
        $(document).ready(function() {
            $('#apply-filters').click(applyEventFilters);
            $('#reset-filters').click(resetFilters);
            $('#clear-filters-text').click(resetFilters);
            
            // Enter để áp dụng lọc
            $('#filter-keyword, #filter-location').keypress(function(e) {
                if (e.which === 13) {
                    applyEventFilters();
                }
            });
            
            // Tải danh sách mặc định khi vào trang events
            if ($('#events').hasClass('active')) {
                loadDefaultEvents();
            }
        });

        // Khởi tạo
        console.log('Participant dashboard initialized');
        

        // Mở modal đổi mật khẩu
        $('#change-password').click(function(e) {
            e.preventDefault();
            $('#change-password-modal').css('display', 'flex');
            resetChangePasswordForm();
        });

        // Mở modal quên mật khẩu
        $('a[href="#"]').filter(function() {
            return $(this).text().includes('Quên mật khẩu');
        }).click(function(e) {
            e.preventDefault();
            $('#forgot-password-modal').css('display', 'flex');
        });

        // Quay lại từ quên mật khẩu
        $('#back-to-login-from-forgot').click(function(e) {
            e.preventDefault();
            $('#forgot-password-modal').css('display', 'none');
        });

        // Xử lý form đổi mật khẩu
        $('#change-password-form').submit(function(e) {
            e.preventDefault();
            
            if (!validateChangePasswordForm()) {
                return;
            }

            const submitBtn = $('#submit-change-password');
            submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Đang xử lý...');

            const formData = {
                currentPassword: $('#change-current-password').val(),
                newPassword: $('#change-new-password').val(),
                confirmPassword: $('#change-confirm-password').val()
            };

            $.ajax({
                url: '/participant/api/change-password',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(formData),
                success: function(response) {
                    submitBtn.prop('disabled', false).html('<i class="fas fa-key"></i> Đổi mật khẩu');
                    
                    if (response.success) {
                        showToast(response.message, true);
                        $('#change-password-modal').css('display', 'none');
                        resetChangePasswordForm();
                    } else {
                        showToast(response.message, false);
                        
                        // Hiển thị lỗi cụ thể
                        if (response.message.includes('Mật khẩu hiện tại')) {
                            $('#change-current-password').parent().addClass('error');
                            $('#current-password-error-modal').text(response.message).show();
                        }
                    }
                },
                error: function(xhr) {
                    submitBtn.prop('disabled', false).html('<i class="fas fa-key"></i> Đổi mật khẩu');
                    const errorMsg = xhr.responseJSON?.message || 'Lỗi kết nối đến server';
                    showToast('Đổi mật khẩu thất bại: ' + errorMsg, false);
                }
            });
        });

        // Xử lý form quên mật khẩu
        $('#forgot-password-form').submit(function(e) {
            e.preventDefault();
            
            const email = $('#forgot-email').val().trim();
            if (!email) {
                showToast('Vui lòng nhập email hoặc tên đăng nhập', false);
                return;
            }

            const submitBtn = $('#submit-forgot-password');
            submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Đang gửi...');

            $.ajax({
                url: '/participant/api/forgot-password',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ email: email }),
                success: function(response) {
                    submitBtn.prop('disabled', false).html('<i class="fas fa-paper-plane"></i> Gửi yêu cầu');
                    
                    if (response.success) {
                        showToast(response.message, true);
                        $('#forgot-password-modal').css('display', 'none');
                        $('#forgot-email').val('');
                    } else {
                        showToast(response.message, false);
                    }
                },
                error: function(xhr) {
                    submitBtn.prop('disabled', false).html('<i class="fas fa-paper-plane"></i> Gửi yêu cầu');
                    showToast('Gửi yêu cầu thất bại', false);
                }
            });
        });

        // Validate form đổi mật khẩu
        function validateChangePasswordForm() {
            let isValid = true;
            resetChangePasswordErrors();

            const currentPassword = $('#change-current-password').val();
            const newPassword = $('#change-new-password').val();
            const confirmPassword = $('#change-confirm-password').val();

            if (!currentPassword) {
                $('#change-current-password').parent().addClass('error');
                $('#current-password-error-modal').text('Vui lòng nhập mật khẩu hiện tại').show();
                isValid = false;
            }

            if (!newPassword || newPassword.length < 6) {
                $('#change-new-password').parent().addClass('error');
                $('#new-password-error-modal').text('Mật khẩu mới phải có ít nhất 6 ký tự').show();
                isValid = false;
            }

            if (!confirmPassword || newPassword !== confirmPassword) {
                $('#change-confirm-password').parent().addClass('error');
                $('#confirm-password-error-modal').text('Mật khẩu xác nhận không khớp').show();
                isValid = false;
            }

            return isValid;
        }

        // Reset form đổi mật khẩu
        function resetChangePasswordForm() {
            $('#change-password-form')[0].reset();
            resetChangePasswordErrors();
            resetChangePasswordStrength();
        }

        // Reset lỗi form đổi mật khẩu
        function resetChangePasswordErrors() {
            $('#change-password-form .form-group').removeClass('error');
            $('#change-password-form .error-message').hide();
        }

        // Reset hiển thị độ mạnh mật khẩu
        function resetChangePasswordStrength() {
            $('#change-password-strength').removeClass('weak medium strong');
            $('#change-password-form .requirement').removeClass('met').addClass('unmet');
            $('#change-password-form .requirement i').removeClass('fa-check-circle').addClass('fa-circle');
        }

        // Kiểm tra độ mạnh mật khẩu mới
        $('#change-new-password').on('input', function() {
            const password = $(this).val();
            checkChangePasswordStrength(password);
        });

        function checkChangePasswordStrength(password) {
            const strengthBar = $('#change-password-strength');
            const requirements = {
                length: password.length >= 6
            };
            
            // Cập nhật hiển thị yêu cầu
            updateChangePasswordRequirements(requirements);
            
            // Cập nhật thanh độ mạnh
            strengthBar.removeClass('weak medium strong');
            if (password.length === 0) {
                // Ẩn thanh khi không có mật khẩu
                strengthBar.css('opacity', '0');
            } else {
                strengthBar.css('opacity', '1');
                if (password.length < 6) {
                    strengthBar.addClass('weak');
                } else if (password.length < 8) {
                    strengthBar.addClass('medium');
                } else {
                    strengthBar.addClass('strong');
                }
            }
        }

        function updateChangePasswordRequirements(requirements) {
            $('#change-length-req').toggleClass('met unmet', requirements.length);
            
            // Cập nhật icon
            $('#change-password-form .requirement.met i').removeClass('fa-circle').addClass('fa-check-circle');
            $('#change-password-form .requirement.unmet i').removeClass('fa-check-circle').addClass('fa-circle');
        }

        // Xác thực mật khẩu xác nhận real-time
        $('#change-confirm-password').on('input', function() {
            const newPassword = $('#change-new-password').val();
            const confirmPassword = $(this).val();
            
            if (confirmPassword && newPassword !== confirmPassword) {
                $(this).parent().addClass('error');
                $('#confirm-password-error-modal').text('Mật khẩu xác nhận không khớp').show();
            } else {
                $(this).parent().removeClass('error');
                $('#confirm-password-error-modal').hide();
            }
        });

        // Thêm CSS cho modal đổi mật khẩu
        const changePasswordStyles = `
        <style>
        .change-password-container {
            max-width: 400px;
            margin: 0 auto;
        }

        .password-strength {
            margin-top: 8px;
            height: 4px;
            border-radius: 2px;
            background: #eee;
            overflow: hidden;
            transition: opacity 0.3s ease;
        }

        .password-strength-bar {
            height: 100%;
            width: 0;
            transition: all 0.3s ease;
        }

        .password-strength.weak .password-strength-bar {
            background: var(--danger);
            width: 33%;
        }

        .password-strength.medium .password-strength-bar {
            background: var(--warning);
            width: 66%;
        }

        .password-strength.strong .password-strength-bar {
            background: var(--success);
            width: 100%;
        }

        .password-requirements {
            margin-top: 10px;
            font-size: 13px;
            color: var(--gray);
        }

        .requirement {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }

        .requirement i {
            margin-right: 8px;
            width: 16px;
            text-align: center;
            font-size: 12px;
        }

        .requirement.met {
            color: var(--success);
        }

        .requirement.unmet {
            color: var(--gray);
        }
        </style>
        `;

        $(changePasswordStyles).appendTo('head');
    });    
    </script>
</body>
</html>