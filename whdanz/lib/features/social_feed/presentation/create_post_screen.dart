import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_constants.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _captionController = TextEditingController();
  final _picker = ImagePicker();
  XFile? _selectedVideo;

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

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear publicación'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Publicar'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _captionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: '¿Qué estás practicando?',
                border: InputBorder.none,
              ),
            ),
            const Divider(),
            if (_selectedVideo != null)
              Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: AppDimensions.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.videocam,
                        size: 64,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Positioned(
                      top: AppDimensions.sm,
                      right: AppDimensions.sm,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _selectedVideo = null),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickVideo,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galería'),
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _recordVideo,
                    icon: const Icon(Icons.videocam),
                    label: const Text('Grabar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.lg),
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Puntuación de pose',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.textMuted, size: 16),
                      const SizedBox(width: AppDimensions.xs),
                      Text(
                        'La puntuación se calculará automáticamente',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
