import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data_sources/review_local_data_source.dart';

part 'review_repository.g.dart';

abstract interface class ReviewRepository {
  Future<ReviewQueryResult> fetchReviews({
    required String selectedRatingFilter,
    required String selectedTourFilter,
    required int currentPage,
    required int pageSize,
  });

  Future<bool> updateReviewStatus(int reviewId, String status);
  Future<bool> deleteReview(int reviewId);
}

class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl(this._dataSource);

  final ReviewLocalDataSource _dataSource;

  @override
  Future<ReviewQueryResult> fetchReviews({
    required String selectedRatingFilter,
    required String selectedTourFilter,
    required int currentPage,
    required int pageSize,
  }) async {
    try {
      return await _dataSource.fetchReviews(
        selectedRatingFilter: selectedRatingFilter,
        selectedTourFilter: selectedTourFilter,
        currentPage: currentPage,
        pageSize: pageSize,
      );
    } catch (e) {
      throw Exception('Không thể tải đánh giá: $e');
    }
  }

  @override
  Future<bool> updateReviewStatus(int reviewId, String status) async {
    try {
      return await _dataSource.updateReviewStatus(reviewId, status);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> deleteReview(int reviewId) async {
    try {
      return await _dataSource.deleteReview(reviewId);
    } catch (_) {
      return false;
    }
  }
}

@Riverpod(keepAlive: true)
ReviewRepository reviewRepository(Ref ref) {
  return ReviewRepositoryImpl(ref.watch(reviewLocalDataSourceProvider));
}
