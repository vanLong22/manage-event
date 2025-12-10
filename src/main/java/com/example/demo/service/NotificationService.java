package com.example.demo.service;

import com.example.demo.model.Notification;
import com.example.demo.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    public List<Notification> getNotificationsByUser(Long userId) {
        return notificationRepository.findByUserId(userId);
    }

    public Notification getNotificationById(Long id) {
        return notificationRepository.findById(id);
    }

    public void markAsRead(Long thongBaoId) {
        notificationRepository.markAsRead(thongBaoId);
    }

    public void markAllAsRead(Long userId) {
        notificationRepository.markAllAsRead(userId);
    }

    public boolean deleteNotification(Long notificationId, Long userId) {
        return notificationRepository.deleteNotification(notificationId, userId);
    }

    public boolean updateNotificationStatus(Long notificationId, String status) {
        return notificationRepository.updateNotificationStatus(notificationId, status);
    }

    public int countUnreadNotifications(Long userId) {
        return notificationRepository.countUnreadNotifications(userId);
    }

    public void processNotificationAction(Long notificationId, Long userId, String action) {
        Notification notification = notificationRepository.findById(notificationId);
        
        if (notification == null) {
            throw new RuntimeException("Không tìm thấy thông báo với ID: " + notificationId);
        }

        if (!notification.getNguoiDungId().equals(userId)) {
            throw new RuntimeException("Bạn không có quyền xử lý thông báo này!");
        }

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
    
    // Phương thức mới: Tạo thông báo
    public void createNotification(Long userId, String title, String content, String type, Long eventId) {
        Notification notification = new Notification();
        notification.setNguoiDungId(userId);
        notification.setTieuDe(title);
        notification.setNoiDung(content);
        notification.setLoaiThongBao(type);
        notification.setSuKienId(eventId);
        notification.setDaDoc(0L);
        notification.setThoiGian(new Date());
        
        notificationRepository.save(notification);
    }
    
    // Phương thức mới: Lấy thông báo gần đây (giới hạn số lượng)
    public List<Notification> getRecentNotifications(Long userId, int limit) {
        return notificationRepository.findRecentByUserId(userId, limit);
    }
    
    // Phương thức mới: Lấy thông báo theo loại
    public List<Notification> getNotificationsByType(String loaiThongBao, Long userId) {
        return notificationRepository.findByTypeAndUserId(loaiThongBao, userId);
    }
}