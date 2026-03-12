import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/angle_calculator.dart';
import '../../domain/pose_matcher.dart';
import 'skeleton_painter.dart';
import '../../../../core/constants/app_constants.dart';

class CameraScreen extends StatefulWidget {
  final String poseId;

  const CameraScreen({super.key, required this.poseId});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  PoseDetector? _poseDetector;
  ReferencePose? _referencePose;
  
  bool _isInitialized = false;
  bool _isProcessing = false;
  Pose? _currentPose;
  List<String> _incorrectJoints = [];
  double _score = 0;
  String _feedback = 'Iniciando...';
  
  Timer? _feedbackTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializePoseDetector();
    _loadReferencePose();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras!.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      _startImageStream();
      setState(() => _isInitialized = true);
    }
  }

  void _initializePoseDetector() {
    final options = PoseDetectorOptions(
      mode: PoseDetectionMode.single,
      model: PoseDetectionModel.lite,
    );
    _poseDetector = PoseDetector(options: options);
  }

  Future<void> _loadReferencePose() async {
    _referencePose = await PoseMatcher.loadReferencePose(widget.poseId);
    if (_referencePose != null) {
      setState(() => _feedback = '¡Listo! Comienza a bailar');
    }
  }

  void _startImageStream() {
    _cameraController?.startImageStream((image) async {
      if (_isProcessing || _poseDetector == null) return;
      _isProcessing = true;

      try {
        final inputImage = _convertCameraImage(image);
        if (inputImage != null) {
          final poses = await _poseDetector!.processImage(inputImage);
          if (poses.isNotEmpty) {
            _processPose(poses.first, inputImage.metadata!.size);
          }
        }
      } catch (e) {
        debugPrint('Error processing image: $e');
      }

      _isProcessing = false;
    });
  }

  InputImage? _convertCameraImage(CameraImage image) {
    try {
      final camera = _cameras!.first;
      final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      
      if (rotation == null || format == null) return null;

      final plane = image.planes.first;
      return InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: plane.bytesPerRow,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  void _processPose(Pose pose, Size imageSize) {
    final landmarks = <int, PoseLandmark>{};
    for (final landmark in pose.landmarks) {
      landmarks[landmark.type.index] = landmark;
    }

    final userAngles = AngleCalculator.calculateAllAngles(landmarks);

    if (_referencePose != null) {
      final result = PoseMatcher.match(userAngles, _referencePose!);
      
      setState(() {
        _currentPose = pose;
        _incorrectJoints = result.incorrectJoints;
        _score = result.score;
        _feedback = PoseMatcher.getFeedback(result);
      });
    } else {
      setState(() {
        _currentPose = pose;
      });
    }
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    _cameraController?.dispose();
    _poseDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (_isInitialized && _cameraController != null)
              Positioned.fill(
                child: CameraPreview(_cameraController!),
              ),
            if (_currentPose != null && _isInitialized)
              Positioned.fill(
                child: CustomPaint(
                  painter: SkeletonPainter(
                    pose: _currentPose!,
                    incorrectJoints: _incorrectJoints,
                    imageSize: Size(
                      _cameraController!.value.previewSize!.height,
                      _cameraController!.value.previewSize!.width,
                    ),
                    canvasSize: MediaQuery.of(context).size,
                  ),
                ),
              ),
            Positioned(
              top: AppDimensions.md,
              left: AppDimensions.md,
              right: AppDimensions.md,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                      vertical: AppDimensions.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    child: Text(
                      _referencePose?.name ?? 'Práctica libre',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: AppDimensions.xl,
              left: AppDimensions.md,
              right: AppDimensions.md,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.md),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${_score.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: _getScoreColor(_score),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        Text(
                          _feedback,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Grabar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                        ),
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

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.poseCorrect;
    if (score >= 50) return AppColors.poseWarning;
    return AppColors.poseIncorrect;
  }
}
