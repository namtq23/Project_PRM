import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int? id;
  final String? firestoreId;
  final String title;
  final String? shortName;
  final String? description;
  final String? icon;
  final String? imageUrl;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int toursCount;

  const CategoryModel({
    this.id,
    this.firestoreId,
    required this.title,
    this.shortName,
    this.description,
    this.icon,
    this.imageUrl,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
    this.toursCount = 0,
  });

  CategoryModel copyWith({
    int? id,
    String? firestoreId,
    String? title,
    String? shortName,
    String? description,
    String? icon,
    String? imageUrl,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? toursCount,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      firestoreId: firestoreId ?? this.firestoreId,
      title: title ?? this.title,
      shortName: shortName ?? this.shortName,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      toursCount: toursCount ?? this.toursCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'firestore_id': firestoreId,
      'title': title,
      'short_name': shortName,
      'description': description,
      'icon': icon,
      'image_url': imageUrl,
      'status': status,
      'created_at': createdAt?.toUtc().toIso8601String() ?? DateTime.now().toUtc().toIso8601String(),
      'updated_at': updatedAt?.toUtc().toIso8601String() ?? DateTime.now().toUtc().toIso8601String(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      firestoreId: map['firestore_id'] as String?,
      title: map['title'] as String,
      shortName: map['short_name'] as String?,
      description: map['description'] as String?,
      icon: map['icon'] as String?,
      imageUrl: map['image_url'] as String?,
      status: map['status'] as String? ?? 'active',
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at'] as String) : null,
      updatedAt: map['updated_at'] != null ? DateTime.tryParse(map['updated_at'] as String) : null,
      toursCount: map['tours_count'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firestoreId,
        title,
        shortName,
        description,
        icon,
        imageUrl,
        status,
        createdAt,
        updatedAt,
        toursCount,
      ];

  @override
  String toString() {
    return 'CategoryModel(id: $id, firestoreId: $firestoreId, title: $title, shortName: $shortName, status: $status, toursCount: $toursCount)';
  }
}
