<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHub - Quản lý sự kiện thông minh</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <style>
        /* Reset & Base Styles */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

:root {
    --primary-color: #4e54c8;
    --primary-dark: #3a3f9c;
    --secondary-color: #8f94fb;
    --accent-color: #ff6b6b;
    --success-color: #4CAF50;
    --warning-color: #ff9800;
    --danger-color: #f44336;
    --light-color: #f8f9fa;
    --dark-color: #212529;
    --gray-color: #6c757d;
    --gray-light: #e9ecef;
    --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    --transition: all 0.3s ease;
}

body {
    font-family: 'Roboto', sans-serif;
    line-height: 1.6;
    color: var(--dark-color);
    background-color: #fff;
    overflow-x: hidden;
}

.container {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
}

/* Typography */
h1, h2, h3, h4, h5, h6 {
    font-family: 'Poppins', sans-serif;
    font-weight: 600;
    line-height: 1.3;
}

a {
    text-decoration: none;
    color: inherit;
    transition: var(--transition);
}

.btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 10px 24px;
    border-radius: 8px;
    font-weight: 500;
    cursor: pointer;
    transition: var(--transition);
    border: 2px solid transparent;
    gap: 8px;
    font-size: 16px;
}

.btn-primary {
    background-color: var(--primary-color);
    color: white;
    border-color: var(--primary-color);
}

.btn-primary:hover {
    background-color: var(--primary-dark);
    border-color: var(--primary-dark);
    transform: translateY(-2px);
    box-shadow: var(--shadow);
}

.btn-outline {
    background-color: transparent;
    color: var(--primary-color);
    border-color: var(--primary-color);
}

.btn-outline:hover {
    background-color: var(--primary-color);
    color: white;
    transform: translateY(-2px);
    box-shadow: var(--shadow);
}

.btn-large {
    padding: 14px 32px;
    font-size: 18px;
}

/* Header Styles */
.header {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    z-index: 1000;
    background-color: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
    transition: var(--transition);
}

.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 0;
}

.logo {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 24px;
    font-weight: 700;
    color: var(--dark-color);
}

.logo i {
    color: var(--primary-color);
    font-size: 28px;
}

.logo-highlight {
    color: var(--primary-color);
}

.nav-menu {
    display: flex;
    list-style: none;
    gap: 30px;
}

.nav-link {
    color: var(--dark-color);
    font-weight: 500;
    position: relative;
    padding: 8px 0;
}

.nav-link:hover,
.nav-link.active {
    color: var(--primary-color);
}

.nav-link.active::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 3px;
    background-color: var(--primary-color);
    border-radius: 3px;
}

.auth-section {
    display: flex;
    align-items: center;
    gap: 15px;
}

.user-dropdown {
    position: relative;
}

.user-profile {
    display: flex;
    align-items: center;
    gap: 10px;
    background: none;
    border: none;
    cursor: pointer;
    padding: 8px 12px;
    border-radius: 8px;
    transition: var(--transition);
}

.user-profile:hover {
    background-color: var(--gray-light);
}

.user-avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    object-fit: cover;
}

.dropdown-menu {
    position: absolute;
    top: 100%;
    right: 0;
    background: white;
    min-width: 200px;
    border-radius: 8px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
    padding: 10px 0;
    opacity: 0;
    visibility: hidden;
    transform: translateY(10px);
    transition: var(--transition);
    z-index: 1001;
}

.user-dropdown:hover .dropdown-menu {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

.dropdown-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px 20px;
    color: var(--dark-color);
}

.dropdown-item:hover {
    background-color: var(--gray-light);
    color: var(--primary-color);
}

.dropdown-divider {
    height: 1px;
    background-color: var(--gray-light);
    margin: 10px 0;
}

.hamburger {
    display: none;
    flex-direction: column;
    gap: 4px;
    cursor: pointer;
}

.hamburger span {
    width: 25px;
    height: 3px;
    background-color: var(--dark-color);
    border-radius: 2px;
    transition: var(--transition);
}

/* Hero Section */
.hero {
    padding: 160px 0 100px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    position: relative;
    overflow: hidden;
}

.hero::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: url('https://images.unsplash.com/photo-1511578314322-379afb476865?ixlib=rb-4.0.3&auto=format&fit=crop&w=2069&q=80');
    background-size: cover;
    background-position: center;
    opacity: 0.1;
}

