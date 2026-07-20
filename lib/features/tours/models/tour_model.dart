class TourModel {
  const TourModel({
    this.id,
    this.firestoreId,
    this.categoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? firestoreId;
  final String? categoryId;
  final String title;
  final String description;
  final double price;
  final int durationDays;
  final String status; // e.g. 'active', 'draft', 'inactive'
  final DateTime createdAt;
  final DateTime updatedAt;

  factory TourModel.fromMap(Map<String, Object?> map) => TourModel(
        id: map['id'] as int?,
        firestoreId: map['firestore_id'] as String?,
        categoryId: map['category_id'] as String?,
        title: map['title'] as String,
        description: map['description'] as String,
        price: (map['price'] as num).toDouble(),
        durationDays: map['duration_days'] as int,
        status: map['status'] as String,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'firestore_id': firestoreId,
        'category_id': categoryId,
        'title': title,
        'description': description,
        'price': price,
        'duration_days': durationDays,
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  TourModel copyWith({
    int? id,
    String? firestoreId,
    String? categoryId,
    String? title,
    String? description,
    double? price,
    int? durationDays,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TourModel(
      id: id ?? this.id,
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
  String toString() {
    return 'TourModel(id: $id, firestoreId: $firestoreId, categoryId: $categoryId, title: $title, price: $price, durationDays: $durationDays, status: $status)';
  }
}
