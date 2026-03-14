import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/core/theme/app_theme.dart';
import 'package:whdanz/features/auth/domain/auth_notifier.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isOwnProfile = authState.user?.id == userId || userId == 'me';

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
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context, isOwnProfile),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildProfileHeader(context, authState, isOwnProfile),
                  _buildStats(context),
                  _buildActions(context, isOwnProfile),
                  _buildPracticeSection(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isOwnProfile) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      title: Text(
        isOwnProfile ? 'Mi Perfil' : 'Perfil',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        if (isOwnProfile)
          Container(
            margin: const EdgeInsets.only(right: AppDimensions.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, size: 22),
              onPressed: () => context.push('/settings'),
            ),
          ),
        Container(
          margin: const EdgeInsets.only(right: AppDimensions.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: IconButton(
            icon: const Icon(Icons.share_outlined, size: 22),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthState authState, bool isOwnProfile) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: AppShadows.glow,
            ),
            child: authState.user?.photoURL != null
                ? ClipOval(
                    child: Image.network(
                      authState.user!.photoURL!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
          ),
          const SizedBox(height: AppDimensions.md),
          ShaderMask(
            shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
            child: Text(
              authState.user?.displayName ?? 'Usuario',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            authState.user?.email ?? '@usuario',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified,
                  size: 16,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 6),
                Text(
                  'Baile Profesional',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, '24', 'Publicaciones', Icons.photo_library_outlined),
          _buildDivider(),
          _buildStatItem(context, '1.2K', 'Seguidores', Icons.people_outline),
          _buildDivider(),
          _buildStatItem(context, '350', 'Siguiendo', Icons.person_add_outlined),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: AppDimensions.xs),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.surfaceLight,
    );
  }

  Widget _buildActions(BuildContext context, bool isOwnProfile) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Row(
        children: [
          Expanded(
            child: isOwnProfile
                ? GradientButton(
                    text: 'Editar perfil',
                    icon: Icons.edit,
                    onPressed: () => context.push('/edit-profile'),
                  )
                : GradientButton(
                    text: 'Seguir',
                    icon: Icons.person_add,
                    gradient: AppColors.secondaryGradient,
                    onPressed: () {},
                  ),
          ),
          const SizedBox(width: AppDimensions.md),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: IconButton(
              icon: const Icon(Icons.message_outlined),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mis Prácticas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/camera/history'),
                child: Text(
                  'Ver todas',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          _buildPracticeCard(
            context,
            title: 'Salsa - Paso básico',
            subtitle: 'Última práctica: hace 2 días',
            score: 85,
            icon: Icons.music_note,
            gradient: AppColors.primaryGradient,
          ),
          const SizedBox(height: AppDimensions.sm),
          _buildPracticeCard(
            context,
            title: 'Bachata - Basic Step',
            subtitle: 'Última práctica: hace 5 días',
            score: 72,
            icon: Icons.music_note,
            gradient: AppColors.secondaryGradient,
          ),
          const SizedBox(height: AppDimensions.sm),
          _buildPracticeCard(
            context,
            title: 'Reggaeton - Perreo',
            subtitle: 'Última práctica: hace 1 semana',
            score: 90,
            icon: Icons.music_note,
            gradient: AppColors.accentGradient,
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required int score,
    required IconData icon,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.sm,
              vertical: AppDimensions.xs,
            ),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Text(
              '$score%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
