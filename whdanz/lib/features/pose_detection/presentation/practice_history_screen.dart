import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/core/theme/app_theme.dart';
import 'package:whdanz/core/widgets/modern_widgets.dart';

class PracticeHistoryScreen extends StatelessWidget {
  const PracticeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = _getMockSessions();

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
              _buildHeader(context),
              _buildStatsSummary(context),
              Expanded(
                child: sessions.isEmpty
                    ? _buildEmptyState(context)
                    : _buildSessionList(context, sessions),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              'Historial',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.glow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('12', 'Prácticas', Icons.fitness_center),
          _buildDivider(),
          _buildStatItem('82%', 'Promedio', Icons.analytics),
          _buildDivider(),
          _buildStatItem('2.5h', 'Tiempo', Icons.timer),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: AppDimensions.xs),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyState(
      icon: Icons.history,
      title: 'Aún no tienes prácticas',
      subtitle: '¡Comienza a practicar para ver tu historial aquí!',
      actionLabel: 'Empezar a practicar',
      onAction: () => context.go('/camera'),
    );
  }

  Widget _buildSessionList(BuildContext context, List<Map<String, dynamic>> sessions) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.md),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _PracticeCard(session: session);
      },
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.glow,
      ),
      child: FloatingActionButton(
        onPressed: () => context.go('/camera'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.play_arrow, color: Colors.white),
      ),
    );
  }

  List<Map<String, dynamic>> _getMockSessions() {
    return [
      {
        'poseName': 'Salsa - Paso básico',
        'poseType': 'Salsa',
        'score': 85,
        'duration': 120,
        'date': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'poseName': 'Bachata - Basic Step',
        'poseType': 'Bachata',
        'score': 72,
        'duration': 90,
        'date': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'poseName': 'Reggaetón - Perreo',
        'poseType': 'Reggaeton',
        'score': 90,
        'duration': 180,
        'date': DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        'poseName': 'Hip Hop - Basics',
        'poseType': 'Hip Hop',
        'score': 65,
        'duration': 150,
        'date': DateTime.now().subtract(const Duration(days: 3)),
      },
      {
        'poseName': 'K-Pop - Coreografía',
        'poseType': 'K-Pop',
        'score': 78,
        'duration': 200,
        'date': DateTime.now().subtract(const Duration(days: 5)),
      },
    ];
  }
}

class _PracticeCard extends StatelessWidget {
  final Map<String, dynamic> session;

  const _PracticeCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final score = session['score'] as int;
    final poseType = session['poseType'] as String;
    final gradient = _getGradient(poseType);
    final color = _getScoreColor(score);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
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
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$score%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Icon(
                        _getScoreIcon(score),
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session['poseName'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildInfoChip(Icons.timer_outlined, '${session['duration']}s'),
                          const SizedBox(width: AppDimensions.sm),
                          _buildInfoChip(Icons.calendar_today, _formatDate(session['date'] as DateTime)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Icon(
                    Icons.replay,
                    color: color,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getGradient(String poseType) {
    switch (poseType) {
      case 'Salsa':
        return AppColors.primaryGradient;
      case 'Bachata':
        return AppColors.secondaryGradient;
      case 'Reggaeton':
        return AppColors.accentGradient;
      case 'K-Pop':
        return const LinearGradient(
          colors: [Colors.pink, Colors.purple],
        );
      case 'Hip Hop':
        return const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        );
      default:
        return AppColors.primaryGradient;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  IconData _getScoreIcon(int score) {
    if (score >= 80) return Icons.emoji_events;
    if (score >= 60) return Icons.thumb_up;
    return Icons.trending_up;
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Hoy';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays}d';
    return 'Hace ${(diff.inDays / 7).floor()}sem';
  }
}
