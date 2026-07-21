import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data_sources/tour_local_data_source.dart';
import '../../models/category_model.dart';
import '../../models/tour_model.dart';

part 'tour_repository.g.dart';

class TourRepository {
  final TourLocalDataSource localDataSource;

  TourRepository({required this.localDataSource});

  Future<List<Category>> getCategories() => localDataSource.getCategories();
  Future<List<Tour>> getFeaturedTours() => localDataSource.getFeaturedTours();
  Future<List<Tour>> searchTours(String query) =>
      localDataSource.searchTours(query);

  Future<Tour?> getTourById(int id) => localDataSource.getTourById(id);
}

@riverpod
Future<TourRepository> tourRepository(Ref ref) async {
  final localDataSource = await ref.watch(tourLocalDataSourceProvider.future);
  return TourRepository(localDataSource: localDataSource);
}
