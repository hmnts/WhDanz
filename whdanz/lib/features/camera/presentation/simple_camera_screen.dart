import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/core/theme/app_theme.dart';

class SimpleCameraScreen extends StatefulWidget {
  const SimpleCameraScreen({super.key});

  @override
  State<SimpleCameraScreen> createState() => _SimpleCameraScreenState();
}

class _SimpleCameraScreenState extends State<SimpleCameraScreen> {
  final _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isLoading = false;

  Future<void> _takePhoto() async {
    setState(() => _isLoading = true);
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() => _selectedImage = photo);
      }
    } catch (e) {
      _showError('No se pudo acceder a la cámara');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() => _selectedImage = image);
      }
    } catch (e) {
      _showError('No se pudo seleccionar la imagen');
    }
    setState(() => _isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _clearImage() {
    setState(() => _selectedImage = null);
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
              _buildAppBar(context),
              Expanded(child: _selectedImage != null ? _buildPreview() : _buildOptions()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.sm,
      ),
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
              'Cámara',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          if (_selectedImage != null)
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: _clearImage,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.xl),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: AppShadows.glow,
              ),
              child: Icon(
                Icons.camera_alt,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            ShaderMask(
              shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
              child: Text(
                'Sube una foto o tómate una',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'Captura tu momento de baile',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.xxl),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      text: 'Tomar Foto',
                      icon: Icons.camera_alt,
                      onPressed: _takePhoto,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _pickFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Elegir de Galería'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: AppColors.surfaceLight),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(
                color: AppColors.surfaceLight.withValues(alpha: 0.3),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.file(
              File(_selectedImage!.path),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            left: AppDimensions.lg,
            right: AppDimensions.lg,
            bottom: MediaQuery.of(context).padding.bottom + AppDimensions.lg,
            top: AppDimensions.md,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.surface.withValues(alpha: 0.0),
                AppColors.surface,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _clearImage,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Nueva'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: AppColors.surfaceLight),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: GradientButton(
                      text: 'Subir',
                      icon: Icons.upload,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Foto seleccionada - Crea una publicación para subirla'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                        context.pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
