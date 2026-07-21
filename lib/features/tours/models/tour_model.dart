import 'package:equatable/equatable.dart';

class TourModel extends Equatable {
  final int? tourId;
  final int? categoryId;
  final String title;
  final String? description;
  final double price;
  final int durationDays;
  final String status;

  const TourModel({
    this.tourId,
    this.categoryId,
    required this.title,
    this.description,
    required this.price,
    required this.durationDays,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'tour_id': tourId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'duration_days': durationDays,
      'status': status,
    };
  }

  factory TourModel.fromMap(Map<String, dynamic> map) {
    return TourModel(
      tourId: map['tour_id'] as int?,
      categoryId: map['category_id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      price: (map['price'] as num).toDouble(),
      durationDays: map['duration_days'] as int,
      status: map['status'] as String,
    );
  }

  @override
  List<Object?> get props => [
    tourId,
    categoryId,
    title,
    description,
    price,
    durationDays,
    status,
  ];
}
