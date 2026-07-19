import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_constants.dart';
import '../../domain/models/app_user.dart';

part 'user_local_data_source.g.dart';

class UserLocalDataSource {
  const UserLocalDataSource(this.database);

  final AppDatabase database;

  Future<AppUser> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final db = await database.database;
    final rows = await db.query(
      DatabaseConstants.usersTable,
      where: 'LOWER(email) = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    if (rows.isEmpty) {
      throw const LocalAuthException(LocalAuthError.userNotFound);
    }

    final row = rows.single;
    if ((row['status'] as String).toLowerCase() == 'locked') {
      throw const LocalAuthException(LocalAuthError.userLocked);
    }

    final storedHash = row['password_hash'] as String?;
    final submittedHash = sha256.convert(utf8.encode(password)).toString();
    if (storedHash == null || !_constantTimeEquals(storedHash, submittedHash)) {
      throw const LocalAuthException(LocalAuthError.invalidPassword);
    }
    return AppUser.fromMap(row);
  }

  Future<AppUser> registerLocal({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final db = await database.database;
    final normalizedEmail = email.trim().toLowerCase();
    final existingUsers = await db.query(
      DatabaseConstants.usersTable,
      columns: ['id'],
      where: 'LOWER(email) = ?',
      whereArgs: [normalizedEmail],
      limit: 1,
    );
    if (existingUsers.isNotEmpty) {
      throw const LocalAuthException(LocalAuthError.duplicateEmail);
    }

    final now = DateTime.now().toUtc();
    final values = <String, Object?>{
      'email': normalizedEmail,
      'password_hash': sha256.convert(utf8.encode(password)).toString(),
      'full_name': fullName.trim(),
      'auth_provider': 'local',
      'role': 'user',
      'status': 'active',
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };

    try {
      final id = await db.insert(DatabaseConstants.usersTable, values);
      return AppUser.fromMap({...values, 'id': id});
    } catch (error) {
      if (error.toString().toLowerCase().contains('unique')) {
        throw const LocalAuthException(LocalAuthError.duplicateEmail);
      }
      rethrow;
    }
  }

  Future<AppUser> syncGoogleUser({
    required String firebaseUid,
    required String email,
    required String fullName,
    required String? photoUrl,
  }) async {
    final db = await database.database;
    final normalizedEmail = email.trim().toLowerCase();
    var rows = await db.query(
      DatabaseConstants.usersTable,
      where: 'firebase_uid = ?',
      whereArgs: [firebaseUid],
      limit: 1,
    );
    rows = rows.isNotEmpty
        ? rows
        : await db.query(
            DatabaseConstants.usersTable,
            where: 'LOWER(email) = ?',
            whereArgs: [normalizedEmail],
            limit: 1,
          );

    final now = DateTime.now().toUtc().toIso8601String();
    if (rows.isEmpty) {
      final values = <String, Object?>{
        'firebase_uid': firebaseUid,
        'email': normalizedEmail,
        'full_name': fullName,
        'avatar_url': photoUrl,
        'auth_provider': 'google',
        'role': 'user',
        'status': 'active',
        'created_at': now,
        'updated_at': now,
      };
      final id = await db.insert(DatabaseConstants.usersTable, values);
      return AppUser.fromMap({...values, 'id': id});
    }

    final existing = AppUser.fromMap(rows.single);
    if (existing.status.toLowerCase() == 'locked') {
      throw const LocalAuthException(LocalAuthError.userLocked);
    }
    if (existing.firebaseUid != firebaseUid) {
      await db.update(
        DatabaseConstants.usersTable,
        {'firebase_uid': firebaseUid, 'updated_at': now},
        where: 'id = ?',
        whereArgs: [existing.id],
      );
      final updated = await db.query(
        DatabaseConstants.usersTable,
        where: 'id = ?',
        whereArgs: [existing.id],
        limit: 1,
      );
      return AppUser.fromMap(updated.single);
    }
    return existing;
  }

  bool _constantTimeEquals(String first, String second) {
    if (first.length != second.length) return false;
    var difference = 0;
    for (var index = 0; index < first.length; index++) {
      difference |= first.codeUnitAt(index) ^ second.codeUnitAt(index);
    }
    return difference == 0;
  }
}

enum LocalAuthError {
  userNotFound,
  invalidPassword,
  userLocked,
  duplicateEmail,
}

class LocalAuthException implements Exception {
  const LocalAuthException(this.error);
  final LocalAuthError error;
}

@Riverpod(keepAlive: true)
UserLocalDataSource userLocalDataSource(Ref ref) =>
    UserLocalDataSource(ref.watch(appDatabaseProvider));
