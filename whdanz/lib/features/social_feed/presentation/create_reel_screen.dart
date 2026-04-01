import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/core/theme/app_theme.dart';

class CreateReelScreen extends StatefulWidget {
  const CreateReelScreen({super.key});

  @override
  State<CreateReelScreen> createState() => _CreateReelScreenState();
}

class _CreateReelScreenState extends State<CreateReelScreen> {
  final _captionController = TextEditingController();
  final _picker = ImagePicker();
  XFile? _selectedVideo;
  String _selectedMusic = '';
  bool _isPosting = false;

  final List<Map<String, String>> _musicOptions = [
    {'title': 'La Gota Fría', 'artist': 'Carlos Vives'},
    {'title': 'Bachata', 'artist': 'Juan Luis Guerra'},
    {'title': 'Butter', 'artist': 'BTS'},
    {'title': 'Despacito', 'artist': 'Luis Fonsi'},
    {'title': 'Safaera', 'artist': 'Bad Bunny'},
  ];

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

  Future<void> _createReel() async {
    if (_selectedVideo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Selecciona un video'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isPosting = true);
    
    await Future.delayed(const Duration(seconds: 2));
    
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildVideoPreview(),
                    const SizedBox(height: AppDimensions.lg),
                    _buildCaptionInput(),
                    const SizedBox(height: AppDimensions.lg),
                    _buildMusicSelector(),
                    const SizedBox(height: AppDimensions.lg),
                    _buildAdditionalOptions(),
                  ],
                ),
              ),
            ),
          ],
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
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, size: 22, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          const Text(
            'Nuevo Reel',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _isPosting ? null : _createReel,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: _selectedVideo != null
                    ? AppColors.primaryGradient
                    : null,
                color: _selectedVideo == null
                    ? Colors.white.withValues(alpha: 0.2)
                    : null,
                borderRadius: BorderRadius.circular(20),
              ),
              child: _isPosting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Compartir',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: _selectedVideo != null
          ? Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          size: 50,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        _selectedVideo!.name,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: AppDimensions.sm,
                  right: AppDimensions.sm,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedVideo = null),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMediaOption(Icons.photo_library, 'Galería', _pickVideo),
                    const SizedBox(width: AppDimensions.xl),
                    _buildMediaOption(Icons.videocam, 'Grabar', _recordVideo),
                  ],
                ),
                const SizedBox(height: AppDimensions.md),
                Text(
                  'Selecciona o graba un video',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMediaOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptionInput() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Caption',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          TextField(
            controller: _captionController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Escribe un caption para tu reel...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicSelector() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.music_note, color: Colors.white, size: 20),
              const SizedBox(width: AppDimensions.sm),
              const Text(
                'Música',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (_selectedMusic.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() => _selectedMusic = ''),
                  child: Text(
                    'Limpiar',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          if (_selectedMusic.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.white, size: 20),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: Text(
                      _selectedMusic,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(Icons.check, color: Colors.white, size: 20),
                ],
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _musicOptions.map((music) {
                final title = music['title']!;
                final artist = music['artist']!;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMusic = '$title - $artist'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      '$title - $artist',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          _buildOptionRow(
            icon: Icons.location_on,
            label: 'Agregar ubicación',
            onTap: () {},
          ),
          const SizedBox(height: AppDimensions.md),
          _buildOptionRow(
            icon: Icons.person_add,
            label: 'Etiquetar personas',
            onTap: () {},
          ),
          const SizedBox(height: AppDimensions.md),
          _buildOptionRow(
            icon: Icons.visibility,
            label: 'Visibilidad: Público',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 20),
          const SizedBox(width: AppDimensions.md),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.chevron_right,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
