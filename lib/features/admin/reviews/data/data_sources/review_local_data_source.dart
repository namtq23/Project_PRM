import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/database/app_database.dart';
import '../../models/review_model.dart';

part 'review_local_data_source.g.dart';

class ReviewQueryResult {
  final List<ReviewModel> reviews;
  final List<String> tourTitles;
  final int pendingCount;
  final int flaggedCount;
  final int totalCount;

  const ReviewQueryResult({
    required this.reviews,
    required this.tourTitles,
    required this.pendingCount,
    required this.flaggedCount,
    required this.totalCount,
  });
}

class ReviewLocalDataSource {
  ReviewLocalDataSource(this.database);

  final AppDatabase database;

  Future<ReviewQueryResult> fetchReviews({
    required String selectedRatingFilter,
    required String selectedTourFilter,
    required int currentPage,
    required int pageSize,
  }) async {
    final db = await database.database;

    // Schema self-repair: Verify if reviews table has status column, if not add it dynamically
    try {
      await db.execute("SELECT status FROM reviews LIMIT 1");
    } catch (_) {
      try {
        await db.execute(
          "ALTER TABLE reviews ADD COLUMN status TEXT NOT NULL DEFAULT 'pending'",
        );
      } catch (_) {
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
      "SELECT COUNT(*) as count FROM reviews WHERE status = 'pending'",
    );
    final pendingCount = pendingRes.first['count'] as int? ?? 0;

    final flaggedRes = await db.rawQuery(
      "SELECT COUNT(*) as count FROM reviews WHERE status = 'flagged'",
    );
    final flaggedCount = flaggedRes.first['count'] as int? ?? 0;

    // 2. Fetch distinct tour titles for filter dropdown
    final tourRows = await db.rawQuery(
      "SELECT DISTINCT title FROM tours ORDER BY title ASC",
    );
    final tourTitles = tourRows.map((r) => r['title'] as String).toList();

    // 3. Build query filters
    String whereClause = "";
    final List<dynamic> whereArgs = [];

    if (selectedRatingFilter != 'All Ratings') {
      if (selectedRatingFilter == '5 Stars') {
        whereClause += " AND r.rating = 5";
      } else if (selectedRatingFilter == '4 Stars') {
        whereClause += " AND r.rating = 4";
      } else if (selectedRatingFilter == '3 Stars & Below') {
        whereClause += " AND r.rating <= 3";
      }
    }

    if (selectedTourFilter != 'All Tours') {
      whereClause += " AND t.title = ?";
      whereArgs.add(selectedTourFilter);
    }

    // Count total matches
    final countQuery =
        '''
      SELECT COUNT(*) as count
      FROM reviews r
      LEFT JOIN tours t ON r.tour_id = t.id
      LEFT JOIN users u ON r.user_id = u.id
      WHERE 1=1 $whereClause
    ''';
    final totalResult = await db.rawQuery(countQuery, whereArgs);
    final totalCount = totalResult.first['count'] as int? ?? 0;

    // Fetch matching items paginated
    final offset = (currentPage - 1) * pageSize;
    final query =
        '''
      SELECT r.*, t.title as tour_title, t.firestore_id as tour_image_url, u.full_name as user_name, u.avatar_url as user_avatar_url
      FROM reviews r
      LEFT JOIN tours t ON r.tour_id = t.id
      LEFT JOIN users u ON r.user_id = u.id
      WHERE 1=1 $whereClause
      ORDER BY r.created_at DESC
      LIMIT ? OFFSET ?
    ''';
    final List<dynamic> args = [...whereArgs, pageSize, offset];
    final rows = await db.rawQuery(query, args);

    final List<ReviewModel> reviews = rows
        .map((row) => ReviewModel.fromMap(row))
        .toList();

    return ReviewQueryResult(
      reviews: reviews,
      tourTitles: tourTitles,
      pendingCount: pendingCount,
      flaggedCount: flaggedCount,
      totalCount: totalCount,
    );
  }

  Future<bool> updateReviewStatus(int reviewId, String status) async {
    try {
      final db = await database.database;
      final now = DateTime.now().toUtc().toIso8601String();
      await db.update(
        'reviews',
        {'status': status, 'updated_at': now},
        where: 'id = ?',
        whereArgs: [reviewId],
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteReview(int reviewId) async {
    try {
      final db = await database.database;
      await db.delete('reviews', where: 'id = ?', whereArgs: [reviewId]);
      return true;
    } catch (_) {
      return false;
    }
  }
}

@Riverpod(keepAlive: true)
ReviewLocalDataSource reviewLocalDataSource(Ref ref) {
  return ReviewLocalDataSource(ref.watch(appDatabaseProvider));
}
