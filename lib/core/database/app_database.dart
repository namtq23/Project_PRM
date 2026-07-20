import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'database_constants.dart';

part 'app_database.g.dart';

class AppDatabase {
  Database? _database;

  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    final DatabaseFactory factory;
    final String databasePath;
    if (kIsWeb) {
      factory = databaseFactoryFfiWebNoWebWorker;
      databasePath = DatabaseConstants.databaseName;
    } else {
      sqfliteFfiInit();
      factory = databaseFactoryFfi;
      final databasesDirectory = await factory.getDatabasesPath();
      databasePath = path.join(
        databasesDirectory,
        DatabaseConstants.databaseName,
      );
    }
    final db = await factory.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: DatabaseConstants.databaseVersion,
        onCreate: (database, _) =>
            database.execute(DatabaseConstants.createUsersTable),
      ),
    );

    // Create tables if they do not exist
    await db.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL UNIQUE,
        description TEXT
      )
    ''');

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

    final nowString = DateTime.now().toUtc().toIso8601String();

    // Insert Admin User
    await db.execute('''
      INSERT OR IGNORE INTO users (
        email, password_hash, full_name, role, status, auth_provider, created_at, updated_at
      ) VALUES (
        'hoanganh2k52@gmail.com',
        '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
        'Hoàng Anh',
        'admin',
        'active',
        'local',
        '$nowString',
        '$nowString'
      )
    ''');
    await db.execute('''
      UPDATE users SET role = 'admin' WHERE email = 'hoanganh2k52@gmail.com'
    ''');

    // Seed Categories
    await db.execute('''
      INSERT OR IGNORE INTO categories (id, title, description) VALUES
      (1, 'Thám Hiểm Sang Trọng', 'Trải nghiệm du lịch cao cấp'),
      (2, 'Thành Thị Thượng Lưu', 'Kỳ nghỉ dưỡng cao cấp tại các thành phố lớn')
    ''');

    // Seed Tours
    await db.execute('''
      INSERT OR REPLACE INTO tours (id, category_id, title, description, price, duration_days, status, created_at, updated_at) VALUES
      (1, '1', 'Bay Khám Phá Kỳ Quan Serengeti', 'Trải nghiệm thám hiểm hoang dã cao cấp tại Tanzania', 310000000.0, 10, 'active', '$nowString', '$nowString'),
      (2, '2', 'Nghỉ Dưỡng Thượng Lưu Neo-Tokyo', 'Khám phá Tokyo đẳng cấp dành cho doanh nhân, Nhật Bản', 220000000.0, 5, 'draft', '$nowString', '$nowString'),
      (3, '1', 'Trải Nghiệm Cực Quang Bắc Cực', 'Ngắm hiện tượng cực quang kỳ vĩ tại Phần Lan', 380000000.0, 7, 'active', '$nowString', '$nowString'),
      (4, '2', 'Du Thuyền Riêng Vùng Biển Riviera', 'Hành trình sang trọng phong cách thượng lưu Pháp', 1050000000.0, 14, 'inactive', '$nowString', '$nowString')
    ''');

    return db;
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();
