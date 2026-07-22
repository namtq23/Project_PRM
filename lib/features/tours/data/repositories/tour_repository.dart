import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data_sources/tour_local_data_source.dart';
import '../../models/category_model.dart';
import '../../models/tour_model.dart';

part 'tour_repository.g.dart';

abstract interface class TourRepository {
  Future<List<TourModel>> getAllTours();
  Future<int> addTour(TourModel tour);
  Future<int> updateTour(TourModel tour);
  Future<int> deleteTour(int id);
  Future<List<CategoryModel>> getCategories();
  Future<List<TourModel>> getFeaturedTours();
  Future<List<TourModel>> searchTours(String query);
  Future<TourModel?> getTourById(int id);
}

class TourRepositoryImpl implements TourRepository {
  TourRepositoryImpl(this._localDataSource);

  final TourLocalDataSource _localDataSource;

  @override
  Future<List<TourModel>> getAllTours() async {
    try {
      return await _localDataSource.fetchAllTours();
    } catch (e) {
      throw TourRepositoryException('Không thể tải danh sách tour: $e');
    }
  }

  @override
  Future<int> addTour(TourModel tour) async {
    try {
      return await _localDataSource.insertTour(tour);
    } catch (e) {
      throw TourRepositoryException('Không thể thêm tour mới: $e');
    }
  }

  @override
  Future<int> updateTour(TourModel tour) async {
    try {
      return await _localDataSource.updateTour(tour);
    } catch (e) {
      print('Error in TourRepositoryImpl.updateTour: $e');
      throw TourRepositoryException('Không thể cập nhật thông tin tour: $e');
    }
  }

  @override
  Future<int> deleteTour(int id) async {
    try {
      return await _localDataSource.deleteTour(id);
    } catch (e) {
      throw TourRepositoryException('Không thể xóa tour: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      return await _localDataSource.getCategories();
    } catch (e) {
      throw TourRepositoryException('Không thể tải danh mục: $e');
    }
  }

  @override
  Future<List<TourModel>> getFeaturedTours() async {
    try {
      return await _localDataSource.getFeaturedTours();
    } catch (e) {
      throw TourRepositoryException('Không thể tải tour nổi bật: $e');
    }
  }

  @override
  Future<List<TourModel>> searchTours(String query) async {
    try {
      return await _localDataSource.searchTours(query);
    } catch (e) {
      throw TourRepositoryException('Không thể tìm kiếm tour: $e');
    }
  }

  @override
  Future<TourModel?> getTourById(int id) async {
    try {
      return await _localDataSource.getTourById(id);
    } catch (e) {
      throw TourRepositoryException('Không thể tải thông tin tour: $e');
    }
  }
}

class TourRepositoryException implements Exception {
  TourRepositoryException(this.message);
  final String message;

  @override
  String toString() => message;
}

@Riverpod(keepAlive: true)
Future<TourRepository> tourRepository(Ref ref) async {
  final dataSource = await ref.watch(tourLocalDataSourceProvider.future);
  return TourRepositoryImpl(dataSource);
}
