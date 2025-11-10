package com.example.demo.service;

import com.example.demo.model.Notification;
import com.example.demo.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    // Lấy danh sách thông báo theo người dùng
    public List<Notification> getNotificationsByUser(Long userId) {
        return notificationRepository.findByUserId(userId);
    }

    // Lấy thông báo theo ID
    public Notification getNotificationById(Long id) {
        return notificationRepository.findById(id);
    }

    // Đánh dấu 1 thông báo là đã đọc
    public void markAsRead(Long thongBaoId) {
        notificationRepository.markAsRead(thongBaoId);
    }

    // Đánh dấu tất cả thông báo của 1 người dùng là đã đọc
    public void markAllAsRead(Long userId) {
        notificationRepository.markAllAsRead(userId);
    }

    // Xóa thông báo của người dùng
    public boolean deleteNotification(Long notificationId, Long userId) {
        return notificationRepository.deleteNotification(notificationId, userId);
    }

    // Cập nhật trạng thái thông báo (ví dụ: "Đã gửi", "Thất bại", "Đang xử lý")
    public boolean updateNotificationStatus(Long notificationId, String status) {
        return notificationRepository.updateNotificationStatus(notificationId, status);
    }

    // Đếm số thông báo chưa đọc
    public int countUnreadNotifications(Long userId) {
        return notificationRepository.countUnreadNotifications(userId);
    }

    public void processNotificationAction(Long notificationId, Long userId, String action) {
    Notification notification = notificationRepository.findById(notificationId);
    
    if (notification == null) {
        throw new RuntimeException("Không tìm thấy thông báo với ID: " + notificationId);
    }

    // Kiểm tra quyền sở hữu
    if (!notification.getNguoiDungId().equals(userId)) {
        throw new RuntimeException("Bạn không có quyền xử lý thông báo này!");
    }

    // Xử lý hành động
    switch (action.toLowerCase()) {
        case "read":
            markAsRead(notificationId);
            break;

        case "delete":
            deleteNotification(notificationId, userId);
            break;

        case "accept":
            updateNotificationStatus(notificationId, "DA_CHAP_NHAN");
            break;

        case "reject":
            updateNotificationStatus(notificationId, "TU_CHOI");
            break;

        default:
            throw new RuntimeException("Hành động không hợp lệ: " + action);
    }
}

}
