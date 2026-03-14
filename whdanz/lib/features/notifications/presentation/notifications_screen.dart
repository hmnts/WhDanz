import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/core/theme/app_theme.dart';
import 'package:whdanz/core/widgets/modern_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = 'Todas';

  @override
  Widget build(BuildContext context) {
    final notifications = _getMockNotifications();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.backgroundSecondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildFilterChips(),
              Expanded(
                child: notifications.isEmpty
                    ? _buildEmptyState()
                    : _buildNotificationList(notifications),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          ShaderMask(
            shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
            child: Text(
              'Notificaciones',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: IconButton(
              icon: const Icon(Icons.done_all, size: 22),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Todas', 'No leídas', 'Likes', 'Seguidores', 'Comentarios'];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == _filter;
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.sm),
            child: ModernChip(
              label: filter,
              isSelected: isSelected,
              onTap: () => setState(() => _filter = filter),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.notifications_none,
      title: 'Sin notificaciones',
      subtitle: 'Cuando recibas notificaciones, aparecerán aquí',
    );
  }

  Widget _buildNotificationList(List<Map<String, dynamic>> notifications) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.md),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _NotificationCard(notification: notification);
      },
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
        'user': 'Maria Dance',
      },
      {
        'type': 'follow',
        'title': 'Nuevo seguidor',
        'body': 'Juan Baila comenzó a seguirte',
        'time': DateTime.now().subtract(const Duration(hours: 1)),
        'read': false,
        'user': 'Juan Baila',
      },
      {
        'type': 'comment',
        'title': 'Nuevo comentario',
        'body': 'Sofia KPop dijo: "¡Excelente técnica!"',
        'time': DateTime.now().subtract(const Duration(hours: 3)),
        'read': true,
        'user': 'Sofia KPop',
      },
      {
        'type': 'achievement',
        'title': 'Logro desbloqueado',
        'body': '¡Felicidades! Has completado 10 prácticas',
        'time': DateTime.now().subtract(const Duration(hours: 5)),
        'read': false,
      },
      {
        'type': 'place',
        'title': 'Nuevo lugar',
        'body': 'Se agregó un nuevo lugar cerca de ti: Salsa Club Latina',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'read': true,
      },
      {
        'type': 'score',
        'title': 'Nueva puntuación',
        'body': '¡Nuevo récord! 95% en Salsa - Paso básico',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'read': true,
      },
    ];
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final isRead = notification['read'] as bool;
    final type = notification['type'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      decoration: BoxDecoration(
        color: isRead ? AppColors.surface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: isRead
              ? AppColors.surfaceLight.withValues(alpha: 0.2)
              : AppColors.primary.withValues(alpha: 0.3),
        ),
        boxShadow: isRead ? null : [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(context),
                      const SizedBox(height: 4),
                      _buildBody(context),
                      const SizedBox(height: 6),
                      _buildTime(context),
                    ],
                  ),
                ),
                if (!isRead) _buildUnreadDot(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final type = notification['type'] as String;
    final color = _getColor(type);

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        _getIcon(type),
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final isRead = notification['read'] as bool;

    return Text(
      notification['title'] as String,
      style: TextStyle(
        fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
        fontSize: 15,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Text(
      notification['body'] as String,
      style: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTime(BuildContext context) {
    return Text(
      _formatTime(notification['time'] as DateTime),
      style: TextStyle(
        color: AppColors.textMuted,
        fontSize: 12,
      ),
    );
  }

  Widget _buildUnreadDot() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: AppShadows.glow,
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
      case 'achievement':
        return Icons.emoji_events;
      case 'score':
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case 'like':
        return AppColors.error;
      case 'follow':
        return AppColors.primary;
      case 'comment':
        return AppColors.accent;
      case 'place':
        return AppColors.warning;
      case 'achievement':
        return Colors.amber;
      case 'score':
        return AppColors.success;
      default:
        return AppColors.primary;
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
