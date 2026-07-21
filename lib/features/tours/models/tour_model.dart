import 'dart:convert';

class TourItinerary {
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
      images: List<String>.from(map['images'] ?? []),
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
}

class Tour {
  final int? id;
  final String? firestoreId;
  final int? categoryId;
  final String title;
  final String? description;
  final double price;
  final int durationDays;
  final String status;
  final String createdAt;
  final String updatedAt;

  // New fields for details
  final int maxGroupSize;
  final String languages;
  final String cancellationPolicy;
  final String locationName;
  final List<String> images;
  final List<String> inclusions;
  final List<String> exclusions;
  final List<TourItinerary> itinerary;

  const Tour({
    this.id,
    this.firestoreId,
    this.categoryId,
    required this.title,
    this.description,
    required this.price,
    required this.durationDays,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
    this.maxGroupSize = 15,
    this.languages = 'Việt, Anh',
    this.cancellationPolicy = 'Trước 24h',
    this.locationName = 'Việt Nam',
    this.images = const [],
    this.inclusions = const [],
    this.exclusions = const [],
    this.itinerary = const [],
  });

  factory Tour.fromMap(Map<String, dynamic> map) {
    List<String> parseStringList(dynamic value) {
      if (value == null) return [];
      if (value is String) {
        try {
          return List<String>.from(jsonDecode(value));
        } catch (_) {
          return [];
        }
      }
      return [];
    }

    List<TourItinerary> parseItinerary(dynamic value) {
      if (value == null) return [];
      if (value is String) {
        try {
          final list = jsonDecode(value) as List;
          return list
              .map((e) => TourItinerary.fromMap(e as Map<String, dynamic>))
              .toList();
        } catch (_) {
          return [];
        }
      }
      return [];
    }

    return Tour(
      id: map['id'] as int?,
      firestoreId: map['firestore_id'] as String?,
      categoryId: map['category_id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      price: (map['price'] as num).toDouble(),
      durationDays: map['duration_days'] as int,
      status: map['status'] as String? ?? 'active',
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      maxGroupSize: map['max_group_size'] as int? ?? 15,
      languages: map['languages'] as String? ?? 'Việt, Anh',
      cancellationPolicy: map['cancellation_policy'] as String? ?? 'Trước 24h',
      locationName: map['location_name'] as String? ?? 'Việt Nam',
      images: parseStringList(map['images']),
      inclusions: parseStringList(map['inclusions']),
      exclusions: parseStringList(map['exclusions']),
      itinerary: parseItinerary(map['itinerary']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firestore_id': firestoreId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'duration_days': durationDays,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'max_group_size': maxGroupSize,
      'languages': languages,
      'cancellation_policy': cancellationPolicy,
      'location_name': locationName,
      'images': jsonEncode(images),
      'inclusions': jsonEncode(inclusions),
      'exclusions': jsonEncode(exclusions),
      'itinerary': jsonEncode(itinerary.map((e) => e.toMap()).toList()),
    };
  }
}
