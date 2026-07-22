import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_constants.dart';
import '../../models/category_model.dart';
import '../../models/tour_model.dart';

part 'tour_local_data_source.g.dart';

class TourLocalDataSource {
  final Database db;

  TourLocalDataSource(this.db);

  Future<List<CategoryModel>> getCategories() async {
    final result = await db.query(DatabaseConstants.categoriesTable);
    return result.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<List<TourModel>> getFeaturedTours() async {
    final result = await db.query(
      DatabaseConstants.toursTable,
      where: 'status = ?',
      whereArgs: ['active'],
      limit: 10,
    );
    return result.map((e) => TourModel.fromMap(e)).toList();
  }

  Future<List<TourModel>> searchTours(String query) async {
    final result = await db.query(
      DatabaseConstants.toursTable,
      where: 'status = ? AND (title LIKE ? OR description LIKE ?)',
      whereArgs: ['active', '%$query%', '%$query%'],
    );
    return result.map((e) => TourModel.fromMap(e)).toList();
  }

  Future<TourModel?> getTourById(int id) async {
    final result = await db.query(
      DatabaseConstants.toursTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return TourModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<TourModel>> fetchAllTours() async {
    final result = await db.query(DatabaseConstants.toursTable);
    return result.map((e) => TourModel.fromMap(e)).toList();
  }

  Future<int> insertTour(TourModel tour) async {
    return await db.insert(DatabaseConstants.toursTable, tour.toMap());
  }

  Future<int> updateTour(TourModel tour) async {
    return await db.update(
      DatabaseConstants.toursTable,
      tour.toMap(),
      where: 'id = ?',
      whereArgs: [tour.id],
    );
  }

  Future<int> deleteTour(int id) async {
    return await db.delete(
      DatabaseConstants.toursTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

@riverpod
Future<TourLocalDataSource> tourLocalDataSource(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider).database;
  return TourLocalDataSource(db);
}
