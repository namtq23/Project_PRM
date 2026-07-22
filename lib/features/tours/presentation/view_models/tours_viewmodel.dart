import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repositories/tour_repository.dart';
import '../../models/tour_model.dart';
import '../../models/tours_state.dart';

part 'tours_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class ToursViewModel extends _$ToursViewModel {
  @override
  ToursState build() {
    Future.microtask(() => loadTours());
    return const ToursState(isLoading: true);
  }

  Future<void> loadTours() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final db = await ref.read(appDatabaseProvider).database;

      // 1. Build where clause based on status filter and search query
      String whereClause = "";
      final List<dynamic> whereArgs = [];

      final filter = state.selectedFilter.toLowerCase();
      if (filter != 'all') {
        whereClause += " AND t.status = ?";
        whereArgs.add(filter);
      }

      final queryStr = state.searchQuery.toLowerCase().trim();
      if (queryStr.isNotEmpty) {
        whereClause +=
            " AND (LOWER(t.title) LIKE ? OR LOWER(t.description) LIKE ? OR LOWER(t.category_id) LIKE ?)";
        final likePattern = "%$queryStr%";
        whereArgs.add(likePattern);
        whereArgs.add(likePattern);
        whereArgs.add(likePattern);
      }

      String sqlWhere = "";
      if (whereClause.isNotEmpty) {
        sqlWhere = " WHERE 1=1 $whereClause";
      }

      // 2. Count total matching tours for pagination
      final countResult = await db.rawQuery(
        "SELECT COUNT(*) as count FROM tours t$sqlWhere",
        whereArgs,
      );
      final totalCount = countResult.first['count'] as int? ?? 0;

      // 3. Fetch paginated tours matching the filter
      final offset = (state.currentPage - 1) * state.itemsPerPage;
      final query =
          '''
        SELECT t.*, c.title as category_name
        FROM tours t
        LEFT JOIN categories c ON t.category_id = c.id
        $sqlWhere
        ORDER BY t.id DESC
        LIMIT ? OFFSET ?
      ''';
      final List<dynamic> args = [...whereArgs, state.itemsPerPage, offset];
      final rows = await db.rawQuery(query, args);

      final tours = rows.map((row) => TourModel.fromMap(row)).toList();

      state = state.copyWith(
        isLoading: false,
        allTours: tours,
        filteredTours: tours,
        totalCount: totalCount,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void filterTours(String statusFilter) {
    state = state.copyWith(selectedFilter: statusFilter, currentPage: 1);
    loadTours();
  }

  void searchTours(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
    loadTours();
  }

  void changePage(int page) {
    if (page < 1) return;
    state = state.copyWith(currentPage: page);
    loadTours();
  }

  int? _mapCategoryToId(String? category) {
    if (category == null) return null;
    final normalized = category.trim().toLowerCase();
    if (normalized == '1' ||
        normalized.contains('thám hiểm') ||
        normalized.contains('luxury')) {
      return 1;
    }
    if (normalized == '2' ||
        normalized.contains('thành thị') ||
        normalized.contains('urban')) {
      return 2;
    }
    if (normalized.contains('bắc âu') || normalized.contains('nordic')) {
      return 1;
    }
    if (normalized.contains('hải trình') || normalized.contains('nautical')) {
      return 2;
    }
    return int.tryParse(category);
  }

  Future<bool> addTour({
    required String title,
    required String description,
    required double price,
    required int durationDays,
    required String status,
    String? categoryId,
    String? firestoreId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final newTour = TourModel(
        title: title.trim(),
        description: description.trim(),
        price: price,
        durationDays: durationDays,
        status: status,
        categoryId: _mapCategoryToId(categoryId),
        firestoreId: firestoreId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await (await ref.read(tourRepositoryProvider.future)).addTour(newTour);
      await loadTours();
      return true;
    } catch (e) {
      print('Error adding tour in ViewModel: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateTour({
    required int id,
    required String title,
    required String description,
    required double price,
    required int durationDays,
    required String status,
    String? categoryId,
    String? firestoreId,
    DateTime? createdAt,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedTour = TourModel(
        tourId: id,
        title: title.trim(),
        description: description.trim(),
        price: price,
        durationDays: durationDays,
        status: status,
        categoryId: _mapCategoryToId(categoryId),
        firestoreId: firestoreId,
        createdAt: createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await (await ref.read(
        tourRepositoryProvider.future,
      )).updateTour(updatedTour);
      await loadTours();
      return true;
    } catch (e) {
      print('Error updating tour in ViewModel: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteTour(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await (await ref.read(tourRepositoryProvider.future)).deleteTour(id);
      await loadTours();
      return true;
    } catch (e) {
      print('Error deleting tour in ViewModel: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}
