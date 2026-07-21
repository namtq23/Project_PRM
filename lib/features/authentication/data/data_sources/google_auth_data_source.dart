import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_auth_data_source.g.dart';

class GoogleAuthDataSource {
  const GoogleAuthDataSource(this.firebaseAuth);

  final FirebaseAuth firebaseAuth;

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      throw GoogleAuthException(_messageFor(error.code));
    }
  }

  Future<GoogleFirebaseUser?> signIn() async {
    try {
      final provider = GoogleAuthProvider()..addScope('email');
      final credential = kIsWeb
          ? await firebaseAuth.signInWithPopup(provider)
          : await firebaseAuth.signInWithProvider(provider);
      final user = credential.user;
      if (user == null) {
        throw const GoogleAuthException('Không nhận được tài khoản Google.');
      }
      final email = user.email?.trim().toLowerCase();
      if (email == null || email.isEmpty) {
        throw const GoogleAuthException(
          'Tài khoản Google không cung cấp địa chỉ email.',
        );
      }
      return GoogleFirebaseUser(
        firebaseUid: user.uid,
        email: email,
        displayName: user.displayName?.trim(),
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (error) {
      if (_isCancellation(error.code)) return null;
      throw GoogleAuthException(_messageFor(error.code));
    }
  }

  bool _isCancellation(String code) => const {
    'popup-closed-by-user',
    'cancelled-popup-request',
    'web-context-canceled',
    'sign-in-cancelled',
  }.contains(code);

  String _messageFor(String code) => switch (code) {
    'popup-blocked' =>
      'Trình duyệt đã chặn cửa sổ đăng nhập Google. Vui lòng cho phép popup.',
    'account-exists-with-different-credential' =>
      'Email này đang được sử dụng bởi phương thức đăng nhập khác.',
    'network-request-failed' =>
      'Không thể kết nối Google. Vui lòng kiểm tra mạng.',
    'operation-not-allowed' =>
      'Đăng nhập Google chưa được bật trong Firebase Console.',
    _ => 'Không thể đăng nhập Google. Vui lòng thử lại.',
  };
}

class GoogleFirebaseUser {
  const GoogleFirebaseUser({
    required this.firebaseUid,
    required this.email,
    required this.displayName,
    required this.photoUrl,
  });

  final String firebaseUid;
  final String email;
  final String? displayName;
  final String? photoUrl;
}

class GoogleAuthException implements Exception {
  const GoogleAuthException(this.message);
  final String message;
}

@Riverpod(keepAlive: true)
GoogleAuthDataSource googleAuthDataSource(Ref ref) =>
    GoogleAuthDataSource(FirebaseAuth.instance);
