import 'dart:convert';
import 'package:flutter/services.dart';

class PoseFrame {
  final int frameIndex;
  final Map<String, double> angles;
  final double tolerance;

  const PoseFrame({
    required this.frameIndex,
    required this.angles,
    required this.tolerance,
  });

  factory PoseFrame.fromJson(Map<String, dynamic> json) {
    return PoseFrame(
      frameIndex: json['frameIndex'] as int,
      angles: Map<String, double>.from(json['angles'] as Map),
      tolerance: (json['tolerance'] as num).toDouble(),
    );
  }
}

class ReferencePose {
  final String name;
  final String style;
  final List<PoseFrame> frames;

  const ReferencePose({
    required this.name,
    required this.style,
    required this.frames,
  });

  factory ReferencePose.fromJson(Map<String, dynamic> json) {
    return ReferencePose(
      name: json['name'] as String,
      style: json['style'] as String,
      frames: (json['frames'] as List)
          .map((f) => PoseFrame.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PoseMatchResult {
  final double score;
  final List<String> incorrectJoints;
  final Map<String, double> deviations;

  const PoseMatchResult({
    required this.score,
    required this.incorrectJoints,
    required this.deviations,
  });
}

class PoseMatcher {
  static Future<ReferencePose?> loadReferencePose(String poseId) async {
    try {
      final jsonString = await rootBundle.loadString('assets/reference_poses/$poseId.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ReferencePose.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  static PoseMatchResult match(Map<String, double> userAngles, ReferencePose reference) {
    if (reference.frames.isEmpty) {
      return const PoseMatchResult(score: 0, incorrectJoints: [], deviations: {});
    }

    final referenceFrame = reference.frames.first;
    final incorrectJoints = <String>[];
    final deviations = <String, double>{};
    double totalDeviation = 0;
    int jointCount = 0;

    for (final joint in referenceFrame.angles.keys) {
      if (userAngles.containsKey(joint)) {
        final userAngle = userAngles[joint]!;
        final refAngle = referenceFrame.angles[joint]!;
        final tolerance = referenceFrame.tolerance;
        
        final deviation = (userAngle - refAngle).abs();
        deviations[joint] = deviation;

        if (deviation > tolerance) {
          incorrectJoints.add(joint);
          totalDeviation += deviation;
        }
        jointCount++;
      }
    }

    if (jointCount == 0) {
      return const PoseMatchResult(score: 0, incorrectJoints: [], deviations: {});
    }

    final avgDeviation = totalDeviation / jointCount;
    final score = ((180 - avgDeviation.clamp(0.0, 180.0)) / 180 * 100).clamp(0.0, 100.0).toDouble();

    return PoseMatchResult(
      score: score,
      incorrectJoints: incorrectJoints,
      deviations: deviations,
    );
  }

  static String getFeedback(PoseMatchResult result) {
    if (result.incorrectJoints.isEmpty) {
      return '¡Perfecto! Continúa así';
    }

    final feedback = StringBuffer();
    for (final joint in result.incorrectJoints) {
      final deviation = result.deviations[joint] ?? 0;
      final direction = deviation > 30 ? 'mucho' : 'un poco';
      
      final jointName = _getJointName(joint);
      feedback.write('$jointName: corrige $direction ');
      
      if (joint.contains('left')) {
        feedback.write('(izquierda) ');
      } else if (joint.contains('right')) {
        feedback.write('(derecha) ');
      }
    }
    
    return feedback.toString().trim();
  }

  static String _getJointName(String joint) {
    final names = {
      'left_elbow': 'codo izquierdo',
      'right_elbow': 'codo derecho',
      'left_knee': 'pierna izquierda',
      'right_knee': 'pierna derecha',
      'left_hip_flexion': 'cadera izquierda',
      'right_hip_flexion': 'cadera derecha',
      'spine_lateral': 'columna',
      'left_shoulder': 'hombro izquierdo',
      'right_shoulder': 'hombro derecho',
    };
    return names[joint] ?? joint;
  }
}
