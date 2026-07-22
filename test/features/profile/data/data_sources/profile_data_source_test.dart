import 'package:flutter_test/flutter_test.dart';
import 'package:project_prm/core/database/app_database.dart';
import 'package:project_prm/core/database/database_constants.dart';
import 'package:project_prm/features/profile/data/data_sources/profile_data_source.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late AppDatabase appDatabase;
  late ProfileDataSource dataSource;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    appDatabase = AppDatabase(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
      seedDemoData: false,
    );
    dataSource = ProfileDataSource(appDatabase);
    final database = await appDatabase.database;
    final now = DateTime.now().toUtc().toIso8601String();
    await database.insert(DatabaseConstants.usersTable, <String, Object?>{
      'id': 1,
      'email': 'traveler@example.com',
      'full_name': 'Nguyễn An',
      'auth_provider': 'local',
      'role': 'user',
      'status': 'active',
      'created_at': now,
      'updated_at': now,
    });
  });

  tearDown(() => appDatabase.close());

  test('updates name, phone and avatar for the current profile', () async {
    const avatar = 'data:image/png;base64,aW1hZ2U=';

    final updated = await dataSource.updateProfile(
      userId: 1,
      fullName: '  Nguyễn Minh An  ',
      phone: '0912345678',
      avatarUrl: avatar,
    );

    expect(updated.fullName, 'Nguyễn Minh An');
    expect(updated.phone, '0912345678');
    expect(updated.avatarUrl, avatar);

    final persisted = await dataSource.getProfile(1);
    expect(persisted?.fullName, 'Nguyễn Minh An');
    expect(persisted?.phone, '0912345678');
    expect(persisted?.avatarUrl, avatar);
  });

  test('stores an empty phone as null', () async {
    final updated = await dataSource.updateProfile(
      userId: 1,
      fullName: 'Nguyễn An',
      phone: '   ',
      avatarUrl: null,
    );

    expect(updated.phone, isNull);
  });
}
