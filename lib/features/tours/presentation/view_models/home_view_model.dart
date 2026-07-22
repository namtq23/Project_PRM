import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/tour_repository.dart';
import '../../models/category_model.dart';
import '../../models/tour_model.dart';
import 'home_state.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  FutureOr<HomeState> build() async {
    return _fetchData();
  }

  Future<HomeState> _fetchData() async {
    final repository = await ref.watch(tourRepositoryProvider.future);

    // Fetch both in parallel
    final results = await Future.wait([
      repository.getCategories(),
      repository.getFeaturedTours(),
    ]);

    return HomeState(
      categories: results[0] as List<CategoryModel>,
      featuredTours: results[1] as List<TourModel>,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchData());
  }
}
