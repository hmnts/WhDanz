import 'dart:math' as math;

enum JointStatus {
  excellent,
  good,
  fair,
  needsImprovement,
}

class JointAnalysis {
  final String jointName;
  final double userAngle;
  final double referenceAngle;
  final double deviation;
  final double score;
  final JointStatus status;

  const JointAnalysis({
    required this.jointName,
    required this.userAngle,
    required this.referenceAngle,
    required this.deviation,
    required this.score,
    required this.status,
  });
}

class AdvancedPoseMatchResult {
  final double overallScore;
  final List<JointAnalysis> jointResults;
  final String feedback;
  final DateTime timestamp;

  const AdvancedPoseMatchResult({
    required this.overallScore,
    required this.jointResults,
    required this.feedback,
    required this.timestamp,
  });
}

class AdvancedPoseMatcher {
  static const double _toleranceExcellent = 15.0;
  static const double _toleranceGood = 25.0;
  static const double _toleranceFair = 35.0;

  static AdvancedPoseMatchResult match(
    Map<String, double> userAngles,
    Map<String, double> referenceAngles, {
    double tolerance = 15.0,
  }) {
    final jointResults = <JointAnalysis>[];
    double totalScore = 0;
    int jointCount = 0;

    for (final joint in referenceAngles.keys) {
      if (userAngles.containsKey(joint)) {
        final userAngle = userAngles[joint]!;
        final refAngle = referenceAngles[joint]!;
        final deviation = (userAngle - refAngle).abs();

        final score = _calculateScore(deviation, tolerance);
        final status = _getStatus(deviation, tolerance);

        jointResults.add(JointAnalysis(
          jointName: joint,
          userAngle: userAngle,
          referenceAngle: refAngle,
          deviation: deviation,
          score: score,
          status: status,
        ));

        totalScore += score;
        jointCount++;
      }
    }

    final overallScore = jointCount > 0 ? totalScore / jointCount : 0.0;
    final feedback = _generateFeedback(jointResults);

    return AdvancedPoseMatchResult(
      overallScore: overallScore,
      jointResults: jointResults,
      feedback: feedback,
      timestamp: DateTime.now(),
    );
  }

  static double _calculateScore(double deviation, double tolerance) {
    if (deviation <= tolerance * 0.5) {
      return 100.0;
    } else if (deviation <= tolerance) {
      return 100.0 - ((deviation - tolerance * 0.5) / (tolerance * 0.5)) * 20;
    } else if (deviation <= tolerance * 1.5) {
      return 80.0 - ((deviation - tolerance) / (tolerance * 0.5)) * 30;
    } else if (deviation <= tolerance * 2) {
      return 50.0 - ((deviation - tolerance * 1.5) / (tolerance * 0.5)) * 25;
    } else {
      return math.max(0.0, 25.0 - ((deviation - tolerance * 2) / tolerance) * 25);
    }
  }

  static JointStatus _getStatus(double deviation, double tolerance) {
    if (deviation <= tolerance * 0.5) return JointStatus.excellent;
    if (deviation <= tolerance) return JointStatus.good;
    if (deviation <= tolerance * 1.5) return JointStatus.fair;
    return JointStatus.needsImprovement;
  }

  static String _generateFeedback(List<JointAnalysis> results) {
    final poorJoints = results.where((j) => j.status == JointStatus.needsImprovement).toList();
    final fairJoints = results.where((j) => j.status == JointStatus.fair).toList();
    final goodJoints = results.where((j) => j.status == JointStatus.good).toList();
    final excellentJoints = results.where((j) => j.status == JointStatus.excellent).toList();

    if (poorJoints.isEmpty && fairJoints.isEmpty) {
      if (excellentJoints.length == results.length) {
        return '¡Excelente! Tu posición es perfecta. ¡Sigue así!';
      }
      return '¡Muy bien! ${goodJoints.map((j) => _getJointNameSpanish(j.jointName)).join(", ")} están correctos.';
    }

    final feedbackParts = <String>[];

    if (poorJoints.isNotEmpty) {
      feedbackParts.add('Corrige ${poorJoints.map((j) => _getJointNameSpanish(j.jointName)).join(", ")}');
    }

    if (fairJoints.isNotEmpty) {
      feedbackParts.add('Mejora ${fairJoints.map((j) => _getJointNameSpanish(j.jointName)).join(", ")}');
    }

    return feedbackParts.join('. ') + '.';
  }

  static String _getJointNameSpanish(String joint) {
    final names = {
      'left_elbow': 'el codo izquierdo',
      'right_elbow': 'el codo derecho',
      'left_knee': 'la rodilla izquierda',
      'right_knee': 'la rodilla derecha',
      'left_hip_flexion': 'la cadera izquierda',
      'right_hip_flexion': 'la cadera derecha',
      'spine_lateral': 'la columna',
      'left_shoulder_abduction': 'el brazo izquierdo',
      'right_shoulder_abduction': 'el brazo derecho',
      'shoulders_alignment': 'los hombros',
      'hips_alignment': 'las caderas',
      'head_tilt': 'la cabeza',
      'left_side_bend': 'el lado izquierdo',
      'right_side_bend': 'el lado derecho',
    };
    return names[joint] ?? joint;
  }

  static String getDetailedFeedback(AdvancedPoseMatchResult result) {
    final sb = StringBuffer();

    sb.writeln('📊 Análisis de pose:');
    sb.writeln('');

    for (final joint in result.jointResults) {
      final icon = _getStatusIcon(joint.status);
      final statusText = _getStatusText(joint.status);
      sb.writeln('$icon ${_getJointNameSpanish(joint.jointName)}: ${joint.userAngle.toStringAsFixed(1)}° (objetivo: ${joint.referenceAngle.toStringAsFixed(1)}°) - $statusText');
    }

    sb.writeln('');
    sb.writeln('📝 ${result.feedback}');

    return sb.toString();
  }

  static String _getStatusIcon(JointStatus status) {
    switch (status) {
      case JointStatus.excellent:
        return '✅';
      case JointStatus.good:
        return '👍';
      case JointStatus.fair:
        return '⚠️';
      case JointStatus.needsImprovement:
        return '❌';
    }
  }

  static String _getStatusText(JointStatus status) {
    switch (status) {
      case JointStatus.excellent:
        return 'Excelente';
      case JointStatus.good:
        return 'Bien';
      case JointStatus.fair:
        return 'Regular';
      case JointStatus.needsImprovement:
        return 'Necesita mejorar';
    }
  }
}
