import '../models/app_user.dart';

abstract interface class AuthRepository {
  Future<AppUser> loginWithEmail({
    required String email,
    required String password,
  });

  Future<AppUser> registerLocal({
    required String fullName,
    required String email,
    required String password,
  });

  Future<AppUser?> loginWithGoogle();
  Future<void> logout();
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}
