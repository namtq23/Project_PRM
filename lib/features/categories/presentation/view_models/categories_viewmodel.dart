import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repositories/category_repository.dart';
import '../../models/category_model.dart';
import '../../models/categories_state.dart';

part 'categories_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class CategoriesViewModel extends _$CategoriesViewModel {
  @override
  CategoriesState build() {
    // Return initial state with isLoading: true. Data is loaded via loadCategories() on mount or initialization.
    Future.microtask(() => loadCategories());
    return const CategoriesState(isLoading: true);
  }

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final db = await ref.read(appDatabaseProvider).database;

      // 1. Build where clause based on status filter and search query
      String whereClause = "";
      final List<dynamic> whereArgs = [];
      
      final filter = state.selectedFilter.toLowerCase();
      if (filter != 'all') {
        whereClause += " AND c.status = ?";
        whereArgs.add(filter);
      }

      final queryStr = state.searchQuery.toLowerCase().trim();
      if (queryStr.isNotEmpty) {
        whereClause += " AND (LOWER(c.title) LIKE ? OR LOWER(c.short_name) LIKE ? OR LOWER(c.description) LIKE ?)";
        final likePattern = "%$queryStr%";
        whereArgs.add(likePattern);
        whereArgs.add(likePattern);
        whereArgs.add(likePattern);
      }

      // 2. Count total categories matching the filter
      final countResult = await db.rawQuery('''
        SELECT COUNT(DISTINCT c.id) as count
        FROM categories c
        WHERE 1=1 $whereClause
      ''', whereArgs);
      final totalCount = countResult.first['count'] as int? ?? 0;

      // 3. Fetch paginated categories matching the filter
      final offset = (state.currentPage - 1) * state.itemsPerPage;
      final fetchQuery = '''
        SELECT c.*, COUNT(t.id) as tours_count
        FROM categories c
        LEFT JOIN tours t ON c.id = t.category_id
        WHERE 1=1 $whereClause
        GROUP BY c.id
        ORDER BY c.id DESC
        LIMIT ? OFFSET ?
      ''';
      final List<dynamic> args = [...whereArgs, state.itemsPerPage, offset];
      final rows = await db.rawQuery(fetchQuery, args);

      final categories = rows.map((row) => CategoryModel.fromMap(row)).toList();

      state = state.copyWith(
        isLoading: false,
        allCategories: categories,
        filteredCategories: categories,
        totalCount: totalCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void filterCategories(String statusFilter) {
    state = state.copyWith(selectedFilter: statusFilter, currentPage: 1);
    loadCategories();
  }

  void searchCategories(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
    loadCategories();
  }

  void changePage(int page) {
    if (page < 1) return;
    state = state.copyWith(currentPage: page);
    loadCategories();
  }

  Future<bool> addCategory({
    required String title,
    String? shortName,
    String? description,
    String? icon,
    String? imageUrl,
    required String status,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final newCategory = CategoryModel(
        title: title.trim(),
        shortName: shortName?.trim(),
        description: description?.trim(),
        icon: icon?.trim(),
        imageUrl: imageUrl?.trim(),
        status: status,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await ref.read(categoryRepositoryProvider).addCategory(newCategory);
      await loadCategories();
      return true;
    } catch (e) {
      print('Error adding category in ViewModel: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateCategory({
    required int id,
    required String title,
    String? shortName,
    String? description,
    String? icon,
    String? imageUrl,
    required String status,
    DateTime? createdAt,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedCategory = CategoryModel(
        id: id,
        title: title.trim(),
        shortName: shortName?.trim(),
        description: description?.trim(),
        icon: icon?.trim(),
        imageUrl: imageUrl?.trim(),
        status: status,
        createdAt: createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await ref.read(categoryRepositoryProvider).updateCategory(updatedCategory);
      await loadCategories();
      return true;
    } catch (e) {
      print('Error updating category in ViewModel: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref.read(categoryRepositoryProvider).deleteCategory(id);
      await loadCategories();
      return true;
    } catch (e) {
      print('Error deleting category in ViewModel: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
