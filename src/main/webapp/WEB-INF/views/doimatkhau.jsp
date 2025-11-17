<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHub - Đổi mật khẩu</title>
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
            width: 100%;
            max-width: 500px;
            background: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
        }

        .header {
            background: linear-gradient(135deg, var(--primary) 0%, #3a5bff 100%);
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100" opacity="0.1"><path fill="white" d="M30,30 Q50,10 70,30 T90,30 T70,70 T30,70 T10,30 T30,30 Z"/></svg>') repeat;
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        .logo {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
        }

        .logo i {
            font-size: 32px;
            margin-right: 10px;
        }

        .logo h1 {
            font-size: 24px;
            font-weight: 700;
        }

        .header h2 {
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .header p {
            opacity: 0.9;
            font-size: 15px;
        }

        .form-section {
            padding: 30px;
        }

        .form-title {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 5px;
            color: var(--dark);
        }

        .form-subtitle {
            color: var(--gray);
            margin-bottom: 25px;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark);
            font-size: 14px;
        }

        input {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            transition: var(--transition);
        }

        input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(74, 107, 255, 0.2);
        }

        .input-icon {
            position: absolute;
            right: 16px;
            top: 42px;
            color: var(--gray);
            cursor: pointer;
        }

        .password-strength {
            margin-top: 8px;
            height: 4px;
            border-radius: 2px;
            background: #eee;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 100%;
            width: 0;
            transition: var(--transition);
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
        }

        .requirement.met {
            color: var(--success);
        }

        .requirement.unmet {
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
            margin-top: 10px;
        }

        .btn-outline:hover {
            background-color: var(--primary-light);
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

        .error-message {
            color: var(--danger);
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        .form-group.error input {
            border-color: var(--danger);
        }

        .form-group.error .error-message {
            display: block;
        }

        .form-group.success input {
            border-color: var(--success);
        }

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

        .back-link {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 20px;
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
        }

        .back-link i {
            margin-right: 8px;
        }

        .user-info {
            display: flex;
            align-items: center;
            background-color: var(--primary-light);
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .user-info i {
            font-size: 18px;
            color: var(--primary);
            margin-right: 10px;
        }

        .user-info span {
            font-weight: 600;
            color: var(--dark);
        }

        /* Responsive */
        @media (max-width: 480px) {
            .container {
                max-width: 100%;
            }
            
            .header, .form-section {
                padding: 25px;
            }
            
            .header h2 {
                font-size: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header Section -->
        <div class="header">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-calendar-alt"></i>
                    <h1>EventHub</h1>
                </div>
                <h2>Đổi mật khẩu</h2>
                <p>Bảo vệ tài khoản của bạn với mật khẩu mới</p>
            </div>
        </div>

        <!-- Form Section -->
        <div class="form-section">
            <h2 class="form-title">Cập nhật mật khẩu</h2>
            <p class="form-subtitle">Vui lòng nhập tên đăng nhập và mật khẩu mới của bạn</p>

            <div id="alert-container">
                <!-- Alerts will be displayed here -->
            </div>

            <form id="change-password-form">
                <div class="form-group">
                    <label for="username">Tên đăng nhập *</label>
                    <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập của bạn" required>
                    <i class="fas fa-user input-icon"></i>
                    <div class="error-message" id="username-error">Vui lòng nhập tên đăng nhập</div>
                </div>

                <div class="user-info" id="user-info" style="display: none;">
                    <i class="fas fa-user-circle"></i>
                    <span id="user-display-name">Nguyễn Văn A</span>
                </div>

                <div class="form-group">
                    <label for="current-password">Mật khẩu hiện tại *</label>
                    <input type="password" id="current-password" name="current-password" placeholder="Nhập mật khẩu hiện tại" required>
                    <i class="fas fa-eye input-icon toggle-password" data-target="current-password"></i>
                    <div class="error-message" id="current-password-error">Vui lòng nhập mật khẩu hiện tại</div>
                </div>

                <div class="form-group">
                    <label for="new-password">Mật khẩu mới *</label>
                    <input type="password" id="new-password" name="new-password" placeholder="Nhập mật khẩu mới" required>
                    <i class="fas fa-eye input-icon toggle-password" data-target="new-password"></i>
                    <div class="password-strength" id="password-strength">
                        <div class="password-strength-bar"></div>
                    </div>
                    <div class="password-requirements">
                        <div class="requirement unmet" id="length-req">
                            <i class="fas fa-circle"></i>
                            <span>Ít nhất 8 ký tự</span>
                        </div>
                        <div class="requirement unmet" id="uppercase-req">
                            <i class="fas fa-circle"></i>
                            <span>Chứa chữ hoa</span>
                        </div>
                        <div class="requirement unmet" id="lowercase-req">
                            <i class="fas fa-circle"></i>
                            <span>Chứa chữ thường</span>
                        </div>
                        <div class="requirement unmet" id="number-req">
                            <i class="fas fa-circle"></i>
                            <span>Chứa số</span>
                        </div>
                        <div class="requirement unmet" id="special-req">
                            <i class="fas fa-circle"></i>
                            <span>Chứa ký tự đặc biệt</span>
                        </div>
                    </div>
                    <div class="error-message" id="new-password-error">Mật khẩu mới không đáp ứng yêu cầu</div>
                </div>

                <div class="form-group">
                    <label for="confirm-password">Xác nhận mật khẩu mới *</label>
                    <input type="password" id="confirm-password" name="confirm-password" placeholder="Nhập lại mật khẩu mới" required>
                    <i class="fas fa-eye input-icon toggle-password" data-target="confirm-password"></i>
                    <div class="error-message" id="confirm-password-error">Mật khẩu xác nhận không khớp</div>
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary" id="submit-btn">
                        <i class="fas fa-key"></i> Đổi mật khẩu
                    </button>
                    <a href="#" class="btn btn-outline" id="cancel-btn">
                        <i class="fas fa-times"></i> Hủy bỏ
                    </a>
                </div>
            </form>

            <a href="#" class="back-link" id="back-link">
                <i class="fas fa-arrow-left"></i> Quay lại trang chủ
            </a>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // Kiểm tra nếu người dùng đã đăng nhập
            const isLoggedIn = false; // Thay đổi thành true nếu người dùng đã đăng nhập
            const currentUsername = "nguyenvana"; // Thay bằng username thực tế
            
            if (isLoggedIn) {
                // Nếu đã đăng nhập, tự động điền username và disable trường nhập
                $('#username').val(currentUsername).prop('disabled', true);
                $('#user-info').show();
                $('#user-display-name').text(currentUsername);
            }
            
            // Hiển thị/ẩn mật khẩu
            $('.toggle-password').click(function() {
                const target = $(this).data('target');
                const input = $('#' + target);
                const icon = $(this);
                
                if (input.attr('type') === 'password') {
                    input.attr('type', 'text');
                    icon.removeClass('fa-eye').addClass('fa-eye-slash');
                } else {
                    input.attr('type', 'password');
                    icon.removeClass('fa-eye-slash').addClass('fa-eye');
                }
            });

            // Kiểm tra độ mạnh mật khẩu
            $('#new-password').on('input', function() {
                const password = $(this).val();
                checkPasswordStrength(password);
            });

            // Xác thực mật khẩu xác nhận
            $('#confirm-password').on('input', function() {
                const newPassword = $('#new-password').val();
                const confirmPassword = $(this).val();
                
                if (confirmPassword && newPassword !== confirmPassword) {
                    $(this).parent().addClass('error');
                } else {
                    $(this).parent().removeClass('error');
                }
            });

            // Kiểm tra username khi rời khỏi trường
            $('#username').on('blur', function() {
                const username = $(this).val().trim();
                if (username) {
                    // Giả lập kiểm tra username có tồn tại không
                    checkUsernameExists(username);
                }
            });

            // Xử lý form đổi mật khẩu
            $('#change-password-form').on('submit', function(e) {
                e.preventDefault();
                
                // Reset lỗi trước khi validate
                resetErrors();
                
                if (validateForm()) {
                    // Hiển thị trạng thái loading
                    $('#submit-btn').addClass('loading');
                    
                    // Giả lập gửi dữ liệu (trong thực tế sẽ gửi AJAX request)
                    setTimeout(function() {
                        $('#submit-btn').removeClass('loading');
                        showAlert('Đổi mật khẩu thành công!', 'success');
                        
                        // Reset form
                        $('#change-password-form')[0].reset();
                        resetPasswordStrength();
                        
                        // Chuyển hướng sau 2 giây
                        setTimeout(function() {
                            window.location.href = 'login.html';
                        }, 2000);
                    }, 2000);
                }
            });

            // Xử lý nút hủy
            $('#cancel-btn').click(function(e) {
                e.preventDefault();
                if (confirm('Bạn có chắc chắn muốn hủy thay đổi mật khẩu?')) {
                    window.location.href = 'profile.html';
                }
            });

            // Xử lý nút quay lại
            $('#back-link').click(function(e) {
                e.preventDefault();
                window.location.href = 'index.html';
            });

            // Hàm kiểm tra độ mạnh mật khẩu
            function checkPasswordStrength(password) {
                const strengthBar = $('#password-strength');
                const requirements = {
                    length: password.length >= 8,
                    uppercase: /[A-Z]/.test(password),
                    lowercase: /[a-z]/.test(password),
                    number: /\d/.test(password),
                    special: /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)
                };
                
                // Cập nhật hiển thị yêu cầu
                updateRequirements(requirements);
                
                // Tính điểm độ mạnh
                let strength = 0;
                Object.values(requirements).forEach(req => {
                    if (req) strength++;
                });
                
                // Cập nhật thanh độ mạnh
                strengthBar.removeClass('weak medium strong');
                if (strength <= 2) {
                    strengthBar.addClass('weak');
                } else if (strength <= 4) {
                    strengthBar.addClass('medium');
                } else {
                    strengthBar.addClass('strong');
                }
            }
            
            // Cập nhật hiển thị yêu cầu mật khẩu
            function updateRequirements(requirements) {
                $('#length-req').toggleClass('met unmet', requirements.length);
                $('#uppercase-req').toggleClass('met unmet', requirements.uppercase);
                $('#lowercase-req').toggleClass('met unmet', requirements.lowercase);
                $('#number-req').toggleClass('met unmet', requirements.number);
                $('#special-req').toggleClass('met unmet', requirements.special);
                
                // Cập nhật icon
                $('.requirement.met i').removeClass('fa-circle').addClass('fa-check-circle');
                $('.requirement.unmet i').removeClass('fa-check-circle').addClass('fa-circle');
            }
            
            // Reset hiển thị độ mạnh mật khẩu
            function resetPasswordStrength() {
                $('#password-strength').removeClass('weak medium strong');
                $('.requirement').removeClass('met').addClass('unmet');
                $('.requirement i').removeClass('fa-check-circle').addClass('fa-circle');
            }
            
            // Kiểm tra username có tồn tại không
            function checkUsernameExists(username) {
                // Giả lập kiểm tra username
                // Trong thực tế, bạn sẽ gửi AJAX request đến server
                const validUsernames = ['nguyenvana', 'tranthib', 'levanc'];
                
                if (!validUsernames.includes(username.toLowerCase())) {
                    $('#username').parent().addClass('error');
                    $('#username-error').text('Tên đăng nhập không tồn tại');
                } else {
                    $('#username').parent().removeClass('error');
                }
            }
            
            // Validate form
            function validateForm() {
                let isValid = true;
                
                // Kiểm tra username
                const username = $('#username').val().trim();
                if (!username) {
                    $('#username').parent().addClass('error');
                    isValid = false;
                }
                
                // Kiểm tra mật khẩu hiện tại
                if (!$('#current-password').val()) {
                    $('#current-password').parent().addClass('error');
                    isValid = false;
                }
                
                // Kiểm tra mật khẩu mới
                const newPassword = $('#new-password').val();
                if (!newPassword || newPassword.length < 8) {
                    $('#new-password').parent().addClass('error');
                    isValid = false;
                }
                
                // Kiểm tra xác nhận mật khẩu
                const confirmPassword = $('#confirm-password').val();
                if (!confirmPassword || newPassword !== confirmPassword) {
                    $('#confirm-password').parent().addClass('error');
                    isValid = false;
                }
                
                return isValid;
            }
            
            // Reset tất cả lỗi
            function resetErrors() {
                $('.form-group').removeClass('error');
            }
            
            // Hiển thị thông báo
            function showAlert(message, type) {
                const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
                const alertHtml = `
                    <div class="alert ${alertClass}">
                        ${message}
                        <button type="button" class="btn-close" style="float: right; background: none; border: none; font-size: 16px; cursor: pointer;">×</button>
                    </div>`;
                
                $('#alert-container').html(alertHtml);
                
                // Xử lý đóng alert
                $('.btn-close').click(function() {
                    $(this).parent().fadeOut();
                });
                
                // Tự động ẩn sau 5 giây
                setTimeout(() => {
                    $('.alert').fadeOut();
                }, 5000);
            }
        });
    </script>
</body>
</html>