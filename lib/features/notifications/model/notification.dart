enum NotificationPriority {
  low,
  medium,
  high,
}

enum NotificationType {
  info,
  warning,
  success,
  error,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime date;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.date,
  });

  String get typeLabel {
    switch (type) {
      case NotificationType.info:
        return 'Информация';
      case NotificationType.warning:
        return 'Предупреждение';
      case NotificationType.success:
        return 'Успех';
      case NotificationType.error:
        return 'Ошибка';
    }
  }

  String get priorityLabel {
    switch (priority) {
      case NotificationPriority.low:
        return 'Низкий';
      case NotificationPriority.medium:
        return 'Средний';
      case NotificationPriority.high:
        return 'Высокий';
    }
  }
}