.hero-content {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 60px;
    align-items: center;
    position: relative;
    z-index: 1;
}

.hero-title {
    font-size: 48px;
    margin-bottom: 20px;
    color: white;
}

.hero-title .highlight {
    color: #ffd700;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.hero-subtitle {
    font-size: 18px;
    margin-bottom: 30px;
    opacity: 0.9;
    line-height: 1.8;
}

.hero-buttons {
    display: flex;
    gap: 20px;
    margin-bottom: 40px;
}

.hero-stats {
    display: flex;
    gap: 40px;
    margin-top: 30px;
}

.stat-item h3 {
    font-size: 36px;
    color: #ffd700;
    margin-bottom: 5px;
}

.stat-item p {
    font-size: 14px;
    opacity: 0.9;
}

.hero-image {
    position: relative;
}

.hero-img {
    width: 100%;
    border-radius: 20px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
    transform: perspective(1000px) rotateY(-10deg);
    transition: var(--transition);
}

.hero-img:hover {
    transform: perspective(1000px) rotateY(0deg);
}

.floating-card {
    position: absolute;
    background: white;
    padding: 15px 20px;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    display: flex;
    align-items: center;
    gap: 10px;
    color: var(--dark-color);
    animation: float 3s ease-in-out infinite;
}

.floating-card i {
    font-size: 24px;
    color: var(--primary-color);
}

.card1 {
    top: -20px;
    left: -20px;
    animation-delay: 0s;
}

.card2 {
    top: 50%;
    right: -20px;
    animation-delay: 0.5s;
}

.card3 {
    bottom: -20px;
    left: 50%;
    transform: translateX(-50%);
    animation-delay: 1s;
}

@keyframes float {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-10px); }
}

/* Features Section */
.features {
    padding: 100px 0;
    background-color: var(--light-color);
}

.section-header {
    text-align: center;
    margin-bottom: 60px;
}

.section-title {
    font-size: 36px;
    color: var(--dark-color);
    margin-bottom: 15px;
}

.section-subtitle {
    color: var(--gray-color);
    font-size: 18px;
    max-width: 600px;
    margin: 0 auto;
}

.features-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 30px;
}

.feature-card {
    background: white;
    padding: 40px 30px;
    border-radius: 15px;
    box-shadow: var(--shadow);
    transition: var(--transition);
    text-align: center;
}

.feature-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.feature-icon {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 25px;
    font-size: 32px;
}

.feature-icon.participant {
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: white;
}

.feature-icon.organizer {
    background: linear-gradient(135deg, #f093fb, #f5576c);
    color: white;
}

.feature-icon.admin {
    background: linear-gradient(135deg, #4facfe, #00f2fe);
    color: white;
}

.feature-card h3 {
    font-size: 24px;
    margin-bottom: 20px;
    color: var(--dark-color);
}

.feature-list {
    list-style: none;
    text-align: left;
}

.feature-list li {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 12px;
    color: var(--gray-color);
}

.feature-list i {
    color: var(--success-color);
    font-size: 14px;
}

/* Events Section */
.events-preview {
    padding: 100px 0;
    background-color: white;
}

.events-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 30px;
    margin-bottom: 50px;
}

.event-card {
    background: white;
    border-radius: 15px;
    overflow: hidden;
    box-shadow: var(--shadow);
    transition: var(--transition);
}

.event-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.event-image {
    height: 200px;
    overflow: hidden;
}

.event-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: var(--transition);
}

.event-card:hover .event-image img {
    transform: scale(1.1);
}

.event-content {
    padding: 25px;
}

.event-title {
    font-size: 20px;
    margin-bottom: 10px;
    color: var(--dark-color);
}

.event-date {
    display: flex;
    align-items: center;
    gap: 8px;
    color: var(--gray-color);
    margin-bottom: 15px;
    font-size: 14px;
}

.event-description {
    color: var(--gray-color);
    margin-bottom: 20px;
    line-height: 1.6;
}

.event-meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.event-type {
    background-color: var(--primary-color);
    color: white;
    padding: 5px 15px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 500;
}

.event-stats {
    display: flex;
    gap: 15px;
}

.stat {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 14px;
    color: var(--gray-color);
}

.skeleton-event-card {
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: loading 1.5s infinite;
    border-radius: 15px;
    height: 400px;
}

