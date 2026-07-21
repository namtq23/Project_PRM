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

  Future<List<Category>> getCategories() async {
    final result = await db.query(DatabaseConstants.categoriesTable);
    return result.map((e) => Category.fromMap(e)).toList();
  }

  Future<List<Tour>> getFeaturedTours() async {
    final result = await db.query(
      DatabaseConstants.toursTable,
      where: 'status = ?',
      whereArgs: ['active'],
      limit: 10,
    );
    return result.map((e) => Tour.fromMap(e)).toList();
  }
}

@riverpod
Future<TourLocalDataSource> tourLocalDataSource(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider).database;
  return TourLocalDataSource(db);
}
