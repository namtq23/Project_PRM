import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_prm/core/database/app_database.dart';
import 'package:project_prm/core/services/preferences_service.dart';
import 'package:project_prm/features/authentication/data/data_sources/google_auth_data_source.dart';
import 'package:project_prm/features/authentication/data/data_sources/user_local_data_source.dart';
import 'package:project_prm/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:project_prm/features/authentication/domain/models/app_user.dart';

void main() {
  const admin = AppUser(
    id: 1,
    email: 'admin@example.com',
    fullName: 'Admin',
    authProvider: 'local',
    role: 'admin',
    status: 'active',
    createdAt: _date,
    updatedAt: _date,
  );

  test('invalidates a legacy session that only contains a numeric user id', () async {
    final preferences = _FakePreferencesService(userId: admin.id);
    final repository = AuthRepositoryImpl(
      _FakeUserLocalDataSource(admin),
      _FakeGoogleAuthDataSource(),
      preferences,
    );

    expect(await repository.getCurrentUser(), isNull);
    expect(preferences.wasCleared, isTrue);
  });

  test('invalidates a session when its email does not match the stored user', () async {
    final preferences = _FakePreferencesService(
      userId: admin.id,
      email: 'customer@example.com',
    );
    final repository = AuthRepositoryImpl(
      _FakeUserLocalDataSource(admin),
      _FakeGoogleAuthDataSource(),
      preferences,
    );

    expect(await repository.getCurrentUser(), isNull);
    expect(preferences.wasCleared, isTrue);
  });

  test('restores a session only when both id and email match', () async {
    final preferences = _FakePreferencesService(
      userId: admin.id,
      email: admin.email,
    );
    final repository = AuthRepositoryImpl(
      _FakeUserLocalDataSource(admin),
      _FakeGoogleAuthDataSource(),
      preferences,
    );

    expect(await repository.getCurrentUser(), same(admin));
    expect(preferences.wasCleared, isFalse);
  });
}

const _date = DateTime.utc(2026);

class _FakePreferencesService implements PreferencesService {
  _FakePreferencesService({this.userId, this.email});

  int? userId;
  String? email;
  bool wasCleared = false;

  @override
  Future<void> clearCurrentUser() async {
    userId = null;
    email = null;
    wasCleared = true;
  }

  @override
  Future<String?> getCurrentUserEmail() async => email;

  @override
  Future<int?> getCurrentUserId() async => userId;

  @override
  Future<String?> getThemeMode() async => null;

  @override
  Future<void> saveCurrentUserSession({
    required int userId,
    required String email,
  }) async {
    this.userId = userId;
    this.email = email;
  }

  @override
  Future<void> saveThemeMode(String themeMode) async {}
}

class _FakeUserLocalDataSource implements UserLocalDataSource {
  const _FakeUserLocalDataSource(this.user);

  final AppUser? user;

  @override
  AppDatabase get database => throw UnimplementedError();

  @override
  Future<AppUser?> getUserById(int userId) async => user;

  @override
  Future<AppUser> loginWithEmail({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<AppUser> registerLocal({
    required String fullName,
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<AppUser> syncGoogleUser({
    required String firebaseUid,
    required String email,
    required String fullName,
    required String? photoUrl,
  }) => throw UnimplementedError();
}

class _FakeGoogleAuthDataSource implements GoogleAuthDataSource {
  @override
  FirebaseAuth get firebaseAuth => throw UnimplementedError();

  @override
  Future<GoogleFirebaseUser?> signIn() => throw UnimplementedError();

  @override
  Future<void> signOut() async {}
}