@keyframes loading {
    0% { background-position: 200% 0; }
    100% { background-position: -200% 0; }
}

/* How It Works */
.how-it-works {
    padding: 100px 0;
    background-color: var(--light-color);
}

.steps {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 40px;
    text-align: center;
}

.step {
    position: relative;
}

.step-number {
    position: absolute;
    top: -20px;
    left: 50%;
    transform: translateX(-50%);
    width: 40px;
    height: 40px;
    background-color: var(--primary-color);
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    font-size: 20px;
    z-index: 1;
}

.step-icon {
    width: 100px;
    height: 100px;
    background: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 25px;
    font-size: 40px;
    color: var(--primary-color);
    box-shadow: var(--shadow);
}

.step h3 {
    font-size: 22px;
    margin-bottom: 10px;
    color: var(--dark-color);
}

.step p {
    color: var(--gray-color);
    line-height: 1.6;
}

/* Testimonials */
.testimonials {
    padding: 100px 0;
    background-color: white;
}

.testimonials-slider {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 30px;
}

.testimonial-card {
    background: var(--light-color);
    padding: 30px;
    border-radius: 15px;
    box-shadow: var(--shadow);
}

.testimonial-content {
    position: relative;
    margin-bottom: 25px;
}

.testimonial-content i {
    font-size: 32px;
    color: var(--primary-color);
    opacity: 0.3;
    position: absolute;
    top: -10px;
    left: -10px;
}

.testimonial-content p {
    font-style: italic;
    color: var(--gray-color);
    line-height: 1.8;
}

.testimonial-author {
    display: flex;
    align-items: center;
    gap: 15px;
}

.testimonial-author img {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    object-fit: cover;
}

.testimonial-author h4 {
    font-size: 18px;
    color: var(--dark-color);
    margin-bottom: 5px;
}

.testimonial-author p {
    color: var(--gray-color);
    font-size: 14px;
}

/* CTA Section */
.cta-section {
    padding: 100px 0;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    text-align: center;
}

.cta-content h2 {
    font-size: 42px;
    margin-bottom: 20px;
    color: white;
}

.cta-content p {
    font-size: 18px;
    margin-bottom: 40px;
    opacity: 0.9;
    max-width: 600px;
    margin-left: auto;
    margin-right: auto;
}

.cta-buttons {
    display: flex;
    justify-content: center;
    gap: 20px;
    flex-wrap: wrap;
}

/* Footer */
.footer {
    background-color: var(--dark-color);
    color: white;
    padding: 80px 0 30px;
}

.footer-content {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 40px;
    margin-bottom: 50px;
}

.footer-col h3 {
    font-size: 20px;
    margin-bottom: 25px;
    color: white;
}

.footer-description {
    color: #aaa;
    margin: 20px 0;
    line-height: 1.8;
}

.social-links {
    display: flex;
    gap: 15px;
    margin-top: 20px;
}

.social-links a {
    width: 40px;
    height: 40px;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: var(--transition);
}

.social-links a:hover {
    background: var(--primary-color);
    transform: translateY(-3px);
}

.footer-col ul {
    list-style: none;
}

.footer-col ul li {
    margin-bottom: 12px;
}

.footer-col ul li a {
    color: #aaa;
    transition: var(--transition);
}

.footer-col ul li a:hover {
    color: white;
    padding-left: 5px;
}

.contact-info li {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    margin-bottom: 15px;
    color: #aaa;
}

.contact-info i {
    color: var(--primary-color);
    margin-top: 4px;
}

.footer-bottom {
    text-align: center;
    padding-top: 30px;
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    color: #aaa;
    font-size: 14px;
}

.footer-bottom p {
    margin-bottom: 10px;
}

.text-center {
    text-align: center;
}

