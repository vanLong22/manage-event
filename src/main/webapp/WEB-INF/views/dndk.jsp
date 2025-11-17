<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHub - Đăng nhập & Đăng ký</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: var(--dark);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            display: flex;
            width: 100%;
            max-width: 1000px;
            min-height: 600px;
            background: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            position: relative;
        }

        .welcome-section {
            flex: 1;
            background: linear-gradient(135deg, var(--primary) 0%, #3a5bff 100%);
            color: white;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
            transition: var(--transition);
        }

        .welcome-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100" opacity="0.1"><path fill="white" d="M30,30 Q50,10 70,30 T90,30 T70,70 T30,70 T10,30 T30,30 Z"/></svg>') repeat;
        }

        .welcome-content {
            position: relative;
            z-index: 1;
        }

        .welcome-section h1 {
            font-size: 32px;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .welcome-section p {
            font-size: 16px;
            margin-bottom: 30px;
            opacity: 0.9;
        }

        .features {
            list-style: none;
            margin-top: 30px;
        }

        .features li {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            font-size: 15px;
        }

        .features i {
            margin-right: 10px;
            font-size: 18px;
            width: 24px;
            text-align: center;
        }

        .form-section {
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .logo {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }

        .logo i {
            font-size: 32px;
            margin-right: 10px;
            color: var(--primary);
        }

        .logo h1 {
            font-size: 24px;
            font-weight: 700;
            color: var(--dark);
        }

        .form-container {
            width: 100%;
            position: relative;
        }

        .form-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 10px;
            color: var(--dark);
        }

        .form-subtitle {
            color: var(--gray);
            margin-bottom: 30px;
            font-size: 15px;
        }

        .form {
            width: 100%;
            transition: var(--transition);
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-row {
            display: flex;
            gap: 15px;
        }

        .form-row .form-group {
            flex: 1;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark);
            font-size: 14px;
        }

        input, select {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            transition: var(--transition);
        }

        input:focus, select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(74, 107, 255, 0.2);
        }

        .input-icon {
            position: absolute;
            right: 16px;
            top: 42px;
            color: var(--gray);
        }

        .btn {
            padding: 14px 20px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            font-size: 16px;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background-color: #3a5bff;
            transform: translateY(-2px);
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid var(--primary);
            color: var(--primary);
        }

        .btn-outline:hover {
            background-color: var(--primary-light);
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 25px 0;
            color: var(--gray);
            font-size: 14px;
        }

        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #eee;
        }

        .divider span {
            padding: 0 15px;
        }

        .social-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
        }

        .social-btn {
            flex: 1;
            padding: 12px;
            border: 1px solid #eee;
            border-radius: 8px;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: var(--transition);
        }

        .social-btn:hover {
            background: #f9f9f9;
            border-color: #ddd;
        }

        .social-btn img {
            width: 20px;
            height: 20px;
        }

        .form-footer {
            text-align: center;
            margin-top: 25px;
            font-size: 14px;
            color: var(--gray);
        }

        .form-footer a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            cursor: pointer;
        }

        .form-footer a:hover {
            text-decoration: underline;
        }

        /* CSS cải tiến cho chuyển đổi form */
        #register-form {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: white;
            padding: 40px;
            transform: translateX(100%);
            opacity: 0;
            transition: transform 0.5s ease, opacity 0.3s ease;
            overflow-y: auto;
        }

        #register-form.active {
            transform: translateX(0);
            opacity: 1;
        }

        #login-form {
            transition: transform 0.5s ease, opacity 0.3s ease;
        }

        #login-form.hidden {
            transform: translateX(-100%);
            opacity: 0;
        }

        .back-to-login {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            color: var(--primary);
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
        }

        .back-to-login i {
            margin-right: 8px;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .alert-danger {
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--danger);
            border: 1px solid rgba(231, 76, 60, 0.2);
        }

        .alert-success {
            background-color: rgba(46, 204, 113, 0.1);
            color: var(--success);
            border: 1px solid rgba(46, 204, 113, 0.2);
        }

        .custom-alert {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            min-width: 300px;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 14px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .role-selection {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .role-option {
            flex: 1;
            text-align: center;
            padding: 12px;
            border: 2px solid #eee;
            border-radius: 8px;
            cursor: pointer;
            transition: var(--transition);
        }

        .role-option:hover {
            border-color: var(--primary-light);
        }

        .role-option.selected {
            border-color: var(--primary);
            background-color: var(--primary-light);
        }

        .role-option i {
            font-size: 24px;
            margin-bottom: 8px;
            color: var(--primary);
        }

        .role-option span {
            display: block;
            font-weight: 600;
            font-size: 14px;
        }

        /* Thêm style cho validation */
        .error-message {
            color: var(--danger);
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        .form-group.error input, 
        .form-group.error select {
            border-color: var(--danger);
        }

        .form-group.error .error-message {
            display: block;
        }

        .form-group.success input, 
        .form-group.success select {
            border-color: var(--success);
        }

        /* Loading state */
        .btn.loading {
            position: relative;
            pointer-events: none;
            color: transparent;
        }

        .btn.loading::after {
            content: '';
            position: absolute;
            width: 20px;
            height: 20px;
            top: 50%;
            left: 50%;
            margin-left: -10px;
            margin-top: -10px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 0.8s ease infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                flex-direction: column;
                max-width: 450px;
                min-height: auto;
            }
            
            .welcome-section {
                padding: 30px;
                display: none;
            }
            
            .form-section {
                padding: 30px;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .social-buttons {
                flex-direction: column;
            }
            
            #register-form {
                position: relative;
                transform: translateX(0);
                opacity: 0;
                display: none;
                height: auto;
            }
            
            #register-form.active {
                display: block;
                opacity: 1;
            }
            
            #login-form.hidden {
                display: none;
            }

            .mobile-welcome {
                display: block;
                text-align: center;
                margin-bottom: 20px;
            }

            .mobile-welcome h2 {
                font-size: 22px;
                color: var(--primary);
                margin-bottom: 10px;
            }
        }

        @media (max-width: 480px) {
            .welcome-section, .form-section {
                padding: 25px;
            }
            
            .welcome-section h1 {
                font-size: 26px;
            }
        }

        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 2000;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="toast-container" id="toast-container"></div>

        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="welcome-content">
                <h1>Chào mừng đến với EventHub</h1>
                <p>Kết nối, khám phá và tham gia các sự kiện thú vị xung quanh bạn</p>
                
                <ul class="features">
                    <li><i class="fas fa-check-circle"></i> Khám phá hàng ngàn sự kiện đa dạng</li>
                    <li><i class="fas fa-check-circle"></i> Tạo và quản lý sự kiện dễ dàng</li>
                    <li><i class="fas fa-check-circle"></i> Kết nối với cộng đồng cùng sở thích</li>
                    <li><i class="fas fa-check-circle"></i> Nhận thông báo về sự kiện phù hợp</li>
                </ul>
            </div>
        </div>

        <!-- Form Section -->
        <div class="form-section">
            <div class="mobile-welcome">
                <h2>EventHub</h2>
                <p>Kết nối với cộng đồng sự kiện</p>
            </div>
            
            <div class="logo">
                <i class="fas fa-calendar-alt"></i>
                <h1>EventHub</h1>
            </div>

            <div class="form-container">
                <!-- Login Form -->
                <div id="login-form" class="form active">
                    <h2 class="form-title">Đăng nhập</h2>
                    <p class="form-subtitle">Chào mừng trở lại! Vui lòng đăng nhập để tiếp tục</p>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            ${error}
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty message}">
                        <div class="alert alert-success">
                            ${message}
                        </div>
                    </c:if>

                    <form class="form" id="loginForm">
                        <div class="form-group">
                            <label for="username">Tên đăng nhập *</label>
                            <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập" required>
                            <i class="fas fa-user input-icon"></i>
                            <div class="error-message" id="username-error">Vui lòng nhập tên đăng nhập</div>
                        </div>

                        <div class="form-group">
                            <label for="password">Mật khẩu *</label>
                            <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                            <i class="fas fa-lock input-icon"></i>
                            <div class="error-message" id="password-error">Vui lòng nhập mật khẩu</div>
                        </div>

                        <div class="form-group" style="display: flex; justify-content: space-between; align-items: center;">
                            <label style="margin-bottom: 0;">
                                <input type="checkbox" name="remember-me"> Ghi nhớ đăng nhập
                            </label>
                            <a href="#" style="color: var(--primary); text-decoration: none; font-size: 14px;">Quên mật khẩu?</a>
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn btn-primary" id="login-btn">
                                <i class="fas fa-sign-in-alt"></i> Đăng nhập
                            </button>
                        </div>
                    </form>

                    <div class="divider"><span>Hoặc đăng nhập với</span></div>

                    <div class="social-buttons">
                        <div class="social-btn">
                            <i class="fab fa-google" style="color: #DB4437;"></i>
                        </div>
                        <div class="social-btn">
                            <i class="fab fa-facebook" style="color: #4267B2;"></i>
                        </div>
                        <div class="social-btn">
                            <i class="fab fa-apple" style="color: #000;"></i>
                        </div>
                    </div>

                    <div class="form-footer">
                        Chưa có tài khoản? <a id="show-register">Đăng ký ngay</a>
                    </div>
                </div>

                <!-- Register Form -->
                <div id="register-form" class="form">
                    <div class="back-to-login" id="back-to-login">
                        <i class="fas fa-arrow-left"></i> Quay lại đăng nhập
                    </div>

                    <h2 class="form-title">Đăng ký tài khoản</h2>
                    <p class="form-subtitle">Tạo tài khoản để bắt đầu khám phá các sự kiện thú vị</p>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            ${error}
                        </div>
                    </c:if>

                    <form class="form" id="registerForm" action="${pageContext.request.contextPath}/register-process" method="post">
                        <div class="form-group">
                            <label>Bạn là ai?</label>
                            <div class="role-selection">
                                <div class="role-option selected" data-role="PARTICIPANT">
                                    <i class="fas fa-user"></i>
                                    <span>Người tham gia</span>
                                </div>
                                <div class="role-option" data-role="ToChuc">
                                    <i class="fas fa-users"></i>
                                    <span>Người tổ chức</span>
                                </div>
                            </div>
                            <input type="hidden" id="vaiTro" name="vaiTro" value="NguoiDung" required>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="hoTen">Họ tên *</label>
                                <input type="text" id="hoTen" name="hoTen" value="${user.hoTen}" placeholder="Nhập họ tên" required>
                                <div class="error-message" id="hoTen-error">Vui lòng nhập họ tên</div>
                            </div>
                            <div class="form-group">
                                <label for="tenDangNhap">Tên đăng nhập *</label>
                                <input type="text" id="tenDangNhap" name="tenDangNhap" value="${user.tenDangNhap}" placeholder="Nhập tên đăng nhập" required>
                                <div class="error-message" id="tenDangNhap-error">Vui lòng nhập tên đăng nhập</div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email *</label>
                            <input type="email" id="email" name="email" value="${user.email}" placeholder="Nhập địa chỉ email" required>
                            <i class="fas fa-envelope input-icon"></i>
                            <div class="error-message" id="email-error">Vui lòng nhập email hợp lệ</div>
                        </div>

                        <div class="form-group">
                            <label for="soDienThoai">Số điện thoại</label>
                            <input type="tel" id="soDienThoai" name="soDienThoai" value="${user.soDienThoai}" placeholder="Nhập số điện thoại">
                            <i class="fas fa-phone input-icon"></i>
                            <div class="error-message" id="soDienThoai-error">Vui lòng nhập số điện thoại hợp lệ</div>
                        </div>

                        <div class="form-group">
                            <label for="matKhau">Mật khẩu *</label>
                            <input type="password" id="matKhau" name="matKhau" placeholder="Tạo mật khẩu" required>
                            <i class="fas fa-lock input-icon"></i>
                            <div class="error-message" id="matKhau-error">Mật khẩu phải có ít nhất 6 ký tự</div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Xác nhận mật khẩu *</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                            <i class="fas fa-lock input-icon"></i>
                            <div class="error-message" id="confirmPassword-error">Mật khẩu xác nhận không khớp</div>
                        </div>

                        <div class="form-group">
                            <label for="diaChi">Địa chỉ</label>
                            <input type="text" id="diaChi" name="diaChi" value="${user.diaChi}" placeholder="Nhập địa chỉ">
                        </div>

                        <div class="form-group">
                            <label for="gioiTinh">Giới tính</label>
                            <select id="gioiTinh" name="gioiTinh">
                                <option value="">Chọn giới tính</option>
                                <option value="Nam" <c:if test='${user.gioiTinh == "Nam"}'>selected</c:if>>Nam</option>
                                <option value="Nu" <c:if test='${user.gioiTinh == "Nu"}'>selected</c:if>>Nữ</option>
                                <option value="Khac" <c:if test='${user.gioiTinh == "Khac"}'>selected</c:if>>Khác</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label style="font-weight: normal; font-size: 14px;">
                                <input type="checkbox" id="terms" required> Tôi đồng ý với <a href="#" style="color: var(--primary);">Điều khoản dịch vụ</a> và <a href="#" style="color: var(--primary);">Chính sách bảo mật</a>
                            </label>
                            <div class="error-message" id="terms-error">Bạn cần đồng ý với điều khoản dịch vụ</div>
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn btn-primary" id="register-btn">
                                <i class="fas fa-user-plus"></i> Đăng ký
                            </button>
                        </div>
                    </form>

                    <div class="form-footer">
                        Đã có tài khoản? <a id="show-login">Đăng nhập ngay</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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

            // Xử lý chuyển đổi giữa form đăng nhập và đăng ký
            $('#show-register').click(function() {
                $('#login-form').removeClass('active').addClass('hidden');
                $('#register-form').addClass('active');
                $('.mobile-welcome').hide();
            });

            $('#show-login, #back-to-login').click(function() {
                $('#register-form').removeClass('active');
                $('#login-form').removeClass('hidden').addClass('active');
                $('.mobile-welcome').show();
            });

            // Xử lý form đăng nhập bằng AJAX
            $('#loginForm').on('submit', function(e) {
                e.preventDefault();
                
                // Reset lỗi trước khi validate
                resetErrors();
                
                if (!validateLoginForm()) {
                    showToast('Vui lòng điền đầy đủ thông tin đăng nhập', false);
                    return;
                }

                const username = $('#username').val().trim();
                const password = $('#password').val();

                // Hiển thị trạng thái loading
                $('#login-btn').addClass('loading');

                $.ajax({
                    url: '${pageContext.request.contextPath}/api/login',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        username: username,
                        password: password
                    }),
                    success: function(response) {
                        $('#login-btn').removeClass('loading');
                        
                        if (response.success) {
                            showToast(response.message || 'Đăng nhập thành công!', true);
                            setTimeout(() => {
                                window.location.href = response.redirect;
                            }, 1000);
                        } else {
                            showToast(response.message || 'Đăng nhập thất bại!', false);
                        }
                    },
                    error: function(xhr) {
                        $('#login-btn').removeClass('loading');
                        let msg = 'Lỗi kết nối đến server!';
                        try {
                            const err = xhr.responseJSON;
                            if (err && err.message) msg = err.message;
                        } catch (e) {}
                        showToast(msg, false);
                    }
                });
            });

            // Xử lý chọn vai trò trong form đăng ký
            $('.role-option').click(function() {
                $('.role-option').removeClass('selected');
                $(this).addClass('selected');
                var role = $(this).data('role');
                $('#vaiTro').val(role);
            });

            // Xử lý form đăng ký bằng AJAX
            $('#registerForm').on('submit', function(e) {
                e.preventDefault();
                
                // Reset lỗi trước khi validate
                resetErrors();
                
                if (!validateRegisterForm()) {
                    return;
                }
                
                const formData = $(this).serialize();
                
                // Hiển thị trạng thái loading
                $('#register-btn').addClass('loading');

                $.ajax({
                    url: '${pageContext.request.contextPath}/register-process',
                    type: 'POST',
                    data: formData,
                    success: function(response) {
                        $('#register-btn').removeClass('loading');
                        showToast('Đăng ký thành công! Vui lòng đăng nhập.', true);
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/login';
                        }, 1500);
                    },
                    error: function(xhr) {
                        $('#register-btn').removeClass('loading');
                        let errorMsg = 'Có lỗi xảy ra khi đăng ký!';
                        try {
                            const errorResponse = xhr.responseJSON;
                            if (errorResponse && errorResponse.message) {
                                errorMsg = errorResponse.message;
                            }
                        } catch (e) {}
                        showToast(errorMsg, false);
                    }
                });
            });

            // Hàm validate form đăng nhập
            function validateLoginForm() {
                let isValid = true;
                
                const username = $('#username').val().trim();
                const password = $('#password').val();
                
                if (!username) {
                    $('#username').parent().addClass('error');
                    isValid = false;
                }
                
                if (!password) {
                    $('#password').parent().addClass('error');
                    isValid = false;
                }
                
                return isValid;
            }
            
            // Hàm validate form đăng ký
            function validateRegisterForm() {
                let isValid = true;
                let errorMessages = [];
                
                // Họ tên
                if (!$('#hoTen').val().trim()) {
                    $('#hoTen').parent().addClass('error');
                    isValid = false;
                    errorMessages.push('Vui lòng nhập họ tên');
                }
                
                // Tên đăng nhập
                if (!$('#tenDangNhap').val().trim()) {
                    $('#tenDangNhap').parent().addClass('error');
                    isValid = false;
                    errorMessages.push('Vui lòng nhập tên đăng nhập');
                }
                
                // Email
                const email = $('#email').val().trim();
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!email) {
                    $('#email').parent().addClass('error');
                    isValid = false;
                    errorMessages.push('Vui lòng nhập email');
                } else if (!emailRegex.test(email)) {
                    $('#email').parent().addClass('error');
                    isValid = false;
                    errorMessages.push('Vui lòng nhập email hợp lệ');
                }
                
                // Mật khẩu
                const password = $('#matKhau').val();
                if (!password) {
                    $('#matKhau').parent().addClass('error');
                    isValid = false;
                    errorMessages.push('Vui lòng nhập mật khẩu');
                } else if (password.length < 6) {
                    $('#matKhau').parent().addClass('error');
                    isValid = false;
                    errorMessages.push('Mật khẩu phải có ít nhất 6 ký tự');
                }
                
                // Xác nhận mật khẩu
                const confirmPassword = $('#confirmPassword').val();
                if (!confirmPassword) {
                    $('#confirmPassword').parent().addClass('error');
                    isValid = false;
                    errorMessages.push('Vui lòng xác nhận mật khẩu');
                } else if (password !== confirmPassword) {
                    $('#confirmPassword').parent().addClass('error');
                    isValid = false;
                    errorMessages.push('Mật khẩu xác nhận không khớp');
                }
                
                // Điều khoản
                if (!$('#terms').is(':checked')) {
                    $('#terms').parent().parent().addClass('error');
                    isValid = false;
                    errorMessages.push('Bạn cần đồng ý với điều khoản dịch vụ');
                }
                
                // Hiển thị thông báo lỗi đầu tiên
                if (errorMessages.length > 0) {
                    showToast(errorMessages[0], false);
                }
                
                return isValid;
            }
            
            // Reset tất cả lỗi
            function resetErrors() {
                $('.form-group').removeClass('error');
            }

            // Xử lý real-time validation cho các trường
            $('input').on('blur', function() {
                const $input = $(this);
                const $formGroup = $input.parent();
                
                // Xóa trạng thái lỗi trước đó
                $formGroup.removeClass('error');
                
                // Kiểm tra và thêm lỗi nếu cần
                if ($input.attr('type') == 'email' && $input.val()) {
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test($input.val())) {
                        $formGroup.addClass('error');
                        showToast('Email không hợp lệ', false);
                    }
                }
                
                if ($input.attr('id') == 'confirmPassword' && $input.val()) {
                    const password = $('#matKhau').val();
                    if ($input.val() !== password) {
                        $formGroup.addClass('error');
                        showToast('Mật khẩu xác nhận không khớp', false);
                    }
                }
            });

            // Xử lý số điện thoại
            $('#soDienThoai').on('blur', function() {
                const phone = $(this).val().trim();
                if (phone && !/^(0|\+84)[3|5|7|8|9][0-9]{8}$/.test(phone)) {
                    showToast('Số điện thoại không hợp lệ', false);
                }
            });
        });
    </script>
</body>
</html>