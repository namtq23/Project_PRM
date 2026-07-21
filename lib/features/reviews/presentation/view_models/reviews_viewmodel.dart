import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
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
    // Return initial state with isLoading: true. Data is fetched via loadReviews() explicitly by views.
    return const ReviewsState(isLoading: true);
  }

  Future<void> loadReviews({bool showLoading = true}) async {
    try {
      if (showLoading && !state.isLoading) {
        state = state.copyWith(isLoading: true);
      }
      final db = await ref.read(appDatabaseProvider).database;

      // Schema self-repair: Verify if reviews table has status column, if not add it dynamically
      try {
        await db.execute("SELECT status FROM reviews LIMIT 1");
      } catch (_) {
        try {
          await db.execute("ALTER TABLE reviews ADD COLUMN status TEXT NOT NULL DEFAULT 'pending'");
        } catch (_) {
          // If table itself is missing or alter failed, recreate it
          await db.execute('''
            CREATE TABLE IF NOT EXISTS reviews (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              firestore_id TEXT UNIQUE,
              user_id INTEGER NOT NULL,
              tour_id INTEGER NOT NULL,
              rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
              comment TEXT,
              status TEXT NOT NULL DEFAULT 'pending',
              created_at TEXT NOT NULL,
              updated_at TEXT NOT NULL,
              FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
              FOREIGN KEY (tour_id) REFERENCES tours (id) ON DELETE CASCADE
            )
          ''');
        }
      }

      // 1. Fetch pending & flagged counters
      final pendingRes = await db.rawQuery(
        "SELECT COUNT(*) as count FROM reviews WHERE status = 'pending'"
      );
      final pendingCount = pendingRes.first['count'] as int? ?? 0;

      final flaggedRes = await db.rawQuery(
        "SELECT COUNT(*) as count FROM reviews WHERE status = 'flagged'"
      );
      final flaggedCount = flaggedRes.first['count'] as int? ?? 0;

      // 2. Fetch distinct tour titles for filter dropdown
      final tourRows = await db.rawQuery(
        "SELECT DISTINCT title FROM tours ORDER BY title ASC"
      );
      final tourTitles = tourRows.map((r) => r['title'] as String).toList();

      // 3. Build query filters
      String whereClause = "";
      final List<dynamic> whereArgs = [];

      if (state.selectedRatingFilter != 'All Ratings') {
        if (state.selectedRatingFilter == '5 Stars') {
          whereClause += " AND r.rating = 5";
        } else if (state.selectedRatingFilter == '4 Stars') {
          whereClause += " AND r.rating = 4";
        } else if (state.selectedRatingFilter == '3 Stars & Below') {
          whereClause += " AND r.rating <= 3";
        }
      }

      if (state.selectedTourFilter != 'All Tours') {
        whereClause += " AND t.title = ?";
        whereArgs.add(state.selectedTourFilter);
      }

      // Count total matches (using LEFT JOIN to avoid silent filtering)
      final countQuery = '''
        SELECT COUNT(*) as count
        FROM reviews r
        LEFT JOIN tours t ON r.tour_id = t.id
        LEFT JOIN users u ON r.user_id = u.id
        WHERE 1=1 $whereClause
      ''';
      final totalResult = await db.rawQuery(countQuery, whereArgs);
      final totalCount = totalResult.first['count'] as int? ?? 0;

      // Fetch matching items paginated (using LEFT JOIN to avoid silent filtering)
      final offset = (state.currentPage - 1) * state.pageSize;
      final query = '''
        SELECT r.*, t.title as tour_title, t.firestore_id as tour_image_url, u.full_name as user_name, u.avatar_url as user_avatar_url
        FROM reviews r
        LEFT JOIN tours t ON r.tour_id = t.id
        LEFT JOIN users u ON r.user_id = u.id
        WHERE 1=1 $whereClause
        ORDER BY r.created_at DESC
        LIMIT ? OFFSET ?
      ''';
      final List<dynamic> args = [...whereArgs, state.pageSize, offset];
      final rows = await db.rawQuery(query, args);

      final List<ReviewModel> reviews = rows.map((row) => ReviewModel.fromMap(row)).toList();

      state = state.copyWith(
        isLoading: false,
        allReviews: reviews,
        filteredReviews: reviews,
        tourTitles: tourTitles,
        pendingCount: pendingCount,
        flaggedCount: flaggedCount,
        totalCount: totalCount,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void changePage(int page) {
    if (page < 1) return;
    state = state.copyWith(currentPage: page);
    loadReviews();
  }

  void applyFilters({required String ratingFilter, required String tourFilter}) {
    state = state.copyWith(
      selectedRatingFilter: ratingFilter,
      selectedTourFilter: tourFilter,
      currentPage: 1, // Reset to first page
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
    try {
      final db = await ref.read(appDatabaseProvider).database;
      final now = DateTime.now().toUtc().toIso8601String();
      await db.update(
        'reviews',
        {
          'status': status,
          'updated_at': now,
        },
        where: 'id = ?',
        whereArgs: [reviewId],
      );
      await loadReviews();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteReview(int reviewId) async {
    try {
      final db = await ref.read(appDatabaseProvider).database;
      await db.delete(
        'reviews',
        where: 'id = ?',
        whereArgs: [reviewId],
      );
      await loadReviews();
      return true;
    } catch (_) {
      return false;
    }
  }
}