/* Responsive Design */
@media (max-width: 992px) {
    .hero-content {
        grid-template-columns: 1fr;
        text-align: center;
    }
    
    .hero-title {
        font-size: 36px;
    }
    
    .section-title {
        font-size: 30px;
    }
    
    .nav-menu {
        position: fixed;
        top: 80px;
        left: -100%;
        flex-direction: column;
        background-color: white;
        width: 100%;
        text-align: center;
        transition: 0.3s;
        box-shadow: 0 10px 27px rgba(0, 0, 0, 0.05);
        padding: 20px 0;
        gap: 0;
    }
    
    .nav-menu.active {
        left: 0;
    }
    
    .nav-link {
        padding: 20px;
        display: block;
    }
    
    .nav-link.active::after {
        display: none;
    }
    
    .hamburger {
        display: flex;
    }
    
    .hamburger.active span:nth-child(1) {
        transform: rotate(-45deg) translate(-5px, 6px);
    }
    
    .hamburger.active span:nth-child(2) {
        opacity: 0;
    }
    
    .hamburger.active span:nth-child(3) {
        transform: rotate(45deg) translate(-5px, -6px);
    }
}

@media (max-width: 768px) {
    .hero-buttons {
        flex-direction: column;
        align-items: center;
    }
    
    .hero-stats {
        flex-direction: column;
        gap: 20px;
        text-align: center;
    }
    
    .floating-card {
        position: relative;
        margin: 10px auto;
        width: fit-content;
    }
    
    .cta-buttons {
        flex-direction: column;
        align-items: center;
    }
    
    .btn-large {
        width: 100%;
        max-width: 300px;
    }
}

