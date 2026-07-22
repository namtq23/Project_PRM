import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/review_repository.dart';
import '../../models/review_model.dart';

part 'reviews_viewmodel.g.dart';

class ReviewsState {
  final bool isLoading;
  final List<ReviewModel> allReviews;
  final List<ReviewModel> filteredReviews;
  final List<String> tourTitles;
  final String selectedRatingFilter;
  final String selectedTourFilter;
  final int pendingCount;
  final int flaggedCount;
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final String? errorMessage;

  const ReviewsState({
    this.isLoading = false,
    this.allReviews = const [],
    this.filteredReviews = const [],
    this.tourTitles = const [],
    this.selectedRatingFilter = 'All Ratings',
    this.selectedTourFilter = 'All Tours',
    this.pendingCount = 0,
    this.flaggedCount = 0,
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalCount = 0,
    this.errorMessage,
  });

  ReviewsState copyWith({
    bool? isLoading,
    List<ReviewModel>? allReviews,
    List<ReviewModel>? filteredReviews,
    List<String>? tourTitles,
    String? selectedRatingFilter,
    String? selectedTourFilter,
    int? pendingCount,
    int? flaggedCount,
    int? currentPage,
    int? pageSize,
    int? totalCount,
    String? errorMessage,
  }) {
    return ReviewsState(
      isLoading: isLoading ?? this.isLoading,
      allReviews: allReviews ?? this.allReviews,
      filteredReviews: filteredReviews ?? this.filteredReviews,
      tourTitles: tourTitles ?? this.tourTitles,
      selectedRatingFilter: selectedRatingFilter ?? this.selectedRatingFilter,
      selectedTourFilter: selectedTourFilter ?? this.selectedTourFilter,
      pendingCount: pendingCount ?? this.pendingCount,
      flaggedCount: flaggedCount ?? this.flaggedCount,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class ReviewsViewModel extends _$ReviewsViewModel {
  @override
  ReviewsState build() {
    return const ReviewsState(isLoading: true);
  }

  Future<void> loadReviews({bool showLoading = true}) async {
    try {
      if (showLoading && !state.isLoading) {
        state = state.copyWith(isLoading: true);
      }
      final repository = ref.read(reviewRepositoryProvider);
      final result = await repository.fetchReviews(
        selectedRatingFilter: state.selectedRatingFilter,
        selectedTourFilter: state.selectedTourFilter,
        currentPage: state.currentPage,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        isLoading: false,
        allReviews: result.reviews,
        filteredReviews: result.reviews,
        tourTitles: result.tourTitles,
        pendingCount: result.pendingCount,
        flaggedCount: result.flaggedCount,
        totalCount: result.totalCount,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void changePage(int page) {
    if (page < 1) return;
    state = state.copyWith(currentPage: page);
    loadReviews();
  }

  void applyFilters({
    required String ratingFilter,
    required String tourFilter,
  }) {
    state = state.copyWith(
      selectedRatingFilter: ratingFilter,
      selectedTourFilter: tourFilter,
      currentPage: 1,
    );
    loadReviews();
  }

  void clearFilters() {
    state = state.copyWith(
      selectedRatingFilter: 'All Ratings',
      selectedTourFilter: 'All Tours',
      currentPage: 1,
    );
    loadReviews();
  }

  Future<bool> updateReviewStatus(int reviewId, String status) async {
    final success = await ref
        .read(reviewRepositoryProvider)
        .updateReviewStatus(reviewId, status);
    if (success) {
      await loadReviews();
    }
    return success;
  }

  Future<bool> deleteReview(int reviewId) async {
    final success = await ref
        .read(reviewRepositoryProvider)
        .deleteReview(reviewId);
    if (success) {
      await loadReviews();
    }
    return success;
  }
}
