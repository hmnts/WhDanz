import 'dart:math' as math;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum JointType {
  head,
  neck,
  leftShoulder,
  rightShoulder,
  leftElbow,
  rightElbow,
  leftWrist,
  rightWrist,
  leftHip,
  rightHip,
  leftKnee,
  rightKnee,
  leftAnkle,
  rightAnkle,
}

class Vector3D {
  final double x, y, z;

  Vector3D(this.x, this.y, this.z);

  double dot(Vector3D other) => x * other.x + y * other.y + z * other.z;

  double get magnitude => math.sqrt(x * x + y * y + z * z);

  Vector3D subtract(Vector3D other) => Vector3D(x - other.x, y - other.y, z - other.z);
}

class AdvancedAngleCalculator {
  static const Map<int, JointType> landmarkToJoint = {
    0: JointType.head,
    1: JointType.neck,
    11: JointType.leftShoulder,
    12: JointType.rightShoulder,
    13: JointType.leftElbow,
    14: JointType.rightElbow,
    15: JointType.leftWrist,
    16: JointType.rightWrist,
    23: JointType.leftHip,
    24: JointType.rightHip,
    25: JointType.leftKnee,
    26: JointType.rightKnee,
    27: JointType.leftAnkle,
    28: JointType.rightAnkle,
  };

  static double calculateAngle(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
    final radians = math.atan2(c.y - b.y, c.x - b.x) -
        math.atan2(a.y - b.y, a.x - b.x);
    double angle = radians * 180 / math.pi;
    if (angle < 0) angle += 360;
    return angle;
  }

  static double calculateAngle3D(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
    final ax = a.x - b.x;
    final ay = a.y - b.y;
    final az = (a.z ?? 0.0) - (b.z ?? 0.0);
    final bx = c.x - b.x;
    final by = c.y - b.y;
    final bz = (c.z ?? 0.0) - (b.z ?? 0.0);

    final vectorBA = Vector3D(ax, ay, az);
    final vectorBC = Vector3D(bx, by, bz);

    final dotProduct = vectorBA.dot(vectorBC);
    final magBA = vectorBA.magnitude;
    final magBC = vectorBC.magnitude;

    if (magBA == 0 || magBC == 0) return 0;

    final cosAngle = (dotProduct / (magBA * magBC)).clamp(-1.0, 1.0);
    return math.acos(cosAngle) * 180 / math.pi;
  }

