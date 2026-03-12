import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = _getMockNotifications();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    'Sin notificaciones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationTile(notification: notification);
              },
            ),
    );
  }

  List<Map<String, dynamic>> _getMockNotifications() {
    return [
      {
        'type': 'like',
        'title': 'Nuevo like',
        'body': 'Maria Dance dio like a tu publicación',
        'time': DateTime.now().subtract(const Duration(minutes: 5)),
        'read': false,
      },
      {
        'type': 'follow',
        'title': 'Nuevo seguidor',
        'body': 'Juan Baila comenzó a seguirte',
        'time': DateTime.now().subtract(const Duration(hours: 1)),
        'read': false,
      },
      {
        'type': 'comment',
        'title': 'Nuevo comentario',
        'body': 'Sofia KPop评论ó: "¡Excelente técnica!"',
        'time': DateTime.now().subtract(const Duration(hours: 3)),
        'read': true,
      },
      {
        'type': 'place',
        'title': 'Nuevo lugar',
        'body': 'Se agregó un nuevo lugar cerca de ti: Salsa Club Latina',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'read': true,
      },
    ];
  }
}

class _NotificationTile extends StatelessWidget {
  final Map<String, dynamic> notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final isRead = notification['read'] as bool;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isRead ? AppColors.surfaceLight : AppColors.primary,
        child: Icon(
          _getIcon(notification['type'] as String),
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(
        notification['title'] as String,
        style: TextStyle(
          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification['body'] as String),
          Text(
            _formatTime(notification['time'] as DateTime),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      trailing: isRead ? null : Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'follow':
        return Icons.person_add;
      case 'comment':
        return Icons.comment;
      case 'place':
        return Icons.place;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return 'hace ${diff.inDays}d';
    if (diff.inHours > 0) return 'hace ${diff.inHours}h';
    if (diff.inMinutes > 0) return 'hace ${diff.inMinutes}m';
    return 'hace un momento';
  }
}
