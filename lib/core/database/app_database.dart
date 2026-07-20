import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'database_constants.dart';

part 'app_database.g.dart';

class AppDatabase {
  AppDatabase({
    DatabaseFactory? factory,
    String? databasePath,
    this.seedDemoData = kDebugMode,
  }) : _factoryOverride = factory,
       _databasePathOverride = databasePath;

  final DatabaseFactory? _factoryOverride;
  final String? _databasePathOverride;
  final bool seedDemoData;
  Database? _database;

  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    final DatabaseFactory factory;
    final String databasePath;

    if (_factoryOverride != null) {
      factory = _factoryOverride;
      databasePath = _databasePathOverride ?? DatabaseConstants.databaseName;
    } else if (kIsWeb) {
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
    final database = await factory.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: DatabaseConstants.databaseVersion,
        onConfigure: (database) => database.execute('PRAGMA foreign_keys = ON'),
        onCreate: (database, _) => _createSchema(database),
        onUpgrade: (database, oldVersion, _) async {
          if (oldVersion < 2) await _createSchema(database);
        },
      ),
    );

    if (seedDemoData) {
      await _seedAdmin(database);
      await _seedDemoCategories(database);
      await _seedDemoTours(database);
    }

    return database;
  }

  Future<void> _createSchema(Database database) async {
    for (final statement in DatabaseConstants.allTables) {
      await database.execute(statement);
    }
    for (final statement in DatabaseConstants.allIndexes) {
      await database.execute(statement);
    }
  }

  Future<void> _seedAdmin(Database database) async {
    final nowString = DateTime.now().toUtc().toIso8601String();
    await database.execute('''
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
    await database.execute('''
      UPDATE users SET role = 'admin' WHERE email = 'hoanganh2k52@gmail.com'
    ''');
  }

  Future<void> _seedDemoCategories(Database database) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await database.execute('''
      INSERT OR IGNORE INTO categories (id, title, description, created_at, updated_at) VALUES
      (1, 'Thám Hiểm Sang Trọng', 'Trải nghiệm du lịch cao cấp', '$now', '$now'),
      (2, 'Thành Thị Thượng Lưu', 'Kỳ nghỉ dưỡng cao cấp tại các thành phố lớn', '$now', '$now')
    ''');
  }

  Future<void> _seedDemoTours(Database database) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final demoTours = <Map<String, Object?>>[
      {
        'id': 1,
        'category_id': 1,
        'title': 'Bay Khám Phá Kỳ Quan Serengeti',
        'description': 'Trải nghiệm thám hiểm hoang dã cao cấp tại Tanzania',
        'price': 310000000.0,
        'duration_days': 10,
        'status': 'active',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 2,
        'category_id': 2,
        'title': 'Nghỉ Dưỡng Thượng Lưu Neo-Tokyo',
        'description': 'Khám phá Tokyo đẳng cấp dành cho doanh nhân, Nhật Bản',
        'price': 220000000.0,
        'duration_days': 5,
        'status': 'draft',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 3,
        'category_id': 1,
        'title': 'Trải Nghiệm Cực Quang Bắc Cực',
        'description': 'Ngắm hiện tượng cực quang kỳ vĩ tại Phần Lan',
        'price': 380000000.0,
        'duration_days': 7,
        'status': 'active',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 4,
        'category_id': 2,
        'title': 'Du Thuyền Riêng Vùng Biển Riviera',
        'description': 'Hành trình sang trọng phong cách thượng lưu Pháp',
        'price': 1050000000.0,
        'duration_days': 14,
        'status': 'inactive',
        'created_at': now,
        'updated_at': now,
      },
      // Group's tours
      {
        'id': 5,
        'category_id': 2,
        'title': 'Nghỉ dưỡng Sunset Sanato Phú Quốc',
        'description': 'Tour mẫu phục vụ kiểm thử Booking & Checkout.',
        'price': 3500000.0,
        'duration_days': 3,
        'status': 'active',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 6,
        'category_id': 2,
        'title': 'Bà Nà Hills và phố cổ Hội An',
        'description': 'Tour mẫu phục vụ kiểm thử Booking & Checkout.',
        'price': 1250000.0,
        'duration_days': 3,
        'status': 'active',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 7,
        'category_id': 1,
        'title': 'Mùa lúa chín Mù Cang Chải',
        'description': 'Tour mẫu phục vụ kiểm thử Booking & Checkout.',
        'price': 2800000.0,
        'duration_days': 4,
        'status': 'active',
        'created_at': now,
        'updated_at': now,
      },
    ];

    for (final tour in demoTours) {
      await database.insert(
        DatabaseConstants.toursTable,
        tour,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> close() async {
    final database = _database;
    _database = null;
    await database?.close();
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();
