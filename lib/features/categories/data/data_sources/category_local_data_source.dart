import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../core/database/app_database.dart';
import '../../models/category_model.dart';

part 'category_local_data_source.g.dart';

class CategoryLocalDataSource {
  CategoryLocalDataSource(this.database);

  final AppDatabase database;
  bool _isInitialized = false;

  Future<Database> _getDb() async {
    final db = await database.database;
    if (!_isInitialized) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          firestore_id TEXT UNIQUE,
          title TEXT NOT NULL,
          short_name TEXT,
          description TEXT,
          icon TEXT,
          image_url TEXT,
          status TEXT NOT NULL DEFAULT 'active',
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
      _isInitialized = true;
    }
    return db;
  }

  Future<List<CategoryModel>> fetchAllCategories() async {
    final db = await _getDb();
    final List<Map<String, Object?>> maps = await db.rawQuery('''
      SELECT c.*, COUNT(t.id) as tours_count
      FROM categories c
      LEFT JOIN tours t ON c.id = t.category_id
      GROUP BY c.id
      ORDER BY c.id DESC
    ''');
    return maps.map((map) => CategoryModel.fromMap(map)).toList();
  }

  Future<int> insertCategory(CategoryModel category) async {
    final db = await _getDb();
    return await db.insert('categories', category.toMap());
  }

  Future<int> updateCategory(CategoryModel category) async {
    final db = await _getDb();
    if (category.id == null) {
      throw ArgumentError('Category ID cannot be null for updates.');
    }
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await _getDb();
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

@Riverpod(keepAlive: true)
CategoryLocalDataSource categoryLocalDataSource(Ref ref) {
  return CategoryLocalDataSource(ref.watch(appDatabaseProvider));
}
