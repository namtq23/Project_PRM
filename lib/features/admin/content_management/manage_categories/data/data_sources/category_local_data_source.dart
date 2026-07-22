import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../../../core/database/app_database.dart';
import '../../models/category_model.dart';

part 'category_local_data_source.g.dart';

class CategoryQueryResult {
  final List<CategoryModel> categories;
  final int totalCount;

  const CategoryQueryResult({
    required this.categories,
    required this.totalCount,
  });
}

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

  Future<CategoryQueryResult> fetchCategories({
    required String selectedFilter,
    required String searchQuery,
    required int currentPage,
    required int itemsPerPage,
  }) async {
    final db = await _getDb();

    String whereClause = "";
    final List<dynamic> whereArgs = [];

    final filter = selectedFilter.toLowerCase();
    if (filter != 'all') {
      whereClause += " AND c.status = ?";
      whereArgs.add(filter);
    }

    final queryStr = searchQuery.toLowerCase().trim();
    if (queryStr.isNotEmpty) {
      whereClause +=
          " AND (LOWER(c.title) LIKE ? OR LOWER(c.short_name) LIKE ? OR LOWER(c.description) LIKE ?)";
      final likePattern = "%$queryStr%";
      whereArgs.add(likePattern);
      whereArgs.add(likePattern);
      whereArgs.add(likePattern);
    }

    // 1. Count matching categories
    final countResult = await db.rawQuery('''
      SELECT COUNT(DISTINCT c.id) as count
      FROM categories c
      WHERE 1=1 $whereClause
    ''', whereArgs);
    final totalCount = countResult.first['count'] as int? ?? 0;

    // 2. Fetch paginated categories with tour count
    final offset = (currentPage - 1) * itemsPerPage;
    final fetchQuery =
        '''
      SELECT c.*, COUNT(t.id) as tours_count
      FROM categories c
      LEFT JOIN tours t ON c.id = t.category_id
      WHERE 1=1 $whereClause
      GROUP BY c.id
      ORDER BY c.id DESC
      LIMIT ? OFFSET ?
    ''';
    final List<dynamic> args = [...whereArgs, itemsPerPage, offset];
    final rows = await db.rawQuery(fetchQuery, args);

    final categories = rows.map((row) => CategoryModel.fromMap(row)).toList();
    return CategoryQueryResult(categories: categories, totalCount: totalCount);
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
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}

@Riverpod(keepAlive: true)
CategoryLocalDataSource categoryLocalDataSource(Ref ref) {
  return CategoryLocalDataSource(ref.watch(appDatabaseProvider));
}
