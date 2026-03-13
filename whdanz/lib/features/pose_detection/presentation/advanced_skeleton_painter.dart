import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/features/pose_detection/domain/advanced_pose_matcher.dart';

class AdvancedSkeletonPainter extends CustomPainter {
  final Pose pose;
  final List<JointAnalysis> jointResults;
  final Size imageSize;
  final Size canvasSize;
  final bool showScores;
  final double confidenceThreshold;

  AdvancedSkeletonPainter({
    required this.pose,
    required this.jointResults,
    required this.imageSize,
    required this.canvasSize,
    this.showScores = true,
    this.confidenceThreshold = 0.5,
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
    [0, 11],
    [0, 12],
    [11, 23],
    [12, 24],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = canvasSize.width / imageSize.width;
    final scaleY = canvasSize.height / imageSize.height;

    final correctPaint = Paint()
      ..color = AppColors.poseCorrect
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final incorrectPaint = Paint()
      ..color = AppColors.poseIncorrect
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final warningPaint = Paint()
      ..color = AppColors.poseWarning
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final landmarks = pose.landmarks;
    final points = <int, Offset>{};

    for (final landmark in landmarks.values) {
      if (landmark.likelihood >= confidenceThreshold) {
        final x = landmark.x * scaleX;
        final y = landmark.y * scaleY;
        points[landmark.type.index] = Offset(x, y);
      }
    }

    for (final connection in connections) {
      if (points.containsKey(connection[0]) && points.containsKey(connection[1])) {
        final jointName = _getJointName(connection[0]);
        final analysis = jointResults.where((j) => j.jointName == jointName).firstOrNull;
        
        Paint paint;
        if (analysis != null) {
          paint = _getPaintForStatus(analysis.status, correctPaint, warningPaint, incorrectPaint);
        } else {
          paint = correctPaint;
        }

        final glowPaintColored = glowPaint..color = paint.color.withValues(alpha: 0.3);
        canvas.drawLine(
          points[connection[0]]!,
          points[connection[1]]!,
          glowPaintColored,
        );
        canvas.drawLine(
          points[connection[0]]!,
          points[connection[1]]!,
          paint,
        );
      }
    }

    for (final landmark in landmarks.values) {
      if (landmark.likelihood >= confidenceThreshold) {
        final x = landmark.x * scaleX;
        final y = landmark.y * scaleY;
        final point = Offset(x, y);
        final jointName = _getJointName(landmark.type.index);
        final analysis = jointResults.where((j) => j.jointName == jointName).firstOrNull;

        Color dotColor;
        if (analysis != null) {
          dotColor = _getColorForStatus(analysis.status);
        } else {
          dotColor = landmark.likelihood > 0.8 ? AppColors.poseCorrect : AppColors.poseWarning;
        }

        final glowPaintColored = glowPaint..color = dotColor.withValues(alpha: 0.4);
        canvas.drawCircle(point, 10, glowPaintColored);
        canvas.drawCircle(point, 6, dotPaint..color = dotColor);
        canvas.drawCircle(point, 3, dotPaint..color = Colors.white);
      }
    }
  }

  Paint _getPaintForStatus(
    JointStatus status,
    Paint correct,
    Paint warning,
    Paint incorrect,
  ) {
    switch (status) {
      case JointStatus.excellent:
        return correct;
      case JointStatus.good:
        return correct;
      case JointStatus.fair:
        return warning;
      case JointStatus.needsImprovement:
        return incorrect;
    }
  }

  Color _getColorForStatus(JointStatus status) {
    switch (status) {
      case JointStatus.excellent:
        return AppColors.poseCorrect;
      case JointStatus.good:
        return const Color(0xFF4ADE80);
      case JointStatus.fair:
        return AppColors.poseWarning;
      case JointStatus.needsImprovement:
        return AppColors.poseIncorrect;
    }
  }

  String _getJointName(int index) {
    const names = {
      11: 'left_shoulder_abduction',
      12: 'right_shoulder_abduction',
      13: 'left_elbow',
      14: 'right_elbow',
      15: 'left_wrist',
      16: 'right_wrist',
      23: 'left_hip_flexion',
      24: 'right_hip_flexion',
      25: 'left_knee',
      26: 'right_knee',
      27: 'left_ankle',
      28: 'right_ankle',
    };
    return names[index] ?? 'unknown';
  }

  @override
  bool shouldRepaint(covariant AdvancedSkeletonPainter oldDelegate) {
    return oldDelegate.pose != pose ||
        oldDelegate.jointResults != jointResults;
  }
}
