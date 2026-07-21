import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/tour_repository.dart';
import '../../models/tour_model.dart';

part 'search_view_model.g.dart';

@riverpod
class SearchViewModel extends _$SearchViewModel {
  @override
  FutureOr<List<Tour>?> build() {
    return null; // null means no search performed yet
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncData(null);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(tourRepositoryProvider.future);
      return repository.searchTours(query.trim());
    });
  }

  void clear() {
    state = const AsyncData(null);
  }
}