@media (max-width: 576px) {
    .hero {
        padding: 140px 0 60px;
    }
    
    .hero-title {
        font-size: 28px;
    }
    
    .hero-subtitle {
        font-size: 16px;
    }
    
    .section-title {
        font-size: 24px;
    }
    
    .features-grid,
    .events-grid,
    .steps,
    .testimonials-slider {
        grid-template-columns: 1fr;
    }
}
</style>
</head>
<body>
    <!-- Header với Navigation -->
    <header class="header">
        <div class="container">
            <nav class="navbar">
                <div class="logo">
                    <a href="/">
                        <i class="fas fa-calendar-alt"></i>
                        <span>Event<span class="logo-highlight">Hub</span></span>
                    </a>
                </div>
                
                <ul class="nav-menu" id="navMenu">
                    <li><a href="#home" class="nav-link active">Trang chủ</a></li>
                    <li><a href="#features" class="nav-link">Tính năng</a></li>
                    <li><a href="#events" class="nav-link">Sự kiện</a></li>
                    <li><a href="#about" class="nav-link">Về chúng tôi</a></li>
                    <li><a href="#contact" class="nav-link">Liên hệ</a></li>
                </ul>
                
                <div class="auth-section" id="authSection">
                    <!-- Hiển thị khi chưa đăng nhập -->
                    <div id="guestButtons">
                        <a href="/login" class="btn btn-outline btn-login">
                            <i class="fas fa-sign-in-alt"></i> Đăng nhập
                        </a>
                        <a href="/login" class="btn btn-primary btn-register">
                            <i class="fas fa-user-plus"></i> Đăng ký
                        </a>
                    </div>
                    
                    <!-- Hiển thị khi đã đăng nhập -->
                    <div id="userButtons" style="display: none;">
                        <div class="user-dropdown">
                            <button class="user-profile" id="userProfileBtn">
                                <img src="https://ui-avatars.com/api/?name=Guest&background=4e54c8&color=fff" alt="Avatar" class="user-avatar">
                                <span id="userName">Guest</span>
                                <i class="fas fa-chevron-down"></i>
                            </button>
                            <div class="dropdown-menu" id="userDropdown">
                                <a href="#" class="dropdown-item" id="dashboardLink">
                                    <i class="fas fa-tachometer-alt"></i> Dashboard
                                </a>
                                <a href="#" class="dropdown-item">
                                    <i class="fas fa-user"></i> Hồ sơ
                                </a>
                                <a href="#" class="dropdown-item">
                                    <i class="fas fa-cog"></i> Cài đặt
                                </a>
                                <div class="dropdown-divider"></div>
                                <a href="#" class="dropdown-item" id="logoutBtn">
                                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="hamburger" id="hamburger">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </nav>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero" id="home">
        <div class="container">
            <div class="hero-content">
                <div class="hero-text animate__animated animate__fadeInLeft">
                    <h1 class="hero-title">
                        Quản Lý Sự Kiện <span class="highlight">Chuyên Nghiệp</span>
                    </h1>
                    <p class="hero-subtitle">
                        Nền tảng toàn diện cho việc tổ chức, quản lý và tham gia sự kiện. 
                        Kết nối người tổ chức với người tham gia một cách hiệu quả.
                    </p>
                    <div class="hero-buttons">
                        <a href="#events" class="btn btn-primary btn-large">
                            <i class="fas fa-calendar-check"></i> Khám phá sự kiện
                        </a>
                        <a href="#features" class="btn btn-outline btn-large">
                            <i class="fas fa-play-circle"></i> Xem tính năng
                        </a>
                    </div>
                    <div class="hero-stats">
                        <div class="stat-item">
                            <h3 id="eventCount">1000+</h3>
                            <p>Sự kiện</p>
                        </div>
                        <div class="stat-item">
                            <h3 id="userCount">5000+</h3>
                            <p>Người dùng</p>
                        </div>
                        <div class="stat-item">
                            <h3 id="orgCount">200+</h3>
                            <p>Nhà tổ chức</p>
                        </div>
                    </div>
                </div>
                <div class="hero-image animate__animated animate__fadeInRight">
                    <img src="https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80" 
                         alt="Event Management" class="hero-img">
                    <div class="floating-card card1">
                        <i class="fas fa-users"></i>
                        <p>Đăng ký tham gia</p>
                    </div>
                    <div class="floating-card card2">
                        <i class="fas fa-chart-line"></i>
                        <p>Thống kê chi tiết</p>
                    </div>
                    <div class="floating-card card3">
                        <i class="fas fa-bell"></i>
                        <p>Thông báo realtime</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features" id="features">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Tính Năng Nổi Bật</h2>
                <p class="section-subtitle">Đầy đủ công cụ cho mọi vai trò trong hệ thống</p>
            </div>
            
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon participant">
                        <i class="fas fa-user-friends"></i>
                    </div>
                    <h3>Người Tham Gia</h3>
                    <ul class="feature-list">
                        <li><i class="fas fa-check-circle"></i> Tìm kiếm sự kiện nhanh chóng</li>
                        <li><i class="fas fa-check-circle"></i> Đăng ký tham gia dễ dàng</li>
                        <li><i class="fas fa-check-circle"></i> Quản lý lịch sử đăng ký</li>
                        <li><i class="fas fa-check-circle"></i> Nhận thông báo từ tổ chức</li>
                    </ul>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon organizer">
                        <i class="fas fa-user-tie"></i>
                    </div>
                    <h3>Nhà Tổ Chức</h3>
                    <ul class="feature-list">
                        <li><i class="fas fa-check-circle"></i> Tạo và quản lý sự kiện</li>
                        <li><i class="fas fa-check-circle"></i> Theo dõi đăng ký tham gia</li>
                        <li><i class="fas fa-check-circle"></i> Phân tích và báo cáo</li>
                        <li><i class="fas fa-check-circle"></i> Điểm danh tự động</li>
                    </ul>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon admin">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <h3>Quản Trị Viên</h3>
                    <ul class="feature-list">
                        <li><i class="fas fa-check-circle"></i> Quản lý toàn bộ hệ thống</li>
                        <li><i class="fas fa-check-circle"></i> Duyệt sự kiện và người dùng</li>
                        <li><i class="fas fa-check-circle"></i> Thống kê tổng quan</li>
                        <li><i class="fas fa-check-circle"></i> Cấu hình hệ thống</li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- Events Preview Section -->
    <section class="events-preview" id="events">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Sự Kiện Nổi Bật</h2>
                <p class="section-subtitle">Khám phá những sự kiện sắp diễn ra</p>
            </div>
            
            <div class="events-grid" id="eventsGrid">
                <!-- Sự kiện sẽ được load bằng JavaScript -->
                <div class="skeleton-event-card"></div>
                <div class="skeleton-event-card"></div>
                <div class="skeleton-event-card"></div>
            </div>
            
            <div class="text-center">
                <a href="/login" class="btn btn-primary btn-large">
                    <i class="fas fa-calendar-alt"></i> Xem tất cả sự kiện
                </a>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section class="how-it-works">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Cách Thức Hoạt Động</h2>
                <p class="section-subtitle">3 bước đơn giản để bắt đầu</p>
            </div>
            
            <div class="steps">
                <div class="step">
                    <div class="step-number">1</div>
                    <div class="step-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <h3>Đăng Ký Tài Khoản</h3>
                    <p>Tạo tài khoản miễn phí với vai trò phù hợp</p>
                </div>
                
                <div class="step">
                    <div class="step-number">2</div>
                    <div class="step-icon">
                        <i class="fas fa-calendar-plus"></i>
                    </div>
                    <h3>Tạo/Tham Gia Sự Kiện</h3>
                    <p>Nhà tổ chức tạo sự kiện, người tham gia đăng ký</p>
                </div>
                
                <div class="step">
                    <div class="step-number">3</div>
                    <div class="step-icon">
                        <i class="fas fa-tasks"></i>
                    </div>
                    <h3>Quản Lý & Tương Tác</h3>
                    <p>Theo dõi, quản lý và tương tác với sự kiện</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials -->
    <section class="testimonials">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Người Dùng Nói Gì</h2>
                <p class="section-subtitle">Phản hồi từ cộng đồng người dùng</p>
            </div>
            
            <div class="testimonials-slider">
                <div class="testimonial-card">
                    <div class="testimonial-content">
                        <i class="fas fa-quote-left"></i>
                        <p>Hệ thống giúp tôi quản lý sự kiện một cách chuyên nghiệp. Tính năng phân tích rất hữu ích!</p>
                    </div>
                    <div class="testimonial-author">
                        <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="User">
                        <div>
                            <h4>Nguyễn Văn A</h4>
                            <p>Nhà tổ chức sự kiện</p>
                        </div>
                    </div>
                </div>
                
                <div class="testimonial-card">
                    <div class="testimonial-content">
                        <i class="fas fa-quote-left"></i>
                        <p>Tôi tìm thấy nhiều sự kiện thú vị và đăng ký rất dễ dàng. Thông báo luôn kịp thời!</p>
                    </div>
                    <div class="testimonial-author">
                        <img src="https://randomuser.me/api/portraits/women/44.jpg" alt="User">
                        <div>
                            <h4>Trần Thị B</h4>
                            <p>Người tham gia sự kiện</p>
                        </div>
                    </div>
                </div>
                
                <div class="testimonial-card">
                    <div class="testimonial-content">
                        <i class="fas fa-quote-left"></i>
                        <p>Giao diện thân thiện, dễ sử dụng. Quản lý người dùng và sự kiện rất hiệu quả.</p>
                    </div>
                    <div class="testimonial-author">
                        <img src="https://randomuser.me/api/portraits/men/65.jpg" alt="User">
                        <div>
                            <h4>Lê Văn C</h4>
                            <p>Quản trị viên</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
        <div class="container">
            <div class="cta-content">
                <h2>Đã Sẵn Sàng Trải Nghiệm?</h2>
                <p>Tham gia cộng đồng quản lý sự kiện hàng đầu ngay hôm nay</p>
                <div class="cta-buttons">
                    <a href="/login" class="btn btn-primary btn-large">
                        <i class="fas fa-rocket"></i> Bắt Đầu Ngay
                    </a>
                    <a href="#contact" class="btn btn-outline btn-large">
                        <i class="fas fa-question-circle"></i> Cần Hỗ Trợ?
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer" id="contact">
        <div class="container">
            <div class="footer-content">
                <div class="footer-col">
                    <div class="logo">
                        <a href="/">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Event<span class="logo-highlight">Hub</span></span>
                        </a>
                    </div>
                    <p class="footer-description">
                        Nền tảng quản lý sự kiện toàn diện, kết nối người tổ chức và người tham gia.
                    </p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-linkedin"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
                
                <div class="footer-col">
                    <h3>Liên Kết Nhanh</h3>
                    <ul>
                        <li><a href="#home">Trang chủ</a></li>
                        <li><a href="#features">Tính năng</a></li>
                        <li><a href="#events">Sự kiện</a></li>
                        <li><a href="#about">Về chúng tôi</a></li>
                    </ul>
                </div>
                
                <div class="footer-col">
                    <h3>Tài Nguyên</h3>
                    <ul>
                        <li><a href="#">Hướng dẫn sử dụng</a></li>
                        <li><a href="#">Câu hỏi thường gặp</a></li>
                        <li><a href="#">Chính sách bảo mật</a></li>
                        <li><a href="#">Điều khoản dịch vụ</a></li>
                    </ul>
                </div>
                
                <div class="footer-col">
                    <h3>Liên Hệ</h3>
                    <ul class="contact-info">
                        <li><i class="fas fa-map-marker-alt"></i> 123 Đường ABC, Quận 1, TP.HCM</li>
                        <li><i class="fas fa-phone"></i> (028) 1234 5678</li>
                        <li><i class="fas fa-envelope"></i> support@eventhub.com</li>
                    </ul>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; 2024 EventHub. Tất cả các quyền được bảo lưu.</p>
                <p>Được phát triển bởi Nhóm Quản lý Sự kiện</p>
            </div>
        </div>
    </footer>

    <!-- JavaScript -->
    <script>
        // Main Application JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Mobile Navigation Toggle
    const hamburger = document.getElementById('hamburger');
    const navMenu = document.getElementById('navMenu');
    
    hamburger.addEventListener('click', function() {
        this.classList.toggle('active');
        navMenu.classList.toggle('active');
    });
    
    // Close mobile menu when clicking on a link
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', () => {
            hamburger.classList.remove('active');
            navMenu.classList.remove('active');
        });
    });
    
    // Check login status
    checkLoginStatus();
    
    // Load featured events
    loadFeaturedEvents();
    
    // Update statistics
    updateStatistics();
    
    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;
            
            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 80,
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // Header scroll effect
    window.addEventListener('scroll', function() {
        const header = document.querySelector('.header');
        if (window.scrollY > 100) {
            header.style.boxShadow = '0 5px 20px rgba(0, 0, 0, 0.1)';
            header.style.backgroundColor = 'rgba(255, 255, 255, 0.98)';
        } else {
            header.style.boxShadow = '0 2px 20px rgba(0, 0, 0, 0.1)';
            header.style.backgroundColor = 'rgba(255, 255, 255, 0.95)';
        }
    });
    
    // Logout functionality
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function(e) {
            e.preventDefault();
            logout();
        });
    }
    
    // User dropdown functionality
    const userProfileBtn = document.getElementById('userProfileBtn');
    const userDropdown = document.getElementById('userDropdown');
    
    if (userProfileBtn && userDropdown) {
        userProfileBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            userDropdown.classList.toggle('show');
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (!userProfileBtn.contains(e.target) && !userDropdown.contains(e.target)) {
                userDropdown.classList.remove('show');
            }
        });
    }
});

