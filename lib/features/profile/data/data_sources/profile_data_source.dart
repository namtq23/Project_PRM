import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_constants.dart';
import '../../models/profile_model.dart';

part 'profile_data_source.g.dart';

class ProfileDataSource {
  const ProfileDataSource(this.database);

  final AppDatabase database;

  Future<ProfileModel?> getProfile(int userId) async {
    final db = await database.database;
    final rows = await db.query(
      DatabaseConstants.usersTable,
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return rows.isEmpty ? null : ProfileModel.fromMap(rows.single);
  }

  Future<ProfileModel> updateProfile({
    required int userId,
    required String fullName,
    required String? phone,
    required String? avatarUrl,
  }) async {
    final db = await database.database;
    await db.update(
      DatabaseConstants.usersTable,
      {
        'full_name': fullName.trim(),
        'phone': phone?.trim().isEmpty == true ? null : phone?.trim(),
        'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
    final updated = await getProfile(userId);
    if (updated == null) throw const ProfileDataException();
    return updated;
  }
}

class ProfileDataException implements Exception {
  const ProfileDataException();
}

@Riverpod(keepAlive: true)
ProfileDataSource profileDataSource(Ref ref) =>
    ProfileDataSource(ref.watch(appDatabaseProvider));
