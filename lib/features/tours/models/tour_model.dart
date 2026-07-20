import 'package:equatable/equatable.dart';

class TourModel extends Equatable {
  final int? tourId;
  final String? firestoreId;
  final int? categoryId;
  final String title;
  final String? description;
  final double price;
  final int durationDays;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TourModel({
    this.tourId,
    this.firestoreId,
    this.categoryId,
    required this.title,
    this.description,
    required this.price,
    required this.durationDays,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? get id => tourId;

  factory TourModel.fromMap(Map<String, dynamic> map) {
    int? parsedCategoryId;
    if (map['category_id'] != null) {
      if (map['category_id'] is int) {
        parsedCategoryId = map['category_id'] as int;
      } else if (map['category_id'] is String) {
        parsedCategoryId = int.tryParse(map['category_id'] as String);
      }
    }
    
    int? parsedTourId = map['tour_id'] as int? ?? map['id'] as int?;

    return TourModel(
      tourId: parsedTourId,
      firestoreId: map['firestore_id'] as String?,
      categoryId: parsedCategoryId,
      title: map['title'] as String,
      description: map['description'] as String?,
      price: (map['price'] as num).toDouble(),
      durationDays: map['duration_days'] as int,
      status: map['status'] as String,
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at'] as String) : null,
      updatedAt: map['updated_at'] != null ? DateTime.tryParse(map['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': tourId,
      'tour_id': tourId,
      'firestore_id': firestoreId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'duration_days': durationDays,
      'status': status,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toUtc().toIso8601String(),
      'updated_at': updatedAt?.toIso8601String() ?? DateTime.now().toUtc().toIso8601String(),
    };
  }

  TourModel copyWith({
    int? id,
    int? tourId,
    String? firestoreId,
    int? categoryId,
    String? title,
    String? description,
    double? price,
    int? durationDays,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TourModel(
      tourId: tourId ?? id ?? this.tourId,
      firestoreId: firestoreId ?? this.firestoreId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      durationDays: durationDays ?? this.durationDays,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        tourId,
        firestoreId,
        categoryId,
        title,
        description,
        price,
        durationDays,
        status,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'TourModel(tourId: $tourId, firestoreId: $firestoreId, categoryId: $categoryId, title: $title, price: $price, durationDays: $durationDays, status: $status)';
  }
}
