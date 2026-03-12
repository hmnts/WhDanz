import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../../../core/constants/app_constants.dart';

class SkeletonPainter extends CustomPainter {
  final Pose pose;
  final List<String> incorrectJoints;
  final Size imageSize;
  final Size canvasSize;

  SkeletonPainter({
    required this.pose,
    required this.incorrectJoints,
    required this.imageSize,
    required this.canvasSize,
  });

  static const List<List<int>> connections = [
    [11, 12],
    [11, 13],
    [13, 15],
    [12, 14],
    [14, 16],
    [11, 23],
    [12, 24],
    [23, 24],
    [23, 25],
    [25, 27],
    [24, 26],
    [26, 28],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = canvasSize.width / imageSize.width;
    final scaleY = canvasSize.height / imageSize.height;

    final paint = Paint()
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final correctPaint = Paint()
      ..color = AppColors.poseCorrect
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final incorrectPaint = Paint()
      ..color = AppColors.poseIncorrect
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..style = PaintingStyle.fill;

    final landmarks = pose.landmarks;
    final points = <int, Offset>{};

    for (final landmark in landmarks) {
      final x = landmark.x * scaleX;
      final y = landmark.y * scaleY;
      points[landmark.type.index] = Offset(x, y);
    }

    for (final connection in connections) {
      if (points.containsKey(connection[0]) && points.containsKey(connection[1])) {
        final isIncorrect = _isJointIncorrect(connection);
        
        canvas.drawLine(
          points[connection[0]]!,
          points[connection[1]]!,
          isIncorrect ? incorrectPaint : correctPaint,
        );
      }
    }

    for (final landmark in landmarks) {
      final x = landmark.x * scaleX;
      final y = landmark.y * scaleY;
      final point = Offset(x, y);
      final jointName = _getJointName(landmark.type.index);
      final isIncorrect = incorrectJoints.contains(jointName);

      dotPaint.color = isIncorrect ? AppColors.poseIncorrect : AppColors.poseCorrect;
      canvas.drawCircle(point, 6, dotPaint);
    }
  }

  bool _isJointIncorrect(List<int> connection) {
    final jointNames = connection.map(_getJointName).toList();
    return jointNames.any((name) => incorrectJoints.contains(name));
  }

  String _getJointName(int index) {
    const names = {
      11: 'left_shoulder',
      12: 'right_shoulder',
      13: 'left_elbow',
      14: 'right_elbow',
      15: 'left_wrist',
      16: 'right_wrist',
      23: 'left_hip',
      24: 'right_hip',
      25: 'left_knee',
      26: 'right_knee',
      27: 'left_ankle',
      28: 'right_ankle',
    };
    return names[index] ?? 'unknown';
  }

  @override
  bool shouldRepaint(covariant SkeletonPainter oldDelegate) {
    return oldDelegate.pose != pose ||
        oldDelegate.incorrectJoints != incorrectJoints;
  }
}
