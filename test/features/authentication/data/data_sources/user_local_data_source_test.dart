import 'package:flutter_test/flutter_test.dart';
import 'package:project_prm/core/database/app_database.dart';
import 'package:project_prm/features/authentication/data/data_sources/user_local_data_source.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late AppDatabase appDatabase;
  late UserLocalDataSource dataSource;

  setUpAll(sqfliteFfiInit);

  setUp(() {
    appDatabase = AppDatabase(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
      seedDemoData: false,
    );
    dataSource = UserLocalDataSource(appDatabase);
  });

  tearDown(() => appDatabase.close());

  test('registers and logs in a local user with normalized email', () async {
    final registeredUser = await dataSource.registerLocal(
      fullName: 'Nguyen Kien',
      email: '  Kien@example.com ',
      password: 'password123',
    );

    final loggedInUser = await dataSource.loginWithEmail(
      email: 'KIEN@EXAMPLE.COM',
      password: 'password123',
    );

    expect(registeredUser.id, isPositive);
    expect(loggedInUser.id, registeredUser.id);
    expect(loggedInUser.email, 'kien@example.com');
    expect(loggedInUser.fullName, 'Nguyen Kien');
  });

  test('rejects a duplicate email and an invalid password', () async {
    await dataSource.registerLocal(
      fullName: 'Nguyen Kien',
      email: 'kien@example.com',
      password: 'password123',
    );

    expect(
      () => dataSource.registerLocal(
        fullName: 'Another User',
        email: 'KIEN@example.com',
        password: 'anotherPassword',
      ),
      throwsA(
        isA<LocalAuthException>().having(
          (error) => error.error,
          'error',
          LocalAuthError.duplicateEmail,
        ),
      ),
    );
    expect(
      () => dataSource.loginWithEmail(
        email: 'kien@example.com',
        password: 'wrongPassword',
      ),
      throwsA(
        isA<LocalAuthException>().having(
          (error) => error.error,
          'error',
          LocalAuthError.invalidPassword,
        ),
      ),
    );
  });
}
