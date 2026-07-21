import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final int? reviewId;
  final int userId;
  final int tourId;
  final int rating;
  final String? comment;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Relational display fields (not stored directly in reviews table, but populated via SQL JOIN)
  final String? tourTitle;
  final String? tourImageUrl;
  final String? userName;
  final String? userAvatarUrl;

  const ReviewModel({
    this.reviewId,
    required this.userId,
    required this.tourId,
    required this.rating,
    this.comment,
    this.status = 'pending',
    required this.createdAt,
    required this.updatedAt,
    this.tourTitle,
    this.tourImageUrl,
    this.userName,
    this.userAvatarUrl,
  });

  ReviewModel copyWith({
    int? reviewId,
    int? userId,
    int? tourId,
    int? rating,
    String? comment,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? tourTitle,
    String? tourImageUrl,
    String? userName,
    String? userAvatarUrl,
  }) {
    return ReviewModel(
      reviewId: reviewId ?? this.reviewId,
      userId: userId ?? this.userId,
      tourId: tourId ?? this.tourId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tourTitle: tourTitle ?? this.tourTitle,
      tourImageUrl: tourImageUrl ?? this.tourImageUrl,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (reviewId != null) 'id': reviewId,
      'user_id': userId,
      'tour_id': tourId,
      'rating': rating,
      'comment': comment,
      'status': status,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      reviewId: map['id'] as int? ?? map['review_id'] as int?,
      userId: map['user_id'] as int,
      tourId: map['tour_id'] as int,
      rating: map['rating'] as int,
      comment: map['comment'] as String?,
      status: map['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : DateTime.parse(map['created_at'] as String),
      tourTitle: map['tour_title'] as String?,
      tourImageUrl: map['tour_image_url'] as String?,
      userName: map['user_name'] as String? ?? map['full_name'] as String?,
      userAvatarUrl:
          map['user_avatar_url'] as String? ?? map['avatar_url'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    reviewId,
    userId,
    tourId,
    rating,
    comment,
    status,
    createdAt,
    updatedAt,
    tourTitle,
    tourImageUrl,
    userName,
    userAvatarUrl,
  ];
}
