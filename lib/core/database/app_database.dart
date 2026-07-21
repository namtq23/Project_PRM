import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart' as mobile_sqflite;
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
    } else if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      factory = mobile_sqflite.databaseFactory;
      final databasesDirectory = await factory.getDatabasesPath();
      databasePath = path.join(
        databasesDirectory,
        DatabaseConstants.databaseName,
      );
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
    if (seedDemoData) await _seedDemoTours(database);
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

  Future<void> _seedDemoTours(Database database) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final demoTours = <Map<String, Object?>>[
      {
        'id': 1,
        'title': 'Nghỉ dưỡng Sunset Sanato Phú Quốc',
        'description': 'Tour mẫu phục vụ kiểm thử Booking & Checkout.',
        'price': 3500000.0,
        'duration_days': 3,
        'status': 'active',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 2,
        'title': 'Bà Nà Hills và phố cổ Hội An',
        'description': 'Tour mẫu phục vụ kiểm thử Booking & Checkout.',
        'price': 1250000.0,
        'duration_days': 3,
        'status': 'active',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 3,
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
        conflictAlgorithm: ConflictAlgorithm.ignore,
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
