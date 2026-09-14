import 'package:flutter/foundation.dart';
import '../../data/models/app_notification.dart';

class NotificationService {
  NotificationService._internal() {
    _notifications.value = [
      AppNotification(
        id: 'notif_welcome',
        title: 'Welcome to UniWiki',
        message: 'Explore over 14 universities and top academic scholarships across Cambodia.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
        actionTag: 'system',
      ),
      AppNotification(
        id: 'notif_deadline',
        title: 'Upcoming Deadline Alert',
        message: 'Techo Sen Digital Scholarship deadline is closing in 4 days. Prepare your transcripts!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        isRead: false,
        actionTag: 'scholarship',
      ),
    ];
  }

  static final NotificationService instance = NotificationService._internal();

  final ValueNotifier<List<AppNotification>> _notifications = ValueNotifier<List<AppNotification>>([]);

  ValueListenable<List<AppNotification>> get notificationsListenable => _notifications;

  List<AppNotification> get notifications => _notifications.value;

  int get unreadCount => _notifications.value.where((n) => !n.isRead).length;

  void addNotification({
    required String title,
    required String message,
    String? actionTag,
  }) {
    final newNotif = AppNotification(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      timestamp: DateTime.now(),
      isRead: false,
      actionTag: actionTag,
    );

    _notifications.value = [newNotif, ..._notifications.value];
  }

  void markAsRead(String id) {
    _notifications.value = _notifications.value.map((item) {
      if (item.id == id) {
        return item.copyWith(isRead: true);
      }
      return item;
    }).toList();
  }

  void markAllAsRead() {
    _notifications.value = _notifications.value.map((item) {
      return item.copyWith(isRead: true);
    }).toList();
  }

  void clearAll() {
    _notifications.value = [];
  }
}
