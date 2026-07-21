class Category {
  final int? id;
  final String? firestoreId;
  final String title;
  final String? description;
  final String createdAt;
  final String updatedAt;

  const Category({
    this.id,
    this.firestoreId,
    required this.title,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      firestoreId: map['firestore_id'] as String?,
      title: map['title'] as String,
      description: map['description'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firestore_id': firestoreId,
      'title': title,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
