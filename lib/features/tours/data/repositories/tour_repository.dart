import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data_sources/tour_data_source.dart';
import '../../models/tour_model.dart';

part 'tour_repository.g.dart';

abstract interface class TourRepository {
  Future<List<TourModel>> getAllTours();
  Future<int> addTour(TourModel tour);
  Future<int> updateTour(TourModel tour);
  Future<int> deleteTour(int id);
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
}

class TourRepositoryException implements Exception {
  TourRepositoryException(this.message);
  final String message;

  @override
  String toString() => message;
}

@Riverpod(keepAlive: true)
TourRepository tourRepository(Ref ref) {
  return TourRepositoryImpl(ref.watch(tourLocalDataSourceProvider));
}
