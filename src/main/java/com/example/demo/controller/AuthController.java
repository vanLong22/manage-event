package com.example.demo.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.UserService;

import jakarta.servlet.http.HttpSession;

import java.util.List;

@Controller
public class AuthController {

    private final UserRepository userRepository;
    private final UserService userService;

    @Autowired
    public AuthController(UserRepository userRepository, UserService userService) {
        this.userRepository = userRepository;
        this.userService = userService;
    }

    // Trang đăng nhập + đăng ký
    @GetMapping("/login")
    public String showLoginRegisterPage(Model model) {
        model.addAttribute("user", new User());
        return "dndk";
    }
    

    @PostMapping("/api/login")
    public ResponseEntity<?> apiLogin(@RequestBody Map<String, String> request, HttpSession session) {
        try {
            String tenDangNhap = request.get("username");
            String matKhau = request.get("password");

            if (tenDangNhap == null || matKhau == null || tenDangNhap.trim().isEmpty() || matKhau.isEmpty()) {
                return ResponseEntity.ok(Map.of(
                    "success", false,
                    "message", "Vui lòng nhập đầy đủ thông tin!"
                ));
            }

            User user = userService.login(tenDangNhap, matKhau);

            if (user != null) {
                // LƯU USERID VÀO SESSION
                session.setAttribute("userId", user.getNguoiDungId());
                session.setAttribute("vaiTro", user.getVaiTro()); // Tùy chọn: lưu luôn vai trò

                String vaiTro = user.getVaiTro();
                String redirectUrl = switch (vaiTro) {
                    case "NguoiDung" -> "participant/renter/join";
                    case "Admin" -> "admin/admin";
                    default -> "organizer/organizer/organize";
                };

                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "Đăng nhập thành công!");
                response.put("redirect", redirectUrl);
                response.put("vaiTro", vaiTro);
                response.put("user", Map.of(
                    "id", user.getNguoiDungId(),
                    "tenDangNhap", user.getTenDangNhap(),
                    "hoTen", user.getHoTen()
                ));

                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.ok(Map.of(
                    "success", false,
                    "message", "Tên đăng nhập hoặc mật khẩu không đúng!"
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.ok(Map.of(
                "success", false,
                "message", "Lỗi hệ thống: " + e.getMessage()
            ));
        }
    }

    // Xử lý đăng ký (form submit)
    @PostMapping("/register-process")
    public String registerProcess(User user, 
                                @RequestParam("confirmPassword") String confirmPassword,
                                Model model) {
        try {
            // Kiểm tra mật khẩu xác nhận
            if (!user.getMatKhau().equals(confirmPassword)) {
                model.addAttribute("error", "Mật khẩu xác nhận không khớp!");
                model.addAttribute("user", user);
                return "dndk";
            }

            // Kiểm tra username đã tồn tại
            User existingUser = userRepository.findByUsername(user.getTenDangNhap());
            if (existingUser != null) {
                model.addAttribute("error", "Tên đăng nhập đã tồn tại!");
                model.addAttribute("user", user);
                return "dndk";
            }

            // Kiểm tra email đã tồn tại
            List<User> usersByEmail = userService.findByEmail(user.getEmail());
            if (!usersByEmail.isEmpty()) {
                model.addAttribute("error", "Email đã được đăng ký!");
                model.addAttribute("user", user);
                return "dndk";
            }

            // Set vai trò mặc định
            if (user.getVaiTro() == null || user.getVaiTro().isEmpty()) {
                user.setVaiTro("NguoiDung"); // Mặc định là người dùng thường
            }

            // Lưu user
            userService.save(user);
            
            model.addAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
            return "redirect:/dndk?success=true";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Có lỗi xảy ra khi đăng ký: " + e.getMessage());
            model.addAttribute("user", user);
            return "dndk";
        }
    }
    /*
    @GetMapping("/renter/join")
    public String renterJoinPage() {
        return "renter/join"; // tên view hoặc trả về dữ liệu tùy theo app
    }
    @GetMapping("/admin/admin")
    public String adminDashboardPage() {
        return "admin/dashboard"; // hoặc "admin/admin.html" nếu dùng Thymeleaf
    }
    @GetMapping("/organizer/organize")
    public String organizerPage() {
        return "organizer/organize"; // tên view hoặc JSON nếu là REST
    }
    */

}