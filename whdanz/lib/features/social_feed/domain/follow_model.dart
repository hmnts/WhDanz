import 'package:cloud_firestore/cloud_firestore.dart';

class FollowModel {
  final String id;
  final String followerId;
  final String followingId;
  final DateTime createdAt;

  const FollowModel({
    required this.id,
    required this.followerId,
    required this.followingId,
    required this.createdAt,
  });

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
      id: json['id'] as String,
      followerId: json['followerId'] as String,
      followingId: json['followingId'] as String,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'followerId': followerId,
      'followingId': followingId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class UserStats {
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final bool isFollowing;
  final bool isVerified;

  const UserStats({
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
    this.isVerified = false,
  });

  UserStats copyWith({
    int? postsCount,
    int? followersCount,
    int? followingCount,
    bool? isFollowing,
    bool? isVerified,
  }) {
    return UserStats(
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isFollowing: isFollowing ?? this.isFollowing,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
