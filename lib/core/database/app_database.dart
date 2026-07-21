import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'database_constants.dart';
import 'database_seeder.dart';

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
    return factory.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: 4,
        onCreate: (database, _) async {
          for (final sql in DatabaseConstants.allTables) {
            await database.execute(sql);
          }
          await DatabaseSeeder.seed(database);
        },
        onUpgrade: (database, oldVersion, newVersion) async {
          if (oldVersion < 4) {
            // Drop all tables and recreate them for dev env since schema changed
            await database.execute('DROP TABLE IF EXISTS reviews');
            await database.execute('DROP TABLE IF EXISTS bookings');
            await database.execute('DROP TABLE IF EXISTS tours');
            await database.execute('DROP TABLE IF EXISTS categories');
            await database.execute('DROP TABLE IF EXISTS users');

            for (final sql in DatabaseConstants.allTables) {
              await database.execute(sql);
            }
            await DatabaseSeeder.seed(database);
          }
        },
      ),
    );
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();
