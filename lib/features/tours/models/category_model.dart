import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int? categoryId;
  final String title;
  final String? description;

  const CategoryModel({this.categoryId, required this.title, this.description});

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'title': title,
      'description': description,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryId: map['category_id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
    );
  }

  @override
  List<Object?> get props => [categoryId, title, description];
}
