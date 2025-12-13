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
            --border-color: rgba(0, 0, 0, 0.05);
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
            border-bottom: 1px solid var(--border-color);
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

        /* Search */
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
            transition: var(--transition);
        }

        #search-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
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

        /* User & Notification */
        .notification-dropdown-wrapper {
            position: relative;
        }

        .notification-trigger {
            position: relative;
            cursor: pointer;
            padding: 8px;
            border-radius: 8px;
            transition: background-color 0.3s;
        }

        .notification-trigger:hover {
            background-color: rgba(0,0,0,0.05);
        }

        .notification-trigger i {
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

        .user-info-dropdown {
            position: relative;
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
            width: 250px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            z-index: 1000;
            display: none;
            margin-top: 10px;
        }

        .user-dropdown.show {
            display: block;
            animation: slideDown 0.3s ease;
        }

        .user-dropdown-header {
            padding: 15px 20px;
            border-bottom: 1px solid #f0f0f0;
        }

        .user-dropdown-header h4 {
            margin: 0 0 5px 0;
            font-size: 16px;
            font-weight: 600;
            color: var(--dark);
        }

        .user-dropdown-header p {
            margin: 0;
            font-size: 13px;
            color: var(--gray);
        }

        .user-dropdown-menu {
            padding: 10px 0;
        }

        .dropdown-item {
            display: flex;
            align-items: center;
            padding: 10px 20px;
            color: #555;
            text-decoration: none;
            transition: background-color 0.2s;
            gap: 10px;
        }

        .dropdown-item:hover {
            background-color: #f8f9fa;
            color: var(--primary);
        }

        .dropdown-item i {
            width: 20px;
            text-align: center;
        }

        /* Notification Dropdown */
        .notification-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            width: 380px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            z-index: 1000;
            display: none;
            margin-top: 10px;
        }

        .notification-dropdown.show {
            display: block;
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

        .notification-dropdown-header {
            padding: 15px 20px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .notification-dropdown-header h4 {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
        }

        .btn-mark-all-read {
            background: none;
            border: none;
            color: var(--primary);
            font-size: 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .btn-mark-all-read:hover {
            text-decoration: underline;
        }

        .notification-dropdown-list {
            max-height: 400px;
            overflow-y: auto;
        }

        .notification-dropdown-item {
            display: flex;
            padding: 15px 20px;
            border-bottom: 1px solid #f8f9fa;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .notification-dropdown-item:hover {
            background-color: #f8f9fa;
        }

        .notification-dropdown-item.unread {
            background-color: rgba(76, 175, 80, 0.05);
        }

        .notification-dropdown-item .notification-icon {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 14px;
            margin-right: 12px;
            flex-shrink: 0;
        }

        .notification-dropdown-item .notification-icon.event {
            background-color: var(--primary);
        }

        .notification-dropdown-item .notification-icon.system {
            background-color: var(--warning);
        }

        .notification-dropdown-item .notification-content {
            flex: 1;
        }

        .notification-dropdown-item .notification-title {
            font-weight: 600;
            margin-bottom: 4px;
            color: var(--dark);
        }

        .notification-dropdown-item p {
            margin: 0 0 5px 0;
            color: #666;
            font-size: 13px;
            line-height: 1.4;
        }

        .notification-dropdown-item .notification-time {
            font-size: 11px;
            color: var(--gray);
        }

        .no-notifications {
            text-align: center;
            padding: 30px 20px;
            color: var(--gray);
        }

        .no-notifications i {
            font-size: 48px;
            margin-bottom: 10px;
            opacity: 0.5;
        }

        .notification-dropdown-footer {
            padding: 12px 20px;
            border-top: 1px solid #f0f0f0;
            text-align: center;
        }

        .view-all-notifications {
            color: var(--primary);
            text-decoration: none;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .view-all-notifications:hover {
            text-decoration: underline;
        }

        .dropdown-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            z-index: 999;
            display: none;
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

        /* Buttons */
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

        .btn-outline.active {
            background-color: var(--primary);
            color: white;
        }

        .btn-sm {
            padding: 8px 16px;
            font-size: 14px;
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
            border-bottom: 1px solid var(--border-color);
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

        .status.approved, .status.daduyet {
            background-color: rgba(76, 175, 80, 0.15);
            color: var(--success);
        }

        .status.pending, .status.choduyet {
            background-color: rgba(255, 193, 7, 0.15);
            color: var(--warning);
        }

        .status.cancelled, .status.tuchoi {
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
            margin-bottom: 20px;
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

        #event-code-group {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid var(--primary);
            margin-bottom: 20px;
            transition: all 0.3s ease;
            animation: slideDown 0.3s ease;
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
            border-top: 1px solid var(--border-color);
        }

        /* Filter Section */
        .filter-section {
            background: white;
            border-radius: var(--border-radius);
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: var(--box-shadow);
        }

        .filter-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border-color);
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
            animation: modalSlideUp 0.3s ease;
        }

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

        .modal-header {
            padding: 20px 25px;
            border-bottom: 1px solid var(--border-color);
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

        .modal-footer {
            padding: 15px 20px;
            border-top: 1px solid var(--border-color);
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        /* Sidebar chi tiết sự kiện */
        .sidebar-detail {
            position: fixed;
            top: 0;
            right: -500px;
            width: 500px;
            height: 100vh;
            background: white;
            box-shadow: -5px 0 15px rgba(0,0,0,0.1);
            z-index: 1050;
            transition: right 0.3s ease;
            overflow-y: auto;
        }

        .sidebar-detail.open {
            right: 0;
        }

        .sidebar-detail-header {
            padding: 20px;
            border-bottom: 1px solid #eee;
            background: linear-gradient(135deg, var(--primary) 0%, #62ea69 100%);
            color: white;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .sidebar-detail-header h3 {
            margin: 0;
            font-size: 20px;
        }

        .close-sidebar {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
            position: absolute;
            right: 20px;
            top: 20px;
        }

        .sidebar-detail-content {
            padding: 20px;
        }

        /* Phần đánh giá */
        .rating-section {
            margin-bottom: 20px;
        }

        .rating-overview {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 15px;
        }

        .average-rating {
            text-align: center;
        }

        .rating-number {
            font-size: 32px;
            font-weight: 700;
            color: #2c3e50;
        }

        .rating-stars {
            display: flex;
            gap: 3px;
        }

        .star {
            font-size: 18px;
            color: #ddd;
            cursor: pointer;
        }

        .star.active {
            color: #ffc107;
        }

        .star.hover {
            color: #ffdb58;
        }

        .rating-distribution {
            flex: 1;
        }

        .rating-bar {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }

        .rating-label {
            width: 60px;
            font-size: 14px;
        }

        .rating-progress {
            flex: 1;
            height: 8px;
            background: #eee;
            border-radius: 4px;
            overflow: hidden;
        }

        .rating-progress-fill {
            height: 100%;
            background: #ffc107;
        }

        .form-rating {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }

        /* Phần bình luận */
        .comments-section {
            margin-top: 30px;
            border-top: 1px solid #eee;
            padding-top: 20px;
        }

        .comment-list {
            max-height: 400px;
            overflow-y: auto;
            margin-bottom: 20px;
        }

        .comment-item {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            gap: 12px;
        }

        .comment-item:last-child {
            border-bottom: none;
        }

        .comment-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            flex-shrink: 0;
        }

        .comment-content {
            flex: 1;
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
        }

        .comment-author {
            font-weight: 600;
            color: #2c3e50;
        }

        .comment-time {
            font-size: 12px;
            color: var(--gray);
        }

        .comment-text {
            margin-bottom: 8px;
            line-height: 1.5;
        }

        .comment-actions {
            display: flex;
            gap: 10px;
        }

        .comment-action-btn {
            background: none;
            border: none;
            color: var(--gray);
            font-size: 12px;
            cursor: pointer;
        }

        .comment-form {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
        }

        /* Timeline cho lịch sử hoạt động */
        .activity-timeline {
            position: relative;
            max-width: 900px;
            margin: 0 auto;
            padding: 20px 0;
        }

        .activity-timeline::before {
            content: '';
            position: absolute;
            left: 50px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: var(--primary-light);
            transform: translateX(-50%);
        }

        .timeline-item {
            display: flex;
            margin-bottom: 30px;
            position: relative;
        }

        .timeline-dot {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
            z-index: 2;
            flex-shrink: 0;
            margin-right: 20px;
        }

        .timeline-dot.dangsukien {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .timeline-dot.dangky {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .timeline-dot.huy_dang_ky {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .timeline-dot.capnhatsukien {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .timeline-dot.binhluan {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }

        .timeline-dot.danhgia {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }

        .timeline-content {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            flex: 1;
            transition: transform 0.3s ease;
        }

        .timeline-content:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.12);
        }

        .timeline-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid #f0f0f0;
        }

        .timeline-header h4 {
            margin: 0;
            color: var(--dark);
            font-size: 16px;
            font-weight: 600;
        }

        .timeline-time {
            font-size: 13px;
            color: var(--gray);
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 3px;
        }

        .timeline-body p {
            margin: 0;
            color: #555;
            line-height: 1.5;
        }

        .timeline-body .event-name {
            font-weight: 600;
            color: var(--primary);
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .timeline-body .event-name:hover {
            text-decoration: underline;
        }

        .timeline-body small {
            font-size: 14px;
            color: var(--gray);
            margin-top: 5px;
            display: block;
        }

        /* Suggestion limits alert */
        .suggestion-limits-alert {
            background: #fff8e1;
            border: 2px solid #ffd54f;
            border-radius: 10px;
            margin-bottom: 25px;
            overflow: hidden;
        }

        .alert-content {
            padding: 0;
        }

        .alert-header {
            background: linear-gradient(135deg, #fff8e1 0%, #ffecb3 100%);
            padding: 15px 20px;
            border-bottom: 1px solid #ffd54f;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .alert-header h4 {
            margin: 0;
            color: #5d4037;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .close-alert {
            background: none;
            border: none;
            font-size: 20px;
            color: #5d4037;
            cursor: pointer;
            padding: 0;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
        }

        .close-alert:hover {
            background-color: rgba(0,0,0,0.1);
        }

        .alert-body {
            padding: 20px;
        }

        .limit-item {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
            padding-bottom: 12px;
            border-bottom: 1px dashed #ffd54f;
        }

        .limit-item:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }

        .limit-icon {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            flex-shrink: 0;
            font-size: 16px;
        }

        .limit-icon.info {
            background-color: #bbdefb;
            color: #1976d2;
        }

        .limit-icon.warning {
            background-color: #ffecb3;
            color: #ff8f00;
        }

        .limit-icon.success {
            background-color: #c8e6c9;
            color: #388e3c;
        }

        .limit-icon.error {
            background-color: #ffcdd2;
            color: #d32f2f;
        }

        .limit-content {
            flex: 1;
        }

        .limit-title {
            font-weight: 600;
            color: #5d4037;
            margin-bottom: 4px;
        }

        .limit-desc {
            color: #795548;
            font-size: 14px;
            line-height: 1.4;
        }

        .limit-stats {
            display: flex;
            gap: 15px;
            margin-top: 8px;
        }

        .stat-item {
            background: white;
            padding: 6px 12px;
            border-radius: 6px;
            border: 1px solid #ffd54f;
            font-size: 12px;
            font-weight: 600;
        }

        .stat-item .value {
            color: var(--primary);
        }

        .limit-progress {
            margin-top: 15px;
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
            font-size: 13px;
        }

        .progress-bar {
            height: 8px;
            background: #e0e0e0;
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #4CAF50 0%, #8BC34A 100%);
            border-radius: 4px;
            transition: width 0.5s ease;
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

        .notification-toast.success {
            background-color: var(--success);
        }

        .notification-toast.error {
            background-color: var(--danger);
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
            
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .header-actions {
                width: 100%;
                justify-content: space-between;
            }
            
            .search-container {
                width: 100%;
            }
            
            .filter-row {
                flex-direction: column;
                gap: 10px;
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
            
            .sidebar-detail {
                width: 100%;
                right: -100%;
            }
            
            .notification-dropdown {
                width: 90%;
                right: 5%;
            }
            
            .activity-timeline::before {
                left: 25px;
            }
            
            .timeline-dot {
                width: 40px;
                height: 40px;
                font-size: 16px;
                margin-right: 15px;
            }
            
            .timeline-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 5px;
            }
            
            .timeline-time {
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <!-- Thêm vào phần header hoặc bất kỳ đâu trong HTML -->
    <input type="hidden" id="currentUserId" value="${user.nguoiDungId}">
    
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
                    
                    <!-- Thay đổi phần notification thành dropdown -->
                    <div class="notification-dropdown-wrapper">
                        <div class="notification-trigger" id="notification-trigger">
                            <i class="fas fa-bell"></i>
                            <div class="notification-badge" id="notification-count">
                                <c:out value="${unreadNotificationCount}" default="0"/>
                            </div>
                        </div>
                        <div class="notification-dropdown" id="notification-dropdown">
                            <div class="notification-dropdown-header">
                                <h4>Thông báo mới</h4>
                                <button class="btn-mark-all-read" id="mark-all-read-dropdown">
                                    <i class="fas fa-check-double"></i> Đánh dấu tất cả đã đọc
                                </button>
                            </div>
                            <div class="notification-dropdown-list" id="notification-dropdown-list">
                                <c:choose>
                                    <c:when test="${not empty notifications}">
                                        <c:forEach var="notification" items="${notifications}" begin="0" end="4">
                                            <div class="notification-dropdown-item ${notification.daDoc.intValue() == 0 ? 'unread' : ''}" 
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
                                                    <div class="notification-title">${notification.tieuDe}</div>
                                                    <p>${fn:substring(notification.noiDung, 0, 80)}${fn:length(notification.noiDung) > 80 ? '...' : ''}</p>
                                                    <div class="notification-time">
                                                        <fmt:formatDate value="${notification.thoiGian}" pattern="dd/MM HH:mm"/>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-notifications">
                                            <i class="fas fa-bell-slash"></i>
                                            <p>Không có thông báo mới</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="notification-dropdown-footer">
                                <a href="#" class="view-all-notifications" id="view-all-notifications-dropdown">
                                    <i class="fas fa-list"></i> Xem tất cả thông báo
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- User info với dropdown logout -->
                    <div class="user-info-dropdown">
                        <div class="user-avatar" id="user-avatar-dropdown">
                            <c:if test="${not empty user.hoTen}">
                                <c:out value="${fn:substring(user.hoTen, 0, 1)}${fn:substring(user.hoTen, fn:indexOf(user.hoTen, ' ') + 1, fn:indexOf(user.hoTen, ' ') + 2)}"/>
                            </c:if>
                        </div>
                        <div class="user-dropdown" id="user-dropdown">
                            <div class="user-dropdown-header">
                                <h4><c:out value="${user.hoTen}"/></h4>
                                <p><c:out value="${user.email}"/></p>
                            </div>
                            <div class="user-dropdown-menu">
                                <a href="#" class="dropdown-item" data-target="account">
                                    <i class="fas fa-user-cog"></i> Tài khoản
                                </a>
                                <a href="#" class="dropdown-item" id="logout-dropdown">
                                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                </a>
                            </div>
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

                <!-- == SỰ KIỆN GỢI Ý TỪ MÔ HÌNH ML == -->
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
                                            <span class="status ${fn:toLowerCase(event.trangThaiThoiGian)}">
                                                <c:out value="${event.trangThaiThoiGian}"/>
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
                <!-- == KẾT THÚC PHẦN GỢI Ý AI == -->
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

            <!-- Sidebar chi tiết sự kiện với bình luận -->
            <div class="sidebar-detail" id="event-detail-sidebar">
                <div class="sidebar-detail-header">
                    <h3>Chi tiết sự kiện</h3>
                    <button class="close-sidebar">&times;</button>
                </div>
                
                <div class="sidebar-detail-content">
                    <div id="sidebar-event-content">
                        <!-- Nội dung sự kiện sẽ được load ở đây -->
                    </div>
                    
                    <!-- Phần đánh giá -->
                    <div class="rating-section">
                        <div class="event-detail-section">
                            <h4><i class="fas fa-star"></i> Đánh giá</h4>
                            <div id="rating-overview" class="rating-overview">
                                <!-- Tổng quan đánh giá -->
                            </div>
                            
                            <!-- Form đánh giá của user -->
                            <div id="user-rating-form" style="display: none;">
                                <div class="form-rating">
                                    <label>Đánh giá của bạn:</label>
                                    <div class="rating-stars" id="rating-input">
                                        <span class="star" data-value="1"><i class="fas fa-star"></i></span>
                                        <span class="star" data-value="2"><i class="fas fa-star"></i></span>
                                        <span class="star" data-value="3"><i class="fas fa-star"></i></span>
                                        <span class="star" data-value="4"><i class="fas fa-star"></i></span>
                                        <span class="star" data-value="5"><i class="fas fa-star"></i></span>
                                    </div>
                                    <span id="rating-text">Chưa đánh giá</span>
                                </div>
                                <button class="btn btn-primary btn-sm" id="submit-rating">Gửi đánh giá</button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Phần bình luận -->
                    <div class="comments-section">
                        <div class="event-detail-section">
                            <h4><i class="fas fa-comments"></i> Bình luận</h4>
                            <div class="comment-list" id="comment-list">
                                <!-- Danh sách bình luận -->
                            </div>
                            
                            <!-- Form bình luận -->
                            <div class="comment-form">
                                <div class="form-group">
                                    <textarea id="new-comment" placeholder="Viết bình luận của bạn..." rows="3" style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ddd;"></textarea>
                                </div>
                                <div class="form-group">
                                    <button class="btn btn-primary" id="submit-comment">
                                        <i class="fas fa-paper-plane"></i> Gửi bình luận
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
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
                                    <td><c:out value="${registration.event.tenSuKien}"/></td>
                                    <td>
                                        <fmt:formatDate value="${registration.event.thoiGianBatDau}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td><c:out value="${registration.event.diaDiem}"/></td>
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
                        <button class="btn btn-outline" id="mark-all-read">
                            <i class="fas fa-check-double"></i> Đánh dấu đã đọc tất cả
                        </button>
                    </div>
                </div>
                <!--
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
                -->
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
                                    <!--
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
                                    -->
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
                    <button class="btn btn-outline" id="check-suggestion-limits">
                        <i class="fas fa-info-circle"></i> Kiểm tra giới hạn
                    </button>
                </div>

                <!-- Thông tin lưu ý -->
                <div class="suggestion-limits-alert" id="suggestion-limits-alert" style="display: none;">
                    <div class="alert-content">
                        <div class="alert-header">
                            <h4><i class="fas fa-exclamation-triangle"></i> Thông tin lưu ý khi đề xuất</h4>
                            <button class="close-alert">&times;</button>
                        </div>
                        <div class="alert-body" id="limits-info">
                            <!-- Nội dung sẽ được load bằng JavaScript -->
                        </div>
                    </div>
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
                    <div class="filter-buttons">
                        <button class="btn btn-outline btn-sm active" data-filter="all">Tất cả</button>
                        <button class="btn btn-outline btn-sm" data-filter="dangky">Đăng ký</button>
                        <button class="btn btn-outline btn-sm" data-filter="sukien">Sự kiện</button>
                        <button class="btn btn-outline btn-sm" data-filter="de-xuat">Đề xuất</button>
                    </div>
                </div>

                <div class="activity-timeline" id="activity-timeline">
                    <c:forEach var="history" items="${histories}">
                        <div class="timeline-item ${history.loaiHoatDong.toLowerCase()}" data-type="${history.loaiHoatDong}">
                            <div class="timeline-dot ${history.loaiHoatDong.toLowerCase()}">
                                <c:choose>
                                    <c:when test="${history.loaiHoatDong == 'DangSuKien'}">
                                        <i class="fas fa-lightbulb"></i>
                                    </c:when>
                                    <c:when test="${history.loaiHoatDong == 'DangKy'}">
                                        <i class="fas fa-ticket-alt"></i>
                                    </c:when>
                                    <c:when test="${history.loaiHoatDong == 'HuyDangKy'}">
                                        <i class="fas fa-times-circle"></i>
                                    </c:when>
                                    <c:when test="${history.loaiHoatDong == 'CapNhatSuKien'}">
                                        <i class="fas fa-edit"></i>
                                    </c:when>
                                    <c:when test="${history.loaiHoatDong == 'BinhLuan'}">
                                        <i class="fas fa-comment"></i>
                                    </c:when>
                                    <c:when test="${history.loaiHoatDong == 'DanhGia'}">
                                        <i class="fas fa-star"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-history"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-header">
                                    <h4>
                                        <c:choose>
                                            <c:when test="${history.loaiHoatDong == 'DangSuKien'}">
                                                Đã đề xuất sự kiện
                                            </c:when>
                                            <c:when test="${history.loaiHoatDong == 'DangKy'}">
                                                Đã đăng ký sự kiện
                                            </c:when>
                                            <c:when test="${history.loaiHoatDong == 'HuyDangKy'}">
                                                Đã hủy đăng ký
                                            </c:when>
                                            <c:when test="${history.loaiHoatDong == 'CapNhatSuKien'}">
                                                Đã cập nhật sự kiện
                                            </c:when>
                                            <c:when test="${history.loaiHoatDong == 'BinhLuan'}">
                                                Đã bình luận
                                            </c:when>
                                            <c:when test="${history.loaiHoatDong == 'DanhGia'}">
                                                Đã đánh giá
                                            </c:when>
                                            <c:otherwise>
                                                Hoạt động khác
                                            </c:otherwise>
                                        </c:choose>
                                    </h4>
                                    <span class="timeline-time">
                                        <fmt:formatDate value="${history.thoiGian}" pattern="HH:mm"/>
                                        <fmt:formatDate value="${history.thoiGian}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </div>
                                <div class="timeline-body">
                                    <p>
                                        <c:choose>
                                            <c:when test="${history.suKienId != null}">
                                                <!-- Thêm JavaScript để load tên sự kiện -->
                                                <span class="event-name" data-event-id="${history.suKienId}">
                                                    <i class="fas fa-spinner fa-spin"></i> Đang tải tên sự kiện...
                                                </span>
                                                <br>
                                                <small>${history.chiTiet}</small>
                                            </c:when>
                                            <c:otherwise>
                                                ${history.chiTiet}
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
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
                                <!--
                                <button type="button" class="btn btn-outline" id="change-avatar">
                                    <i class="fas fa-camera"></i> Thay đổi ảnh
                                </button>
                                -->
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
        if ($('#toast-container').length == 0) {
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

        // Đóng sidebar khi đóng modal
        $('.close-modal').click(function() {
            $('.modal').css('display', 'none');
            $('#event-detail-sidebar').removeClass('open');
        });

        // Cũng đóng sidebar khi click ra ngoài modal
        $(window).click(function(e) {
            if ($(e.target).hasClass('modal')) {
                $('.modal').css('display', 'none');
                $('#event-detail-sidebar').removeClass('open');
            }
        });

        // Đóng sidebar khi click nút đóng sidebar
        $('.close-sidebar').click(function() {
            $('#event-detail-sidebar').removeClass('open');
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
                    
                    const trangThaiText = statusMap[event.trangThaiThoiGian] || event.trangThaiThoiGian || 'Không xác định';

                    const html = 
                        '<div class="event-image" style="margin-bottom: 20px;">' +
                            '<img src="' + (event.anhBia || '/default-image.jpg') + '" alt="' + event.tenSuKien + '" style="width:100%; max-height: 300px; object-fit: cover; border-radius:8px;">' +
                        '</div>' +
                        '<h4 style="margin-bottom: 15px; color: #2c3e50;">' + event.tenSuKien + '</h4>' +
                        '<div class="event-meta" style="margin-bottom: 15px; color: #7f8c8d; display: flex; flex-direction: column; gap: 8px;">' +
                            '<span><i class="far fa-calendar"></i> ' + (event.thoiGianBatDau) + '</span>' +
                            '<span><i class="fas fa-map-marker-alt"></i> ' + (event.diaDiem || 'Chưa xác định') + '</span>' +
                            '<span><i class="fas fa-users"></i> ' + (event.soLuongDaDangKy || 0) + '/' + event.soLuongToiDa + ' người</span>' +
                        '</div>' +
                        '<p style="margin-bottom: 20px; line-height: 1.6; white-space: pre-wrap;">' + (event.moTa || 'Không có mô tả') + '</p>' +
                        '<div style="display: flex; gap: 20px; margin-bottom: 20px;">' +
                            '<div>' +
                                '<label style="font-weight: 600; color: #555;">Trạng thái:</label>' +
                                '<span class="status ' + (event.trangThaiThoiGian ? event.trangThaiThoiGian.toLowerCase() : '') + '" style="margin-left: 8px;">' + trangThaiText + '</span>' +
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
            const $row = $(this).closest('tr');
            
            if (confirm('Bạn có chắc muốn hủy đăng ký sự kiện "' + eventName + '"?')) {
                $.ajax({
                    url: '/participant/api/cancel-registration',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ dangKyId: dangKyId }),
                    success: function(res) {
                        if (res.success) {
                            showToast(res.message, true);
                            
                            // Hiệu ứng mờ dần và xóa hàng
                            $row.fadeOut(500, function() {
                                $(this).remove();
                                
                                // Kiểm tra nếu không còn sự kiện nào
                                if ($('#my-events-table tbody tr').length === 0) {
                                    $('#my-events-table tbody').html(
                                        '<tr><td colspan="5" style="text-align: center; padding: 40px; color: var(--gray);">' +
                                        '<i class="fas fa-calendar-times" style="font-size: 48px; margin-bottom: 15px;"></i>' +
                                        '<h3>Chưa có sự kiện nào</h3>' +
                                        '<p>Bạn chưa đăng ký tham gia sự kiện nào.</p>' +
                                        '</td></tr>'
                                    );
                                }
                                
                                // Cập nhật thống kê
                                updateDashboardStats();
                            });
                        } else {
                            showToast(res.message, false);
                        }
                    },
                    error: function(xhr, status, error) {
                        let errorMessage = 'Hủy đăng ký thất bại';
                        if (xhr.responseJSON && xhr.responseJSON.message) {
                            errorMessage = xhr.responseJSON.message;
                        }
                        showToast(errorMessage, false);
                    }
                });
            }
        });

        // Hàm cập nhật thống kê dashboard
        function updateDashboardStats() {
            const userId = $('#currentUserId').val();
            if (!userId) return;
            
            $.get('/participant/api/dashboard-stats', function(stats) {
                if (stats) {
                    $('#events-attended').text(stats.eventsAttended || 0);
                    $('#upcoming-events').text(stats.upcomingEvents || 0);
                    $('#pending-events').text(stats.pendingEvents || 0);
                }
            });
        }
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
                                '<span>' + (suggestion.thoiGianDuKien) + '</span>' +
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
                                '<span>' + (suggestion.thoiGianTao) + '</span>' +
                            '</div>';

                    if (suggestion.thoiGianPhanHoi) {
                        html += 
                            '<div class="detail-row">' +
                                '<label><strong>Thời gian phản hồi:</strong></label>' +
                                '<span>' + (suggestion.thoiGianPhanHoi) + '</span>' +
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
                                        (notification.thoiGian) + 
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
            
            if (events.length == 0) {
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
                                '<span class="status ' + (event.trangThaiThoiGian ? event.trangThaiThoiGian.toLowerCase().replace(' ', '-') : '') + '">' + 
                                    event.trangThaiThoiGian + 
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
                if (e.which == 13) {
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
            if (password.length == 0) {
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


        // Xử lý form cập nhật thông tin tài khoản
$('#account-form').submit(function(e) {
    e.preventDefault();
    
    const submitBtn = $('#save-account');
    submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Đang lưu...');
    
    // Lấy dữ liệu từ form
    const firstName = $('#first-name').val().trim();
    const lastName = $('#last-name').val().trim();
    const email = $('#user-email').val().trim();
    const phone = $('#user-phone').val().trim();
    const address = $('#user-address').val().trim();
    
    // Validation cơ bản
    if (!firstName || !lastName) {
        showToast('Vui lòng nhập đầy đủ họ và tên!', false);
        submitBtn.prop('disabled', false).html('<i class="fas fa-save"></i> Lưu thay đổi');
        return;
    }
    
    if (!email) {
        showToast('Vui lòng nhập email!', false);
        submitBtn.prop('disabled', false).html('<i class="fas fa-save"></i> Lưu thay đổi');
        return;
    }
    
    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        showToast('Email không hợp lệ!', false);
        submitBtn.prop('disabled', false).html('<i class="fas fa-save"></i> Lưu thay đổi');
        return;
    }
    
    if (!phone) {
        showToast('Vui lòng nhập số điện thoại!', false);
        submitBtn.prop('disabled', false).html('<i class="fas fa-save"></i> Lưu thay đổi');
        return;
    }
    
    // Validate phone number (basic)
    const phoneRegex = /^[0-9]{10,11}$/;
    if (!phoneRegex.test(phone.replace(/\D/g, ''))) {
        showToast('Số điện thoại không hợp lệ!', false);
        submitBtn.prop('disabled', false).html('<i class="fas fa-save"></i> Lưu thay đổi');
        return;
    }
    
    // Tạo object user để gửi lên server
    const userData = {
        hoTen: firstName + ' ' + lastName,
        email: email,
        soDienThoai: phone,
        diaChi: address,
        nguoiDungId: $('#currentUserId').val() // Lấy từ biến ẩn
    };
    
    console.log('Sending user data:', userData);
    
    // Gửi request đến API cập nhật
    $.ajax({
        url: '/participant/api/account/update',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(userData),
        success: function(response) {
            if (response.success) {
                showToast('Cập nhật thông tin thành công!', true);
                
                // Cập nhật thông tin hiển thị trên giao diện
                updateUserDisplayInfo(userData);
                
                // Đổi avatar hiển thị nếu cần
                updateAvatarDisplay(userData.hoTen);
                
            } else {
                showToast('Cập nhật thất bại: ' + (response.message || 'Lỗi không xác định'), false);
            }
        },
        error: function(xhr, status, error) {
            console.error('Update error:', error);
            let errorMessage = 'Lỗi kết nối đến server';
            
            if (xhr.responseJSON && xhr.responseJSON.message) {
                errorMessage = xhr.responseJSON.message;
            } else if (xhr.status == 401) {
                errorMessage = 'Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại';
                setTimeout(() => {
                    window.location.href = '/login';
                }, 2000);
            }
            
            showToast('Cập nhật thất bại: ' + errorMessage, false);
        },
        complete: function() {
            submitBtn.prop('disabled', false).html('<i class="fas fa-save"></i> Lưu thay đổi');
        }
    });
});

// Hàm lấy userId từ session (giả lập)
function getCurrentUserId() {
    // Trong thực tế, bạn có thể lấy từ:
    // 1. Biến ẩn trong JSP
    // 2. LocalStorage
    // 3. Attribute trong session
    
    // Cách 1: Từ biến ẩn trong JSP (thêm vào HTML)
    // <input type="hidden" id="currentUserId" value="${user.nguoiDungId}">
    
    if ($('#currentUserId').length) {
        return $('#currentUserId').val();
    }
    
    // Cách 2: Từ attribute trong element
    const userInfo = $('#user-avatar').data('user-id');
    if (userInfo) {
        return userInfo;
    }
    
    // Fallback: lấy từ URL hoặc giả lập
    return window.currentUserId || 0;
}

// Hàm cập nhật thông tin hiển thị
function updateUserDisplayInfo(userData) {
    // Cập nhật tên trong header
    $('#user-name').text(userData.hoTen);
    
    // Cập nhật email (nếu có phần hiển thị email)
    $('#user-email-display').text(userData.email);
    
    // Cập nhật thông tin trong các phần khác nếu cần
    console.log('Updated user info on display');
}

// Hàm cập nhật avatar hiển thị
function updateAvatarDisplay(fullName) {
    const avatarElement = $('#user-avatar, #account-avatar');
    
    // Tạo chữ cái đầu từ họ tên
    const names = fullName.split(' ');
    let initials = '';
    
    if (names.length >= 1) {
        initials += names[0].charAt(0).toUpperCase();
    }
    if (names.length >= 2) {
        initials += names[names.length - 1].charAt(0).toUpperCase();
    } else if (names[0].length > 1) {
        initials += names[0].charAt(1).toUpperCase();
    }
    
    // Cập nhật avatar
    avatarElement.each(function() {
        $(this).text(initials);
    });
}

// Xử lý thay đổi ảnh đại diện (nếu có)
$('#change-avatar').click(function(e) {
    e.preventDefault();
    
    // Tạo input file ẩn
    const input = $('<input type="file" accept="image/*" style="display: none;">');
    
    input.on('change', function(e) {
        const file = e.target.files[0];
        if (!file) return;
        
        // Kiểm tra kích thước file (max 5MB)
        if (file.size > 5 * 1024 * 1024) {
            showToast('Kích thước ảnh không được vượt quá 5MB!', false);
            return;
        }
        
        // Kiểm tra định dạng
        const validTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        if (!validTypes.includes(file.type)) {
            showToast('Chỉ chấp nhận file ảnh (JPEG, PNG, GIF, WebP)!', false);
            return;
        }
        
        // Hiển thị preview
        const reader = new FileReader();
        reader.onload = function(e) {
            // Tạo ảnh preview tạm thời
            const img = new Image();
            img.onload = function() {
                // Có thể crop/resize ảnh ở đây nếu cần
                $('#account-avatar').html(
                    '<img src="' + e.target.result + '" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">'
                );
                
                // Gửi ảnh lên server (cần API upload)
                uploadAvatar(file);
            };
            img.src = e.target.result;
        };
        reader.readAsDataURL(file);
    });
    
    input.click();
});

// Hàm upload ảnh đại diện
function uploadAvatar(file) {
    const formData = new FormData();
    formData.append('avatar', file);
    
    $.ajax({
        url: '/participant/api/account/upload-avatar',
        type: 'POST',
        data: formData,
        contentType: false,
        processData: false,
        success: function(response) {
            if (response.success) {
                showToast('Cập nhật ảnh đại diện thành công!', true);
                
                // Cập nhật ảnh ở header nếu có
                $('#user-avatar').html(
                    '<img src="' + response.avatarUrl + '" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">'
                );
            } else {
                showToast('Cập nhật ảnh thất bại: ' + response.message, false);
            }
        },
        error: function() {
            showToast('Lỗi khi tải ảnh lên server', false);
        }
    });
}

// Thêm CSS cho form validation
const accountFormStyles = `
<style>
#account-form .form-group.error input,
#account-form .form-group.error select,
#account-form .form-group.error textarea {
    border-color: var(--danger);
    box-shadow: 0 0 0 3px rgba(244, 67, 54, 0.2);
}

#account-form .error-message {
    color: var(--danger);
    font-size: 13px;
    margin-top: 5px;
    display: none;
}

#account-form .form-group.error .error-message {
    display: block;
}

.avatar-preview {
    position: relative;
    width: 120px;
    height: 120px;
    margin: 0 auto 20px;
}

.avatar-preview img {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid white;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

.avatar-upload-btn {
    position: absolute;
    bottom: 5px;
    right: 5px;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: var(--primary);
    color: white;
    border: 2px solid white;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
}

.avatar-upload-btn:hover {
    background: #43A047;
    transform: scale(1.1);
}
</style>
`;

// Thêm CSS vào document
$(accountFormStyles).appendTo('head');


// Xử lý đăng xuất
$('#logout-btn').click(function(e) {
    e.preventDefault();
    if (confirm('Bạn có chắc muốn đăng xuất?')) {
        $.ajax({
            url: '/participant/api/logout',
            type: 'POST',
            success: function(response) {
                if (response.success) {
                    showToast('Đăng xuất thành công!', true);
                    setTimeout(() => {
                        window.location.href = '/login';
                    }, 1500);
                } else {
                    showToast('Đăng xuất thất bại: ' + response.message, false);
                }
            },
            error: function() {
                showToast('Lỗi kết nối khi đăng xuất', false);
            }
        });
    }
});



// Biến lưu trữ sự kiện hiện tại
let currentEventId = null;
let userRating = 0;

// Mở sidebar chi tiết sự kiện
function openEventDetailSidebar(eventId) {
    currentEventId = eventId;
    
    // Load chi tiết sự kiện
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
            
            const statusMap = {
                'DangDienRa': 'Đang diễn ra',
                'SapDienRa': 'Sắp diễn ra', 
                'DaKetThuc': 'Đã kết thúc'
            };
            
            const trangThaiText = statusMap[event.trangThaiThoiGian] || event.trangThaiThoiGian || 'Không xác định';
            
            var html =
    '<div class="event-detail-section">' +
        '<div class="event-image" style="margin-bottom: 15px;">' +
            '<img src="' + (event.anhBia ? event.anhBia : '/default-image.jpg') + '" ' +
                 'alt="' + (event.tenSuKien ? event.tenSuKien : 'Sự kiện') + '" ' +
                 'style="width:100%; height:200px; object-fit: cover; border-radius:8px;">' +
        '</div>' +

        '<h4 style="margin-bottom: 10px; color: #2c3e50;">' +
            (event.tenSuKien ? event.tenSuKien : '') +
        '</h4>' +

        '<div class="event-meta" ' +
             'style="margin-bottom: 15px; color: #7f8c8d; display: flex; flex-direction: column; gap: 8px;">' +

            '<span><i class="far fa-calendar"></i> ' +
                (event.thoiGianBatDau ? event.thoiGianBatDau : '') +
            '</span>' +

            '<span><i class="fas fa-map-marker-alt"></i> ' +
                (event.diaDiem ? event.diaDiem : '') +
            '</span>' +

            '<span><i class="fas fa-users"></i> ' +
                (event.soLuongDaDangKy ? event.soLuongDaDangKy : 0) +
                '/' +
                (event.soLuongToiDa ? event.soLuongToiDa : 0) +
                ' người</span>' +

            '<span><i class="fas fa-tag"></i> ' +
                (event.loaiSuKien === 'RiengTu' ? 'Riêng tư' : 'Công khai') +
            '</span>' +
        '</div>' +

        '<p style="line-height: 1.6; white-space: pre-wrap;">' +
            (event.moTa ? event.moTa : '') +
        '</p>' +
    '</div>';

            
            $('#sidebar-event-content').html(html);
            
            // Load đánh giá
            loadEventRatings(eventId);
            
            // Load bình luận
            loadEventComments(eventId);
            
            // Hiển thị sidebar
            $('#event-detail-sidebar').addClass('open');
        })
        .fail(function() {
            showToast('Không tải được thông tin sự kiện', false);
        });
}

// Load đánh giá
function loadEventRatings(eventId) {
    $.get('/participant/api/events/' + eventId + '/ratings')
        .done(function(ratings) {
            updateRatingUI(ratings);
        })
        .fail(function() {
            console.log('Không tải được đánh giá');
        });
}

// Load bình luận
function loadEventComments(eventId) {
    $.get('/participant/api/events/' + eventId + '/comments')
        .done(function(response) {
            console.log('📦 Response từ API:', response);

            if (response.success) {
                renderComments(response.comments); // ✅ đúng mảng
            } else {
                console.log('❌ API lỗi:', response.message);
            }
        })
        .fail(function() {
            console.log('Không tải được bình luận');
        });
}


// Cập nhật UI đánh giá
function updateRatingUI(ratings) {

    var average = ratings.average ? ratings.average : 0;
    var total = ratings.total ? ratings.total : 0;
    var userHasRated = ratings.userRating && ratings.userRating > 0;
    var distribution = ratings.distribution ? ratings.distribution : [0,0,0,0,0];

    /* =======================
       Sao trung bình
    ======================= */
    var starsHtml = '';
    for (var i = 1; i <= 5; i++) {
        starsHtml +=
            '<span class="star ' + (i <= Math.round(average) ? 'active' : '') + '">' +
                '<i class="fas fa-star"></i>' +
            '</span>';
    }

    /* =======================
       Phân phối đánh giá
    ======================= */
    var distributionHtml = '';
    for (var j = 5; j >= 1; j--) {
        var count = distribution[j - 1] ? distribution[j - 1] : 0;
        var percentage = total > 0 ? (count / total * 100) : 0;

        distributionHtml +=
            '<div class="rating-bar">' +
                '<div class="rating-label">' + j + ' sao</div>' +
                '<div class="rating-progress">' +
                    '<div class="rating-progress-fill" style="width: ' + percentage + '%"></div>' +
                '</div>' +
                '<div style="width: 40px; text-align: right; font-size: 12px;">' +
                    count +
                '</div>' +
            '</div>';
    }

    /* =======================
       Render tổng quan
    ======================= */
    $('#rating-overview').html(
        '<div class="average-rating">' +
            '<div class="rating-number">' + average.toFixed(1) + '</div>' +
            '<div class="rating-stars">' +
                starsHtml +
            '</div>' +
            '<div style="font-size: 12px; color: var(--gray); margin-top: 5px;">' +
                total + ' đánh giá' +
            '</div>' +
        '</div>' +
        '<div class="rating-distribution">' +
            distributionHtml +
        '</div>'
    );

    /* =======================
       Form đánh giá user
    ======================= */
    if (userHasRated) {
        userRating = ratings.userRating;
        updateRatingInput();
    }

    $('#user-rating-form').show();
}


// Cập nhật input đánh giá
function updateRatingInput() {
    $('#rating-input .star').each(function() {
        const value = $(this).data('value');
        $(this).toggleClass('active', value <= userRating);
    });
    $('#rating-text').text(userRating > 0 ? `${userRating} sao` : 'Chưa đánh giá');
}

// Xử lý click đóng sidebar
$('.close-sidebar').click(function() {
    $('#event-detail-sidebar').removeClass('open');
});

// Xử lý click sao đánh giá
$(document).on('mouseenter', '#rating-input .star', function() {
    const value = $(this).data('value');
    $('#rating-input .star').each(function() {
        const starValue = $(this).data('value');
        $(this).toggleClass('hover', starValue <= value);
    });
});

$(document).on('mouseleave', '#rating-input', function() {
    $('#rating-input .star').removeClass('hover');
    updateRatingInput();
});

$(document).on('click', '#rating-input .star', function() {
    userRating = $(this).data('value');
    updateRatingInput();
});

// Gửi đánh giá
$('#submit-rating').click(function() {
    if (!userRating) {
        showToast('Vui lòng chọn số sao đánh giá', false);
        return;
    }
    
    $.ajax({
        url: '/participant/api/events/' + currentEventId + '/rate',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ rating: userRating }),
        success: function(response) {
            if (response.success) {
                showToast('Đánh giá thành công!', true);
                loadEventRatings(currentEventId);
            } else {
                showToast('Đánh giá thất bại: ' + response.message, false);
            }
        },
        error: function() {
            showToast('Lỗi khi gửi đánh giá', false);
        }
    });
});

// Gửi bình luận
$('#submit-comment').click(function() {
    const commentText = $('#new-comment').val().trim();
    
    if (!commentText) {
        showToast('Vui lòng nhập nội dung bình luận', false);
        return;
    }
    
    if (commentText.length > 500) {
        showToast('Bình luận không được vượt quá 500 ký tự', false);
        return;
    }
    
    $.ajax({
        url: '/participant/api/events/' + currentEventId + '/comment',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ content: commentText }),
        success: function(response) {
            if (response.success) {
                showToast('Bình luận đã được gửi!', true);
                $('#new-comment').val('');
                loadEventComments(currentEventId);
            } else {
                showToast('Gửi bình luận thất bại: ' + response.message, false);
            }
        },
        error: function() {
            showToast('Lỗi khi gửi bình luận', false);
        }
    });
});

// Render bình luận
function renderComments(comments) {
    console.log('📌 renderComments:', comments);

    const $commentList = $('#comment-list');
    $commentList.empty();

    /* =======================
       Không có bình luận
    ======================= */
    if (!Array.isArray(comments) || comments.length === 0) {
        $commentList.html(
            '<div class="limit-item">' +
                '<div class="limit-icon error">' +
                    '<i class="fas fa-comment-slash"></i>' +
                '</div>' +
                '<div class="limit-content">' +
                    '<div class="limit-title">Bình luận</div>' +
                    '<div class="limit-desc">' +
                        'Chưa có bình luận nào' +
                    '</div>' +
                '</div>' +
            '</div>'
        );
        return;
    }

    let html = '';

    /* =======================
       Danh sách bình luận
    ======================= */
    comments.forEach(function (comment) {

        var userName = 'Người dùng';
        if (comment.user && comment.user.hoTen) {
            userName = comment.user.hoTen;
        }

        var content = comment.noiDung ? comment.noiDung : '';

        var time = '';
        if (comment.thoiGianTao) {
            time = new Date(comment.thoiGianTao).toLocaleString('vi-VN');
        }

        html +=
            '<div class="limit-item">' +
                '<div class="limit-icon success">' +
                    '<i class="fas fa-comment"></i>' +
                '</div>' +
                '<div class="limit-content">' +
                    '<div class="limit-title">' +
                        userName +
                    '</div>' +
                    '<div class="limit-desc">' +
                        content +
                        '<br>' +
                        '<small style="color:#888">' + time + '</small>' +
                    '</div>' +
                '</div>' +
            '</div>';
    });

    $commentList.html(html);
}



// Sửa các nút xem chi tiết sự kiện để mở sidebar
$(document).on('click', '.btn-view-event, .event-card', function(e) {
    if ($(e.target).closest('.btn-join-event').length) {
        return;
    }
    const eventId = $(this).data('event-id');
    openEventDetailSidebar(eventId);
});


// Trong phần JavaScript, thêm hàm để load tên sự kiện
function loadEventNamesForHistory() {
    $('.event-name').each(function() {
        const $element = $(this);
        const eventId = $element.data('event-id');
        
        if (eventId) {
            $.get('/participant/api/events/' + eventId + '/name')
                .done(function(event) {
                    if (event && event.tenSuKien) {
                        $element.html(`
                            <i class="fas fa-calendar-alt"></i>
                            ${event.tenSuKien}
                        `);
                        $element.attr('title', 'Click để xem chi tiết sự kiện');
                        $element.click(function(e) {
                            e.preventDefault();
                            viewEventDetail(eventId);
                        });
                    }
                })
                .fail(function() {
                    $element.html('<i class="fas fa-calendar-times"></i> Không tìm thấy sự kiện');
                });
        }
    });
}

// Gọi hàm khi vào trang lịch sử
$('.menu-link[data-target="history"]').click(function() {
    setTimeout(loadEventNamesForHistory, 500);
});

// Filter lịch sử
$('.filter-buttons button').click(function() {
    const filter = $(this).data('filter');
    $('.filter-buttons button').removeClass('active');
    $(this).addClass('active');
    
    if (filter === 'all') {
        $('.timeline-item').show();
    } else {
        $('.timeline-item').hide();
        $('.timeline-item[data-type*="' + filter + '"]').show();
    }
});


// Notification dropdown
$('#notification-trigger').click(function(e) {
    e.stopPropagation();
    $('#notification-dropdown').toggleClass('show');
    $('#user-dropdown').removeClass('show');
    
    // Tạo overlay nếu chưa có
    if ($('.dropdown-overlay').length === 0) {
        $('body').append('<div class="dropdown-overlay"></div>');
    }
    $('.dropdown-overlay').show();
});

// User dropdown
$('#user-avatar-dropdown').click(function(e) {
    e.stopPropagation();
    $('#user-dropdown').toggleClass('show');
    $('#notification-dropdown').removeClass('show');
    
    if ($('.dropdown-overlay').length === 0) {
        $('body').append('<div class="dropdown-overlay"></div>');
    }
    $('.dropdown-overlay').show();
});

// Close dropdowns when clicking outside
$(document).on('click', '.dropdown-overlay', function() {
    $('#notification-dropdown').removeClass('show');
    $('#user-dropdown').removeClass('show');
    $('.dropdown-overlay').hide();
});

// Mark all as read in dropdown
$('#mark-all-read-dropdown').click(function(e) {
    e.preventDefault();
    e.stopPropagation();
    
    $.post('/participant/api/notifications/mark-all-read')
        .done(function() {
            showToast('Đã đánh dấu tất cả thông báo đã đọc!', true);
            $('#notification-count').text('0');
            $('.notification-dropdown-item').removeClass('unread');
        })
        .fail(function() {
            showToast('Đánh dấu đã đọc thất bại!', false);
        });
});

// View all notifications
$('#view-all-notifications-dropdown').click(function(e) {
    e.preventDefault();
    e.stopPropagation();
    
    // Chuyển đến trang dashboard và mở modal thông báo
    $('.menu-link[data-target="dashboard"]').click();
    $('#notification-dropdown').removeClass('show');
    $('.dropdown-overlay').hide();
});

// Logout from dropdown
$('#logout-dropdown').click(function(e) {
    e.preventDefault();
    e.stopPropagation();
    
    if (confirm('Bạn có chắc muốn đăng xuất?')) {
        $.ajax({
            url: '/participant/api/logout',
            type: 'POST',
            success: function(response) {
                if (response.success) {
                    showToast('Đăng xuất thành công!', true);
                    setTimeout(() => {
                        window.location.href = '/login';
                    }, 1500);
                } else {
                    showToast('Đăng xuất thất bại: ' + response.message, false);
                }
            },
            error: function() {
                showToast('Lỗi kết nối khi đăng xuất', false);
            }
        });
    }
});

// Navigate to account from dropdown
$('.dropdown-item[data-target="account"]').click(function(e) {
    e.preventDefault();
    e.stopPropagation();
    
    $('.menu-link[data-target="account"]').click();
    $('#user-dropdown').removeClass('show');
    $('.dropdown-overlay').hide();
});



// Check suggestion limits
$('#check-suggestion-limits').click(function(e) {
    e.preventDefault();
    
    $.get('/participant/api/suggestions/check-limit')
        .done(function(response) {
            if (response.success) {
                const data = response.data;
                displaySuggestionLimits(data);
            } else {
                showToast('Không thể kiểm tra giới hạn: ' + response.message, false);
            }
        })
        .fail(function() {
            showToast('Lỗi kết nối khi kiểm tra giới hạn', false);
        });
});

function displaySuggestionLimits(data) {
    const $alert = $('#suggestion-limits-alert');
    const $content = $('#limits-info');

    let html = '';

    /* =======================
       Giới hạn chờ duyệt
    ======================= */
    const pendingCount = data.pendingCount || 0;
    const maxPending = data.maxPending || 3;
    const pendingPercentage = (pendingCount / maxPending) * 100;
    const pendingStatus = pendingCount < maxPending ? 'Có thể gửi' : 'Đã đạt giới hạn';

    html +=
        '<div class="limit-item">' +
            '<div class="limit-icon ' + (pendingCount < maxPending ? 'success' : 'error') + '">' +
                '<i class="fas fa-clock"></i>' +
            '</div>' +
            '<div class="limit-content">' +
                '<div class="limit-title">Giới hạn đề xuất đang chờ duyệt</div>' +
                '<div class="limit-desc">' +
                    'Bạn có thể gửi tối đa ' + maxPending + ' đề xuất đang chờ duyệt cùng lúc. ' +
                    'Hiện tại: ' + pendingCount + '/' + maxPending + ' đề xuất đang chờ.' +
                '</div>' +
                '<div class="limit-progress">' +
                    '<div class="progress-label">' +
                        '<span>' + pendingStatus + '</span>' +
                        '<span>' + pendingCount + '/' + maxPending + '</span>' +
                    '</div>' +
                    '<div class="progress-bar">' +
                        '<div class="progress-fill" style="width: ' + pendingPercentage + '%"></div>' +
                    '</div>' +
                '</div>' +
            '</div>' +
        '</div>';

    /* =======================
       Giới hạn thời gian
    ======================= */
    if (data.lastSuggestionDate) {
        const lastDate = new Date(data.lastSuggestionDate);
        const now = new Date();
        const hoursDiff = Math.floor((now - lastDate) / (1000 * 60 * 60));
        const canSubmitTime = hoursDiff >= 24;

        html +=
            '<div class="limit-item">' +
                '<div class="limit-icon ' + (canSubmitTime ? 'success' : 'warning') + '">' +
                    '<i class="fas fa-hourglass-half"></i>' +
                '</div>' +
                '<div class="limit-content">' +
                    '<div class="limit-title">Thời gian giữa các đề xuất</div>' +
                    '<div class="limit-desc">' +
                        'Cần chờ ít nhất 24 giờ sau đề xuất trước để gửi đề xuất mới. ' +
                        (canSubmitTime
                            ? 'Bạn có thể gửi đề xuất mới.'
                            : 'Cần chờ thêm ' + (24 - hoursDiff) + ' giờ nữa.'
                        ) +
                    '</div>' +
                    '<div class="limit-stats">' +
                        '<div class="stat-item">' +
                            '<span class="label">Lần cuối:</span>' +
                            '<span class="value">' + lastDate.toLocaleDateString('vi-VN') + '</span>' +
                        '</div>' +
                        '<div class="stat-item">' +
                            '<span class="label">Đã qua:</span>' +
                            '<span class="value">' + hoursDiff + ' giờ</span>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
            '</div>';
    }

    /* =======================
       Giới hạn hàng tháng
    ======================= */
    const monthlyCount = data.monthlyCount || 0;
    const maxMonthly = 10;
    const monthlyPercentage = (monthlyCount / maxMonthly) * 100;

    html +=
        '<div class="limit-item">' +
            '<div class="limit-icon ' + (monthlyCount < maxMonthly ? 'success' : 'error') + '">' +
                '<i class="fas fa-calendar-alt"></i>' +
            '</div>' +
            '<div class="limit-content">' +
                '<div class="limit-title">Giới hạn đề xuất hàng tháng</div>' +
                '<div class="limit-desc">' +
                    'Bạn có thể gửi tối đa ' + maxMonthly + ' đề xuất trong một tháng. ' +
                    'Tháng này: ' + monthlyCount + '/' + maxMonthly + ' đề xuất.' +
                '</div>' +
                '<div class="limit-progress">' +
                    '<div class="progress-label">' +
                        '<span>' +
                            (monthlyCount < maxMonthly
                                ? 'Còn ' + (maxMonthly - monthlyCount) + ' đề xuất'
                                : 'Đã đạt giới hạn'
                            ) +
                        '</span>' +
                        '<span>' + monthlyCount + '/' + maxMonthly + '</span>' +
                    '</div>' +
                    '<div class="progress-bar">' +
                        '<div class="progress-fill" style="width: ' + monthlyPercentage + '%"></div>' +
                    '</div>' +
                '</div>' +
            '</div>' +
        '</div>';

    /* =======================
       Thông báo lỗi
    ======================= */
    if (data.errors && data.errors.length > 0) {
        html +=
            '<div class="limit-item">' +
                '<div class="limit-icon error">' +
                    '<i class="fas fa-exclamation-circle"></i>' +
                '</div>' +
                '<div class="limit-content">' +
                    '<div class="limit-title">Cảnh báo</div>' +
                    '<div class="limit-desc">' +
                        data.errors.join('<br>') +
                    '</div>' +
                '</div>' +
            '</div>';
    }

    /* =======================
       Tóm tắt
    ======================= */
    const canSubmit = data.canSubmit === true;

    html +=
        '<div class="limit-item" style="background: ' + (canSubmit ? '#e8f5e9' : '#ffebee') +
        '; padding: 15px; border-radius: 8px; margin-top: 15px;">' +
            '<div class="limit-icon ' + (canSubmit ? 'success' : 'error') + '">' +
                '<i class="fas ' + (canSubmit ? 'fa-check-circle' : 'fa-times-circle') + '"></i>' +
            '</div>' +
            '<div class="limit-content">' +
                '<div class="limit-title">' +
                    (canSubmit ? 'CÓ THỂ GỬI ĐỀ XUẤT' : 'KHÔNG THỂ GỬI ĐỀ XUẤT') +
                '</div>' +
                '<div class="limit-desc">' +
                    (canSubmit
                        ? 'Bạn đủ điều kiện để gửi đề xuất sự kiện mới.'
                        : 'Bạn không đủ điều kiện để gửi đề xuất mới. Vui lòng kiểm tra các giới hạn trên.'
                    ) +
                '</div>' +
            '</div>' +
        '</div>';

    $content.html(html);
    $alert.show();
}


// Close alert
$('.close-alert').click(function() {
    $('#suggestion-limits-alert').hide();
});

// Tự động kiểm tra khi vào trang suggestions
$('.menu-link[data-target="suggestions"]').click(function() {
    setTimeout(function() {
        $.get('/participant/api/suggestions/check-limit')
            .done(function(response) {
                if (response.success && !response.data.canSubmit) {
                    displaySuggestionLimits(response.data);
                }
            });
    }, 500);
});

// Logout from dropdown (đã thêm ở phần 2)
$('#logout-dropdown').click(function(e) {
    e.preventDefault();
    e.stopPropagation();
    
    if (confirm('Bạn có chắc muốn đăng xuất?')) {
        $.ajax({
            url: '/participant/api/logout',
            type: 'POST',
            success: function(response) {
                if (response.success) {
                    showToast('Đăng xuất thành công!', true);
                    setTimeout(() => {
                        window.location.href = '/login';
                    }, 1500);
                } else {
                    showToast('Đăng xuất thất bại: ' + response.message, false);
                }
            },
            error: function() {
                showToast('Lỗi kết nối khi đăng xuất', false);
            }
        });
    }
});

    });    
    </script>
</body>
</html>