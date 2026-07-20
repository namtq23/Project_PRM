import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/tour_repository.dart';
import '../../models/tour_model.dart';
import '../../models/tours_state.dart';

part 'tours_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class ToursViewModel extends _$ToursViewModel {
  @override
  ToursState build() {
    Future.microtask(() => loadTours());
    return const ToursState();
  }

  Future<void> loadTours() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final tours = await ref.read(tourRepositoryProvider).getAllTours();
      state = state.copyWith(
        isLoading: false,
        allTours: tours,
      );
      _applyFilter();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void filterTours(String statusFilter) {
    state = state.copyWith(selectedFilter: statusFilter);
    _applyFilter();
  }

  void _applyFilter() {
    final filter = state.selectedFilter.toLowerCase();
    if (filter == 'all') {
      state = state.copyWith(filteredTours: state.allTours);
    } else {
      final filtered = state.allTours.where((tour) {
        return tour.status.toLowerCase() == filter;
      }).toList();
      state = state.copyWith(filteredTours: filtered);
    }
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
        categoryId: categoryId,
        firestoreId: firestoreId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await ref.read(tourRepositoryProvider).addTour(newTour);
      await loadTours();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
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
    required DateTime createdAt,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedTour = TourModel(
        id: id,
        title: title.trim(),
        description: description.trim(),
        price: price,
        durationDays: durationDays,
        status: status,
        categoryId: categoryId,
        firestoreId: firestoreId,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
      await ref.read(tourRepositoryProvider).updateTour(updatedTour);
      await loadTours();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteTour(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref.read(tourRepositoryProvider).deleteTour(id);
      await loadTours();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
