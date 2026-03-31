import 'package:cloud_firestore/cloud_firestore.dart';

class ReelModel {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoURL;
  final String videoURL;
  final String? thumbnailURL;
  final String caption;
  final String? musicTitle;
  final String? musicArtist;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final DateTime createdAt;
  final bool isLiked;
  final List<String> tags;

  const ReelModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoURL,
    required this.videoURL,
    this.thumbnailURL,
    required this.caption,
    this.musicTitle,
    this.musicArtist,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.viewsCount = 0,
    required this.createdAt,
    this.isLiked = false,
    this.tags = const [],
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhotoURL: json['userPhotoURL'] as String?,
      videoURL: json['videoURL'] as String,
      thumbnailURL: json['thumbnailURL'] as String?,
      caption: json['caption'] as String,
      musicTitle: json['musicTitle'] as String?,
      musicArtist: json['musicArtist'] as String?,
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      sharesCount: json['sharesCount'] as int? ?? 0,
      viewsCount: json['viewsCount'] as int? ?? 0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isLiked: json['isLiked'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhotoURL': userPhotoURL,
      'videoURL': videoURL,
      'thumbnailURL': thumbnailURL,
      'caption': caption,
      'musicTitle': musicTitle,
      'musicArtist': musicArtist,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'viewsCount': viewsCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'isLiked': isLiked,
      'tags': tags,
    };
  }

  ReelModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhotoURL,
    String? videoURL,
    String? thumbnailURL,
    String? caption,
    String? musicTitle,
    String? musicArtist,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    int? viewsCount,
    DateTime? createdAt,
    bool? isLiked,
    List<String>? tags,
  }) {
    return ReelModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoURL: userPhotoURL ?? this.userPhotoURL,
      videoURL: videoURL ?? this.videoURL,
      thumbnailURL: thumbnailURL ?? this.thumbnailURL,
      caption: caption ?? this.caption,
      musicTitle: musicTitle ?? this.musicTitle,
      musicArtist: musicArtist ?? this.musicArtist,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
      tags: tags ?? this.tags,
    );
  }
}
