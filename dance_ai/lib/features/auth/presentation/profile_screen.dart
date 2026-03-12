import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.surfaceLight,
              child: Icon(
                Icons.person,
                size: 50,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              'Usuario',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              '@usuario',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn(context, '0', 'Publicaciones'),
                _buildStatColumn(context, '0', 'Seguidores'),
                _buildStatColumn(context, '0', 'Siguiendo'),
              ],
            ),
            const SizedBox(height: AppDimensions.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Editar perfil'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mis prácticas',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  _buildPracticeItem(context, 'Salsa - Paso básico', '85%', Icons.music_note),
                  _buildPracticeItem(context, 'Bachata - Basic Step', '72%', Icons.music_note),
                  _buildPracticeItem(context, 'Reggaeton - Perreo', '90%', Icons.music_note),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildPracticeItem(BuildContext context, String title, String score, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: AppDimensions.sm),
          Expanded(child: Text(title)),
          Text(
            score,
            style: TextStyle(
              color: AppColors.poseCorrect,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
