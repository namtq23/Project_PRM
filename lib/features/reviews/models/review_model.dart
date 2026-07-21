import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final int? reviewId;
  final int userId;
  final int tourId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const ReviewModel({
    this.reviewId,
    required this.userId,
    required this.tourId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'review_id': reviewId,
      'user_id': userId,
      'tour_id': tourId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      reviewId: map['review_id'] as int?,
      userId: map['user_id'] as int,
      tourId: map['tour_id'] as int,
      rating: map['rating'] as int,
      comment: map['comment'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
    reviewId,
    userId,
    tourId,
    rating,
    comment,
    createdAt,
  ];
}
