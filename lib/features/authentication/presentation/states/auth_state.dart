import '../../domain/models/app_user.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitializing extends AuthState {
  const AuthInitializing();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final AppUser user;
}

class AuthRegistrationSuccess extends AuthState {
  const AuthRegistrationSuccess(this.user);
  final AppUser user;
}

class AuthFailure extends AuthState {
  const AuthFailure(this.message);
  final String message;
}

class AuthCancelled extends AuthState {
  const AuthCancelled(this.message);
  final String message;
}
