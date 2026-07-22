import 'dart:convert';
import 'package:equatable/equatable.dart';

class TourItinerary extends Equatable {
  final int day;
  final String title;
  final String description;
  final List<String> images;

  const TourItinerary({
    required this.day,
    required this.title,
    required this.description,
    this.images = const [],
  });

  factory TourItinerary.fromMap(Map<String, dynamic> map) {
    return TourItinerary(
      day: map['day'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      images:
          (map['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'title': title,
      'description': description,
      'images': images,
    };
  }

  @override
  List<Object?> get props => [day, title, description, images];
}

class TourModel extends Equatable {
  final int? tourId;
  final String? firestoreId;
  final int? categoryId;
  final String? categoryName;
  final String title;
  final String? description;
  final double price;
  final int durationDays;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Detailed fields
  final String? locationName;
  final List<String> images;
  final List<String> inclusions;
  final List<String> exclusions;
  final List<TourItinerary> itinerary;
  final String? cancellationPolicy;
  final int? maxGroupSize;
  final String? languages;

  const TourModel({
    this.tourId,
    this.firestoreId,
    this.categoryId,
    this.categoryName,
    required this.title,
    this.description,
    required this.price,
    required this.durationDays,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.locationName,
    this.images = const [],
    this.inclusions = const [],
    this.exclusions = const [],
    this.itinerary = const [],
    this.cancellationPolicy,
    this.maxGroupSize,
    this.languages,
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
      categoryName:
          map['category_name'] as String? ?? map['categoryTitle'] as String?,
      title: map['title'] as String,
      description: map['description'] as String?,
      price: (map['price'] as num).toDouble(),
      durationDays: map['duration_days'] as int,
      status: map['status'] as String,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
      locationName: map['location_name'] as String?,
      images: _parseStringList(map['images']),
      inclusions: _parseStringList(map['inclusions']),
      exclusions: _parseStringList(map['exclusions']),
      itinerary: _parseItinerary(map['itinerary']),
      cancellationPolicy: map['cancellation_policy'] as String?,
      maxGroupSize: map['max_group_size'] as int?,
      languages: map['languages'] as String?,
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is String) {
      try {
        final decoded = jsonDecode(value) as List;
        return decoded.map((e) => e.toString()).toList();
      } catch (_) {
        return [];
      }
    }
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  static List<TourItinerary> _parseItinerary(dynamic value) {
    if (value == null) return [];
    List dynamicList = [];
    if (value is String) {
      try {
        dynamicList = jsonDecode(value) as List;
      } catch (_) {}
    } else if (value is List) {
      dynamicList = value;
    }
    return dynamicList
        .map((e) => TourItinerary.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': tourId,
      'firestore_id': firestoreId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'duration_days': durationDays,
      'status': status,
      'created_at':
          createdAt?.toIso8601String() ??
          DateTime.now().toUtc().toIso8601String(),
      'updated_at':
          updatedAt?.toIso8601String() ??
          DateTime.now().toUtc().toIso8601String(),
      'location_name': locationName,
      'images': jsonEncode(images),
      'inclusions': jsonEncode(inclusions),
      'exclusions': jsonEncode(exclusions),
      'itinerary': jsonEncode(itinerary.map((e) => e.toMap()).toList()),
      'cancellation_policy': cancellationPolicy,
      'max_group_size': maxGroupSize,
      'languages': languages,
    };
  }

  TourModel copyWith({
    int? id,
    int? tourId,
    String? firestoreId,
    int? categoryId,
    String? categoryName,
    String? title,
    String? description,
    double? price,
    int? durationDays,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? locationName,
    List<String>? images,
    List<String>? inclusions,
    List<String>? exclusions,
    List<TourItinerary>? itinerary,
    String? cancellationPolicy,
    int? maxGroupSize,
    String? languages,
  }) {
    return TourModel(
      tourId: tourId ?? id ?? this.tourId,
      firestoreId: firestoreId ?? this.firestoreId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      durationDays: durationDays ?? this.durationDays,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      locationName: locationName ?? this.locationName,
      images: images ?? this.images,
      inclusions: inclusions ?? this.inclusions,
      exclusions: exclusions ?? this.exclusions,
      itinerary: itinerary ?? this.itinerary,
      cancellationPolicy: cancellationPolicy ?? this.cancellationPolicy,
      maxGroupSize: maxGroupSize ?? this.maxGroupSize,
      languages: languages ?? this.languages,
    );
  }

  @override
  List<Object?> get props => [
    tourId,
    firestoreId,
    categoryId,
    categoryName,
    title,
    description,
    price,
    durationDays,
    status,
    createdAt,
    updatedAt,
    locationName,
    images,
    inclusions,
    exclusions,
    itinerary,
    cancellationPolicy,
    maxGroupSize,
    languages,
  ];
}
