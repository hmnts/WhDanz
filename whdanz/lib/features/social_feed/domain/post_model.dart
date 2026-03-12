class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoURL;
  final String? videoURL;
  final String? thumbnailURL;
  final String caption;
  final double? poseScore;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final bool isLiked;

  const PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoURL,
    this.videoURL,
    this.thumbnailURL,
    required this.caption,
    this.poseScore,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
    this.isLiked = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhotoURL: json['userPhotoURL'] as String?,
      videoURL: json['videoURL'] as String?,
      thumbnailURL: json['thumbnailURL'] as String?,
      caption: json['caption'] as String,
      poseScore: (json['poseScore'] as num?)?.toDouble(),
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isLiked: json['isLiked'] as bool? ?? false,
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
      'poseScore': poseScore,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'createdAt': createdAt,
      'isLiked': isLiked,
    };
  }

  PostModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhotoURL,
    String? videoURL,
    String? thumbnailURL,
    String? caption,
    double? poseScore,
    int? likesCount,
    int? commentsCount,
    DateTime? createdAt,
    bool? isLiked,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoURL: userPhotoURL ?? this.userPhotoURL,
      videoURL: videoURL ?? this.videoURL,
      thumbnailURL: thumbnailURL ?? this.thumbnailURL,
      caption: caption ?? this.caption,
      poseScore: poseScore ?? this.poseScore,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
