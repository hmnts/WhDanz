import 'package:cloud_firestore/cloud_firestore.dart';

class PracticeSession {
  final String id;
  final String userId;
  final String poseId;
  final String poseName;
  final double score;
  final int durationSeconds;
  final DateTime createdAt;

  const PracticeSession({
    required this.id,
    required this.userId,
    required this.poseId,
    required this.poseName,
    required this.score,
    required this.durationSeconds,
    required this.createdAt,
  });

  factory PracticeSession.fromJson(Map<String, dynamic> json) {
    return PracticeSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      poseId: json['poseId'] as String,
      poseName: json['poseName'] as String,
      score: (json['score'] as num).toDouble(),
      durationSeconds: json['durationSeconds'] as int,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'poseId': poseId,
      'poseName': poseName,
      'score': score,
      'durationSeconds': durationSeconds,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
