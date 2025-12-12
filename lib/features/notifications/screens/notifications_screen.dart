import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../state/notifications_cubit.dart';
import '../model/notification.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return _buildNotificationsList(context, state);
        },
      ),
    );
  }

  Widget _buildNotificationsList(
      BuildContext context, NotificationsState state) {
    final notifications = state.notifications;

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Нет уведомлений',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(context, notification);
      },
    );
  }

  Widget _buildNotificationItem(
      BuildContext context, AppNotification notification) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    Color typeColor;
    IconData typeIcon;

    switch (notification.type) {
      case NotificationType.info:
        typeColor = Colors.blue;
        typeIcon = Icons.info_outline;
        break;
      case NotificationType.warning:
        typeColor = Colors.orange;
        typeIcon = Icons.warning_amber_outlined;
        break;
      case NotificationType.success:
        typeColor = Colors.green;
        typeIcon = Icons.check_circle_outline;
        break;
      case NotificationType.error:
        typeColor = Colors.red;
        typeIcon = Icons.error_outline;
        break;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: typeColor.withValues(alpha: 0.1),
        child: Icon(typeIcon, color: typeColor),
      ),
      title: Text(
        notification.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(notification.message),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                dateFormat.format(notification.date),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  notification.typeLabel,
                  style: TextStyle(
                    fontSize: 10,
                    color: typeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
