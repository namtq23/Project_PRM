import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/category_repository.dart';
import '../../models/category_model.dart';
import '../../models/categories_state.dart';

part 'categories_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class CategoriesViewModel extends _$CategoriesViewModel {
  @override
  CategoriesState build() {
    Future.microtask(() => loadCategories());
    return const CategoriesState(isLoading: true);
  }

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repository = ref.read(categoryRepositoryProvider);
      final result = await repository.fetchCategories(
        selectedFilter: state.selectedFilter,
        searchQuery: state.searchQuery,
        currentPage: state.currentPage,
        itemsPerPage: state.itemsPerPage,
      );

      state = state.copyWith(
        isLoading: false,
        allCategories: result.categories,
        filteredCategories: result.categories,
        totalCount: result.totalCount,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
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
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
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
      await ref
          .read(categoryRepositoryProvider)
          .updateCategory(updatedCategory);
      await loadCategories();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
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
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}
