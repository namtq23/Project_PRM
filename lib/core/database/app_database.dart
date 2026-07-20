import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'database_constants.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
part 'app_database.g.dart';


void setupDatabase() {
  if (Platform.isWindows || Platform.isLinux) {
    // Khởi tạo FFI cho desktop
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
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
        version: DatabaseConstants.databaseVersion,
        onCreate: (database, _) =>
            database.execute(DatabaseConstants.createUsersTable),
      ),
    );
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();
