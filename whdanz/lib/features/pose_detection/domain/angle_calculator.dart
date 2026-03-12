import 'dart:math' as math;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class AngleCalculator {
  static double calculateAngle(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
    final radians = math.atan2(c.y - b.y, c.x - b.x) -
        math.atan2(a.y - b.y, a.x - b.x);
    double angle = radians * 180 / math.pi;
    if (angle < 0) angle += 360;
    return angle;
  }

  static Map<String, double> calculateAllAngles(Map<int, PoseLandmark> landmarks) {
    final angles = <String, double>{};

    if (_hasRequiredLandmarks(landmarks, [11, 13, 15])) {
      angles['left_elbow'] = calculateAngle(
        landmarks[11]!,
        landmarks[13]!,
        landmarks[15]!,
      );
    }

    if (_hasRequiredLandmarks(landmarks, [12, 14, 16])) {
      angles['right_elbow'] = calculateAngle(
        landmarks[12]!,
        landmarks[14]!,
        landmarks[16]!,
      );
    }

    if (_hasRequiredLandmarks(landmarks, [23, 25, 27])) {
      angles['left_knee'] = calculateAngle(
        landmarks[23]!,
        landmarks[25]!,
        landmarks[27]!,
      );
    }

    if (_hasRequiredLandmarks(landmarks, [24, 26, 28])) {
      angles['right_knee'] = calculateAngle(
        landmarks[24]!,
        landmarks[26]!,
        landmarks[28]!,
      );
    }

    if (_hasRequiredLandmarks(landmarks, [11, 23, 25])) {
      angles['left_hip_flexion'] = calculateAngle(
        landmarks[11]!,
        landmarks[23]!,
        landmarks[25]!,
      );
    }

    if (_hasRequiredLandmarks(landmarks, [12, 24, 26])) {
      angles['right_hip_flexion'] = calculateAngle(
        landmarks[12]!,
        landmarks[24]!,
        landmarks[26]!,
      );
    }

    if (_hasRequiredLandmarks(landmarks, [11, 23, 24])) {
      angles['spine_lateral'] = calculateAngle(
        landmarks[11]!,
        landmarks[23]!,
        landmarks[24]!,
      );
    }

    if (_hasRequiredLandmarks(landmarks, [11, 13])) {
      angles['left_shoulder'] = calculateAngle(
        landmarks[13]!,
        landmarks[11]!,
        PoseLandmark(
          type: PoseLandmarkType.rightShoulder,
          x: landmarks[11]!.x + 0.1,
          y: landmarks[11]!.y - 0.1,
          z: 0,
          likelihood: 1,
        ),
      );
    }

    return angles;
  }

  static bool _hasRequiredLandmarks(Map<int, PoseLandmark> landmarks, List<int> indices) {
    return indices.every((i) => landmarks.containsKey(i) && landmarks[i]!.likelihood > 0.5);
  }
}