  static Map<String, double> calculateAllAngles(Map<int, PoseLandmark> landmarks) {
    final angles = <String, double>{};

    if (_hasRequiredLandmarks(landmarks, [11, 13, 15])) {
      angles['left_elbow'] = calculateAngle(landmarks[11]!, landmarks[13]!, landmarks[15]!);
      angles['left_elbow_3d'] = calculateAngle3D(landmarks[11]!, landmarks[13]!, landmarks[15]!);
    }

    if (_hasRequiredLandmarks(landmarks, [12, 14, 16])) {
      angles['right_elbow'] = calculateAngle(landmarks[12]!, landmarks[14]!, landmarks[16]!);
      angles['right_elbow_3d'] = calculateAngle3D(landmarks[12]!, landmarks[14]!, landmarks[16]!);
    }

    if (_hasRequiredLandmarks(landmarks, [23, 25, 27])) {
      angles['left_knee'] = calculateAngle(landmarks[23]!, landmarks[25]!, landmarks[27]!);
      angles['left_knee_3d'] = calculateAngle3D(landmarks[23]!, landmarks[25]!, landmarks[27]!);
    }

    if (_hasRequiredLandmarks(landmarks, [24, 26, 28])) {
      angles['right_knee'] = calculateAngle(landmarks[24]!, landmarks[26]!, landmarks[28]!);
      angles['right_knee_3d'] = calculateAngle3D(landmarks[24]!, landmarks[26]!, landmarks[28]!);
    }

    if (_hasRequiredLandmarks(landmarks, [11, 23, 25])) {
      angles['left_hip_flexion'] = calculateAngle(landmarks[11]!, landmarks[23]!, landmarks[25]!);
    }

    if (_hasRequiredLandmarks(landmarks, [12, 24, 26])) {
      angles['right_hip_flexion'] = calculateAngle(landmarks[12]!, landmarks[24]!, landmarks[26]!);
    }

    if (_hasRequiredLandmarks(landmarks, [11, 23, 24])) {
      angles['spine_lateral'] = calculateAngle(landmarks[11]!, landmarks[23]!, landmarks[24]!);
    }

    if (_hasRequiredLandmarks(landmarks, [11, 13])) {
      angles['left_shoulder_abduction'] = calculateAngle(landmarks[13]!, landmarks[11]!, landmarks[23]!);
    }

    if (_hasRequiredLandmarks(landmarks, [12, 14])) {
      angles['right_shoulder_abduction'] = calculateAngle(landmarks[14]!, landmarks[12]!, landmarks[24]!);
    }

    if (_hasRequiredLandmarks(landmarks, [11, 12, 23])) {
      angles['shoulders_alignment'] = calculateAngle(landmarks[11]!, landmarks[12]!, landmarks[23]!);
    }

    if (_hasRequiredLandmarks(landmarks, [23, 24])) {
      angles['hips_alignment'] = calculateAngle(landmarks[23]!, landmarks[24]!, landmarks[26]!);
    }

    if (_hasRequiredLandmarks(landmarks, [0, 11, 12])) {
      angles['head_tilt'] = calculateAngle(landmarks[0]!, landmarks[11]!, landmarks[12]!);
    }

    if (_hasRequiredLandmarks(landmarks, [11, 23, 27])) {
      angles['left_side_bend'] = calculateAngle(landmarks[11]!, landmarks[23]!, landmarks[27]!);
    }

    if (_hasRequiredLandmarks(landmarks, [12, 24, 28])) {
      angles['right_side_bend'] = calculateAngle(landmarks[12]!, landmarks[24]!, landmarks[28]!);
    }

    return angles;
  }

  static Map<String, double> calculateBodyPosture(Map<int, PoseLandmark> landmarks) {
    final posture = <String, double>{};

    if (_hasRequiredLandmarks(landmarks, [11, 23, 27])) {
      final leftLegAngle = calculateAngle(landmarks[11]!, landmarks[23]!, landmarks[27]!);
      posture['left_leg_straightness'] = (180 - (leftLegAngle - 180).abs()).abs();
    }

    if (_hasRequiredLandmarks(landmarks, [12, 24, 28])) {
      final rightLegAngle = calculateAngle(landmarks[12]!, landmarks[24]!, landmarks[28]!);
      posture['right_leg_straightness'] = (180 - (rightLegAngle - 180).abs()).abs();
    }

    if (_hasRequiredLandmarks(landmarks, [11, 13, 15])) {
      final leftArmAngle = calculateAngle(landmarks[11]!, landmarks[13]!, landmarks[15]!);
      posture['left_arm_straightness'] = (180 - (leftArmAngle - 180).abs()).abs();
    }

    if (_hasRequiredLandmarks(landmarks, [12, 14, 16])) {
      final rightArmAngle = calculateAngle(landmarks[12]!, landmarks[14]!, landmarks[16]!);
      posture['right_arm_straightness'] = (180 - (rightArmAngle - 180).abs()).abs();
    }

    return posture;
  }

  static double calculateBalance(Map<int, PoseLandmark> landmarks) {
    if (!_hasRequiredLandmarks(landmarks, [11, 12, 23, 24, 27, 28])) {
      return 0.5;
    }

    final leftHipX = landmarks[23]!.x;
    final rightHipX = landmarks[24]!.x;
    final leftAnkleX = landmarks[27]!.x;
    final rightAnkleX = landmarks[28]!.x;

    final hipCenterX = (leftHipX + rightHipX) / 2;
    final ankleCenterX = (leftAnkleX + rightAnkleX) / 2;

    final balance = 1 - (hipCenterX - ankleCenterX).abs() * 2;
    return balance.clamp(0.0, 1.0);
  }

  static bool _hasRequiredLandmarks(Map<int, PoseLandmark> landmarks, List<int> indices) {
    return indices.every((i) => landmarks.containsKey(i) && landmarks[i]!.likelihood > 0.5);
  }
}