// Check if user is logged in
async function checkLoginStatus() {
    try {
        const response = await fetch('/api/account', {
            credentials: 'include'
        });
        
        if (response.ok) {
            const user = await response.json();
            showUserSection(user);
        } else {
            showGuestSection();
        }
    } catch (error) {
        console.error('Error checking login status:', error);
        showGuestSection();
    }
}

// Show user section when logged in
function showUserSection(user) {
    const guestButtons = document.getElementById('guestButtons');
    const userButtons = document.getElementById('userButtons');
    const userName = document.getElementById('userName');
    const dashboardLink = document.getElementById('dashboardLink');
    
    if (guestButtons && userButtons) {
        guestButtons.style.display = 'none';
        userButtons.style.display = 'flex';
    }
    
    if (userName) {
        userName.textContent = user.hoTen || user.tenDangNhap;
    }
    
    if (dashboardLink) {
        // Set dashboard link based on user role
        let dashboardUrl = '/';
        switch (user.vaiTro) {
            case 'Admin':
                dashboardUrl = '/admin/admin';
                break;
            case 'ToChuc':
                dashboardUrl = '/organizer/organizer/organize';
                break;
            default:
                dashboardUrl = '/participant/renter/join';
        }
        dashboardLink.href = dashboardUrl;
    }
}

