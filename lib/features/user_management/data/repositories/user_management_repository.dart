import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_constants.dart';
import '../../models/user_management_model.dart';

part 'user_management_repository.g.dart';

class UserManagementRepository {
  UserManagementRepository(this._db);
  final AppDatabase _db;

  Future<List<UserManagementModel>> getAllUsers() async {
    final db = await _db.database;
    final maps = await db.query(
      DatabaseConstants.usersTable,
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => UserManagementModel.fromMap(map)).toList();
  }

  Future<void> updateUserRole(int id, String role) async {
    final db = await _db.database;
    await db.update(
      DatabaseConstants.usersTable,
      {'role': role, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateUserStatus(int id, String status) async {
    final db = await _db.database;
    await db.update(
      DatabaseConstants.usersTable,
      {'status': status, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> createUser(UserManagementModel user) async {
    final db = await _db.database;
    return db.insert(DatabaseConstants.usersTable, user.toMap());
  }

  Future<void> deleteUser(int id) async {
    final db = await _db.database;
    await db.delete(
      DatabaseConstants.usersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> seedIfEmpty() async {
    final db = await _db.database;
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.usersTable}',
    );
    final count = countResult.first['count'] as int;
    if (count == 0) {
      final users = [
        UserManagementModel(
          id: 0,
          email: 'elena.vance@voyage.com',
          fullName: 'Elena Vance',
          role: 'admin',
          status: 'active',
          createdAt: DateTime(2023, 10, 12),
          lastActivity: '2 mins ago',
        ),
        UserManagementModel(
          id: 0,
          email: 'm.thorne@explorer.net',
          fullName: 'Marcus Thorne',
          role: 'customer',
          status: 'active',
          createdAt: DateTime(2023, 11, 5),
          lastActivity: '5 hours ago',
        ),
        UserManagementModel(
          id: 0,
          email: 'j.black@restricted.com',
          fullName: 'Julian Blackwood',
          role: 'customer',
          status: 'banned',
          createdAt: DateTime(2023, 12, 15),
          lastActivity: '22 days ago',
        ),
        UserManagementModel(
          id: 0,
          email: 'k.sato@voyage-support.com',
          fullName: 'Kenji Sato',
          role: 'support',
          status: 'active',
          createdAt: DateTime(2024, 1, 2),
          lastActivity: 'Active Now',
        ),
      ];

      for (final u in users) {
        final map = u.toMap();
        final password = u.role == 'admin'
            ? 'admin123'
            : u.role == 'support'
            ? 'support123'
            : 'user123';
        map['password_hash'] = sha256.convert(utf8.encode(password)).toString();
        await db.insert(DatabaseConstants.usersTable, map);
      }
    } else {
      final defaultPasswords = {
        'elena.vance@voyage.com': 'admin123',
        'm.thorne@explorer.net': 'user123',
        'k.sato@voyage-support.com': 'support123',
      };
      for (final entry in defaultPasswords.entries) {
        await db.update(
          DatabaseConstants.usersTable,
          {
            'password_hash': sha256
                .convert(utf8.encode(entry.value))
                .toString(),
          },
          where: 'email = ? AND (password_hash IS NULL OR password_hash = ?)',
          whereArgs: [entry.key, ''],
        );
      }
    }
  }
}

@Riverpod(keepAlive: true)
UserManagementRepository userManagementRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return UserManagementRepository(db);
}
