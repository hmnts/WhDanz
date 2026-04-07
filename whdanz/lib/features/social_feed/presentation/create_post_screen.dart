import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/core/theme/app_theme.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _captionController = TextEditingController();
  final _picker = ImagePicker();
  XFile? _selectedVideo;
  bool _isPosting = false;

  Future<void> _pickVideo() async {
    final video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() => _selectedVideo = video);
    }
  }

  Future<void> _recordVideo() async {
    final video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      setState(() => _selectedVideo = video);
    }
  }

  Future<void> _createPost() async {
    if (_captionController.text.trim().isEmpty && _selectedVideo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Agrega un video o escribe un caption'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isPosting = true);
    
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      context.pop();
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCaptionInput(),
                      const SizedBox(height: AppDimensions.lg),
                      _buildMediaSection(),
                      const SizedBox(height: AppDimensions.lg),
                      _buildPoseScoreInfo(),
                      const SizedBox(height: AppDimensions.lg),
                      _buildAdditionalOptions(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.surfaceLight.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, size: 22),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Text(
            'Nueva Publicación',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          GradientButton(
            text: 'Publicar',
            height: 40,
            onPressed: _isPosting ? null : _createPost,
            isLoading: _isPosting,
          ),
        ],
      ),
    );
  }

  Widget _buildCaptionInput() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: AppDimensions.sm),
              Text(
                'Mi cuenta',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          TextField(
            controller: _captionController,
            maxLines: 5,
            minLines: 3,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: '¿Qué estás practicando? Comparte tu progreso...',
              hintStyle: TextStyle(color: AppColors.textMuted),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              _buildTagChip(Icons.music_note, 'Salsa'),
              const SizedBox(width: AppDimensions.sm),
              _buildTagChip(Icons.music_note, 'Bachata'),
              const SizedBox(width: AppDimensions.sm),
              _buildTagChip(Icons.music_note, 'Reggaeton'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Video',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        if (_selectedVideo != null)
          _buildVideoPreview()
        else
          _buildMediaButtons(),
      ],
    );
  }

  Widget _buildVideoPreview() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  _selectedVideo?.name ?? 'video.mp4',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Positioned(
            top: AppDimensions.sm,
            right: AppDimensions.sm,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => setState(() => _selectedVideo = null),
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaButtons() {
    return Row(
      children: [
        Expanded(
          child: _MediaButton(
            icon: Icons.photo_library,
            label: 'Galería',
            color: AppColors.primary,
            onTap: _pickVideo,
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: _MediaButton(
            icon: Icons.videocam,
            label: 'Grabar',
            color: AppColors.secondary,
            onTap: _recordVideo,
          ),
        ),
      ],
    );
  }

  Widget _buildPoseScoreInfo() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.sm),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              ),
              const SizedBox(width: AppDimensions.sm),
              Text(
                'Puntuación de Pose IA',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.textMuted, size: 16),
              const SizedBox(width: AppDimensions.xs),
              Expanded(
                child: Text(
                  'La puntuación se calculará automáticamente al analizar tu video con IA',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: [
              _buildFeatureItem(Icons.timer, 'Análisis rápido'),
              const SizedBox(width: AppDimensions.md),
              _buildFeatureItem(Icons.analytics, 'Precisión 95%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.accent),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opciones adicionales',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        _buildOptionTile(
          icon: Icons.location_on,
          iconColor: AppColors.error,
          title: 'Agregar ubicación',
          onTap: () => _showComingSoon(context),
        ),
        _buildOptionTile(
          icon: Icons.people,
          iconColor: AppColors.primary,
          title: 'Etiquetar personas',
          onTap: () => _showComingSoon(context),
        ),
        _buildOptionTile(
          icon: Icons.public,
          iconColor: AppColors.secondary,
          title: 'Visibilidad',
          subtitle: 'Público',
          onTap: () => _showComingSoon(context),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Próximamente'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MediaButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Ink(
          padding: const EdgeInsets.all(AppDimensions.lg),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: AppDimensions.sm),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