// Show guest section when not logged in
function showGuestSection() {
    const guestButtons = document.getElementById('guestButtons');
    const userButtons = document.getElementById('userButtons');
    
    if (guestButtons && userButtons) {
        guestButtons.style.display = 'flex';
        userButtons.style.display = 'none';
    }
}

// Load featured events
async function loadFeaturedEvents() {
    const eventsGrid = document.getElementById('eventsGrid');
    if (!eventsGrid) return;
    
    try {
        // Show skeleton loading
        eventsGrid.innerHTML = `
            <div class="skeleton-event-card"></div>
            <div class="skeleton-event-card"></div>
            <div class="skeleton-event-card"></div>
        `;
        
        // Fetch events from API
        const response = await fetch('/api/events/featured');
        
        if (response.ok) {
            const events = await response.json();
            displayEvents(events);
        } else {
            throw new Error('Failed to fetch events');
        }
    } catch (error) {
        console.error('Error loading events:', error);
        eventsGrid.innerHTML = `
            <div class="error-message" style="grid-column: 1/-1; text-align: center; padding: 40px;">
                <i class="fas fa-exclamation-circle" style="font-size: 48px; color: #ff6b6b; margin-bottom: 20px;"></i>
                <p>Không thể tải danh sách sự kiện. Vui lòng thử lại sau.</p>
            </div>
        `;
    }
}

