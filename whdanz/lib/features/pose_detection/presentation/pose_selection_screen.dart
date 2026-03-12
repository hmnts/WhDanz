import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class PoseSelectionScreen extends StatelessWidget {
  const PoseSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final poses = [
      {'id': 'salsa_paso_basico', 'name': 'Salsa - Paso básico', 'difficulty': 'Principiante', 'icon': Icons.music_note},
      {'id': 'bachata_basic', 'name': 'Bachata - Basic Step', 'difficulty': 'Principiante', 'icon': Icons.music_note},
      {'id': 'reggaeton_perreo', 'name': 'Reggaetón - Perreo', 'difficulty': 'Intermedio', 'icon': Icons.music_note},
      {'id': 'kpop_basic', 'name': 'K-Pop - Coreografía', 'difficulty': 'Avanzado', 'icon': Icons.music_note},
      {'id': 'hiphop_basic', 'name': 'Hip Hop - Basics', 'difficulty': 'Principiante', 'icon': Icons.music_note},
      {'id': 'salsa_turn', 'name': 'Salsa - Giro', 'difficulty': 'Intermedio', 'icon': Icons.music_note},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.selectPose),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.md),
        itemCount: poses.length,
        itemBuilder: (context, index) {
          final pose = poses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: AppDimensions.md),
            child: ListTile(
              contentPadding: const EdgeInsets.all(AppDimensions.md),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(
                  pose['icon'] as IconData,
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                pose['name'] as String,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                pose['difficulty'] as String,
                style: TextStyle(
                  color: _getDifficultyColor(pose['difficulty'] as String),
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  context.go('/camera/practice/${pose['id']}');
                },
                child: const Text('Practicar'),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Principiante':
        return AppColors.poseCorrect;
      case 'Intermedio':
        return AppColors.poseWarning;
      case 'Avanzado':
        return AppColors.poseIncorrect;
      default:
        return AppColors.textMuted;
    }
  }
}
