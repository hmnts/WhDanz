import 'package:flutter/material.dart';
import 'package:whdanz/core/constants/app_constants.dart';

class PracticeHistoryScreen extends StatelessWidget {
  const PracticeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = _getMockSessions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de práctica'),
      ),
      body: sessions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    'Aún no tienes prácticas',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    '¡Comienza a practicar!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.md),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return _PracticeCard(session: session);
              },
            ),
    );
  }

  List<Map<String, dynamic>> _getMockSessions() {
    return [
      {
        'poseName': 'Salsa - Paso básico',
        'score': 85,
        'duration': 120,
        'date': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'poseName': 'Bachata - Basic Step',
        'score': 72,
        'duration': 90,
        'date': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'poseName': 'Reggaetón - Perreo',
        'score': 90,
        'duration': 180,
        'date': DateTime.now().subtract(const Duration(days: 2)),
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
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getScoreColor(score).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Center(
                child: Text(
                  '$score%',
                  style: TextStyle(
                    color: _getScoreColor(score),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session['poseName'] as String,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: AppDimensions.xs),
                      Text(
                        '${session['duration']}s',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: AppDimensions.md),
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: AppDimensions.xs),
                      Text(
                        _formatDate(session['date'] as DateTime),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              _getScoreIcon(score),
              color: _getScoreColor(score),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.poseCorrect;
    if (score >= 50) return AppColors.poseWarning;
    return AppColors.poseIncorrect;
  }

  IconData _getScoreIcon(int score) {
    if (score >= 80) return Icons.emoji_events;
    if (score >= 50) return Icons.thumb_up;
    return Icons.trending_up;
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Hoy';
    if (diff.inDays == 1) return 'Ayer';
    return 'Hace ${diff.inDays}d';
  }
}