// Display events in the grid
function displayEvents(events) {
    const eventsGrid = document.getElementById('eventsGrid');
    if (!eventsGrid) return;
    
    if (!events || events.length === 0) {
        eventsGrid.innerHTML = `
            <div class="no-events" style="grid-column: 1/-1; text-align: center; padding: 40px;">
                <i class="fas fa-calendar-times" style="font-size: 48px; color: #6c757d; margin-bottom: 20px;"></i>
                <p>Hiện chưa có sự kiện nào. Hãy quay lại sau!</p>
            </div>
        `;
        return;
    }
    
    // Limit to 3 events for preview
    const displayEvents = events.slice(0, 3);
    
    eventsGrid.innerHTML = displayEvents.map(event => `
        <div class="event-card">
            <div class="event-image">
                <img src="${event.anhBia || 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80'}" 
                     alt="${event.tenSuKien}">
            </div>
            <div class="event-content">
                <h3 class="event-title">${event.tenSuKien}</h3>
                <div class="event-date">
                    <i class="far fa-calendar-alt"></i>
                    ${formatDate(event.thoiGianBatDau)}
                </div>
                <p class="event-description">
                    ${event.moTa ? event.moTa.substring(0, 100) + '...' : 'Không có mô tả'}
                </p>
                <div class="event-meta">
                    <span class="event-type">${getEventType(event.loaiSuKien)}</span>
                    <div class="event-stats">
                        <span class="stat">
                            <i class="fas fa-users"></i>
                            ${event.soLuongDaDangKy || 0}/${event.soLuongToiDa || '∞'}
                        </span>
                        <span class="stat">
                            <i class="fas fa-map-marker-alt"></i>
                            ${event.diaDiem ? event.diaDiem.substring(0, 15) + '...' : 'Trực tuyến'}
                        </span>
                    </div>
                </div>
                <a href="/login" class="btn btn-primary btn-block">
                    <i class="fas fa-info-circle"></i> Xem chi tiết
                </a>
            </div>
        </div>
    `).join('');
}

// Format date to readable format
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('vi-VN', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

// Get event type display name
function getEventType(type) {
    const types = {
        'CongKhai': 'Công khai',
        'RiengTu': 'Riêng tư',
        'Online': 'Trực tuyến',
        'Offline': 'Trực tiếp'
    };
    return types[type] || type;
}

// Update statistics counters
function updateStatistics() {
    // These would normally come from API
    // For now, use animated counters
    animateCounter('eventCount', 1000);
    animateCounter('userCount', 5000);
    animateCounter('orgCount', 200);
}

// Animate counter from 0 to target
function animateCounter(elementId, target) {
    const element = document.getElementById(elementId);
    if (!element) return;
    
    let current = 0;
    const increment = target / 50;
    const timer = setInterval(() => {
        current += increment;
        if (current >= target) {
            current = target;
            clearInterval(timer);
        }
        element.textContent = Math.floor(current) + '+';
    }, 30);
}

// Logout function
async function logout() {
    try {
        // Call logout endpoint if exists, or just clear session
        const response = await fetch('/logout', {
            method: 'POST',
            credentials: 'include'
        });
        
        // Clear local state
        localStorage.removeItem('user');
        sessionStorage.clear();
        
        // Refresh page to show guest state
        window.location.href = '/';
    } catch (error) {
        console.error('Error during logout:', error);
        // Still redirect to home
        window.location.href = '/';
    }
}

// Initialize animations on scroll
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('animate__animated', 'animate__fadeInUp');
            observer.unobserve(entry.target);
        }
    });
}, observerOptions);

// Observe elements for animation
document.querySelectorAll('.feature-card, .step, .testimonial-card').forEach(el => {
    observer.observe(el);
});
    </script>
</body>
</html>