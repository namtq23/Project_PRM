import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data_sources/category_local_data_source.dart';
import '../../models/category_model.dart';

part 'category_repository.g.dart';

abstract interface class CategoryRepository {
  Future<List<CategoryModel>> getAllCategories();
  Future<int> addCategory(CategoryModel category);
  Future<int> updateCategory(CategoryModel category);
  Future<int> deleteCategory(int id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._localDataSource);

  final CategoryLocalDataSource _localDataSource;

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      return await _localDataSource.fetchAllCategories();
    } catch (e) {
      throw CategoryRepositoryException('Không thể tải danh sách danh mục: $e');
    }
  }

  @override
  Future<int> addCategory(CategoryModel category) async {
    try {
      return await _localDataSource.insertCategory(category);
    } catch (e) {
      throw CategoryRepositoryException('Không thể thêm danh mục mới: $e');
    }
  }

  @override
  Future<int> updateCategory(CategoryModel category) async {
    try {
      return await _localDataSource.updateCategory(category);
    } catch (e) {
      throw CategoryRepositoryException('Không thể cập nhật danh mục: $e');
    }
  }

  @override
  Future<int> deleteCategory(int id) async {
    try {
      return await _localDataSource.deleteCategory(id);
    } catch (e) {
      throw CategoryRepositoryException('Không thể xóa danh mục: $e');
    }
  }
}

class CategoryRepositoryException implements Exception {
  CategoryRepositoryException(this.message);
  final String message;

  @override
  String toString() => message;
}

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) {
  return CategoryRepositoryImpl(ref.watch(categoryLocalDataSourceProvider));
}
