import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../states/auth_state.dart';

part 'auth_view_model.g.dart';

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  @override
  Future<AuthState> build() async {
    final user = await ref.watch(authRepositoryProvider).getCurrentUser();
    return user == null ? const AuthUnauthenticated() : AuthAuthenticated(user);
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncData(AuthLoading());
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .loginWithEmail(email: email.trim(), password: password);
      state = AsyncData(AuthAuthenticated(user));
    } on AuthException catch (error) {
      state = AsyncData(AuthFailure(error.message));
    } catch (_) {
      state = const AsyncData(
        AuthFailure('Không thể đăng nhập. Vui lòng thử lại.'),
      );
    }
  }

  Future<void> registerLocal({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = const AsyncData(AuthLoading());
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .registerLocal(
            fullName: fullName.trim(),
            email: email.trim(),
            password: password,
          );
      state = AsyncData(AuthRegistrationSuccess(user));
    } on AuthException catch (error) {
      state = AsyncData(AuthFailure(error.message));
    } catch (_) {
      state = const AsyncData(
        AuthFailure('Không thể tạo tài khoản. Vui lòng thử lại.'),
      );
    }
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncData(AuthLoading());
    try {
      final user = await ref.read(authRepositoryProvider).loginWithGoogle();
      state = user == null
          ? const AsyncData(AuthCancelled('Đã hủy đăng nhập Google.'))
          : AsyncData(AuthAuthenticated(user));
    } on AuthException catch (error) {
      state = AsyncData(AuthFailure(error.message));
    } catch (_) {
      state = const AsyncData(
        AuthFailure('Không thể đăng nhập Google. Vui lòng thử lại.'),
      );
    }
  }

  Future<void> logout() async {
    state = const AsyncData(AuthLoading());
    try {
      await ref.read(authRepositoryProvider).logout();
      state = const AsyncData(AuthUnauthenticated());
    } catch (_) {
      state = const AsyncData(AuthUnauthenticated());
    }
  }

  Future<void> refreshCurrentUser() async {
    final user = await ref.read(authRepositoryProvider).getCurrentUser();
    if (user != null) state = AsyncData(AuthAuthenticated(user));
  }
}
