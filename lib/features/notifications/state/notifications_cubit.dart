import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/notification.dart';

class NotificationsState {
  final List<AppNotification> notifications;

  const NotificationsState({
    this.notifications = const [],
  });

  NotificationsState copyWith({
    List<AppNotification>? notifications,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
    );
  }
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState()) {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    final now = DateTime.now();
    final sampleNotifications = [
      AppNotification(
        id: '1',
        title: 'Пополнение счета',
        message: 'На ваш счет зачислено 85000 ₽',
        type: NotificationType.success,
        priority: NotificationPriority.high,
        date: now.subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: '2',
        title: 'Истекает срок действия карты',
        message: 'Ваша карта **** 1234 истекает через 30 дней',
        type: NotificationType.warning,
        priority: NotificationPriority.medium,
        date: now.subtract(const Duration(days: 1)),
      ),
      AppNotification(
        id: '3',
        title: 'Списание средств',
        message: 'С вашего счета списано 3500 ₽ - Продукты',
        type: NotificationType.info,
        priority: NotificationPriority.low,
        date: now.subtract(const Duration(days: 2)),
      ),
      AppNotification(
        id: '4',
        title: 'Вход в систему',
        message: 'Выполнен вход с нового устройства',
        type: NotificationType.warning,
        priority: NotificationPriority.high,
        date: now.subtract(const Duration(days: 3)),
      ),
      AppNotification(
        id: '5',
        title: 'Начисление процентов',
        message: 'На ваш депозит начислено 450 ₽',
        type: NotificationType.success,
        priority: NotificationPriority.medium,
        date: now.subtract(const Duration(days: 5)),
      ),
    ];

    emit(state.copyWith(notifications: sampleNotifications));
  }
}
