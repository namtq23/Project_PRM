import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/preferences_service.dart';
import '../../domain/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/google_auth_data_source.dart';
import '../data_sources/user_local_data_source.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this.localDataSource,
    this.googleDataSource,
    this.preferencesService,
  );

  final UserLocalDataSource localDataSource;
  final GoogleAuthDataSource googleDataSource;
  final PreferencesService preferencesService;

  @override
  Future<AppUser?> getCurrentUser() async {
    final userId = await preferencesService.getCurrentUserId();
    if (userId == null) return null;

    final sessionEmail = await preferencesService.getCurrentUserEmail();
    if (sessionEmail == null || sessionEmail.isEmpty) {
      await preferencesService.clearCurrentUser();
      return null;
    }

    final user = await localDataSource.getUserById(userId);
    if (user == null ||
        user.status.toLowerCase() != 'active' ||
        user.email.toLowerCase() != sessionEmail.toLowerCase()) {
      await preferencesService.clearCurrentUser();
      return null;
    }
    return user;
  }

  @override
  Future<AppUser> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await localDataSource.loginWithEmail(
        email: email,
        password: password,
      );
      await preferencesService.saveCurrentUserSession(
        userId: user.id,
        email: user.email,
      );
      return user;
    } on LocalAuthException catch (error) {
      throw AuthException(switch (error.error) {
        LocalAuthError.duplicateEmail => 'Email này đã được sử dụng.',
        LocalAuthError.userNotFound =>
          'Không tìm thấy tài khoản với email này.',
        LocalAuthError.invalidPassword => 'Mật khẩu không chính xác.',
        LocalAuthError.userLocked =>
          'Tài khoản đã bị khóa. Vui lòng liên hệ quản trị viên.',
      });
    }
  }

  @override
  Future<AppUser> registerLocal({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      return await localDataSource.registerLocal(
        fullName: fullName,
        email: email,
        password: password,
      );
    } on LocalAuthException catch (error) {
      if (error.error == LocalAuthError.duplicateEmail) {
        throw const AuthException('Email này đã được sử dụng.');
      }
      throw const AuthException('Không thể tạo tài khoản. Vui lòng thử lại.');
    }
  }

  @override
  Future<AppUser?> loginWithGoogle() async {
    try {
      final googleUser = await googleDataSource.signIn();
      if (googleUser == null) return null;
      final user = await localDataSource.syncGoogleUser(
        firebaseUid: googleUser.firebaseUid,
        email: googleUser.email,
        fullName: googleUser.displayName?.isNotEmpty == true
            ? googleUser.displayName!
            : googleUser.email.split('@').first,
        photoUrl: googleUser.photoUrl,
      );
      await preferencesService.saveCurrentUserSession(
        userId: user.id,
        email: user.email,
      );
      return user;
    } on GoogleAuthException catch (error) {
      throw AuthException(error.message);
    } on LocalAuthException catch (error) {
      if (error.error == LocalAuthError.userLocked) {
        throw const AuthException(
          'Tài khoản đã bị khóa. Vui lòng liên hệ quản trị viên.',
        );
      }
      throw const AuthException(
        'Không thể đồng bộ tài khoản Google. Vui lòng thử lại.',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await googleDataSource.signOut();
    } finally {
      await preferencesService.clearCurrentUser();
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
  ref.watch(userLocalDataSourceProvider),
  ref.watch(googleAuthDataSourceProvider),
  ref.watch(preferencesServiceProvider),
);
