import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../core/database/app_database.dart';
import '../../models/tour_model.dart';

part 'tour_data_source.g.dart';

class TourLocalDataSource {
  TourLocalDataSource(this.database);

  final AppDatabase database;
  bool _isInitialized = false;

  Future<Database> _getDb() async {
    final db = await database.database;
    if (!_isInitialized) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS tours (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          firestore_id TEXT,
          category_id TEXT,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          price REAL NOT NULL,
          duration_days INTEGER NOT NULL,
          status TEXT NOT NULL DEFAULT 'active',
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
      _isInitialized = true;
    }
    return db;
  }

  Future<List<TourModel>> fetchAllTours() async {
    final db = await _getDb();
    final List<Map<String, Object?>> maps = await db.query('tours', orderBy: 'id DESC');
    return maps.map((map) => TourModel.fromMap(map)).toList();
  }

  Future<int> insertTour(TourModel tour) async {
    final db = await _getDb();
    return await db.insert('tours', tour.toMap());
  }

  Future<int> updateTour(TourModel tour) async {
    final db = await _getDb();
    if (tour.id == null) {
      throw ArgumentError('Tour ID cannot be null for updates.');
    }
    return await db.update(
      'tours',
      tour.toMap(),
      where: 'id = ?',
      whereArgs: [tour.id],
    );
  }

  Future<int> deleteTour(int id) async {
    final db = await _getDb();
    return await db.delete(
      'tours',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

@Riverpod(keepAlive: true)
TourLocalDataSource tourLocalDataSource(Ref ref) {
  return TourLocalDataSource(ref.watch(appDatabaseProvider));
}
