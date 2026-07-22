import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_service.g.dart';

class PreferencesService {
  static const _currentUserIdKey = 'current_user_id';
  static const _currentUserEmailKey = 'current_user_email';
  static const _themeModeKey = 'theme_mode';

  Future<void> saveCurrentUserSession({
    required int userId,
    required String email,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_currentUserIdKey, userId);
    await preferences.setString(
      _currentUserEmailKey,
      email.trim().toLowerCase(),
    );
  }

  Future<int?> getCurrentUserId() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_currentUserIdKey);
  }

  Future<String?> getCurrentUserEmail() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_currentUserEmailKey);
  }

  Future<void> clearCurrentUser() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_currentUserIdKey);
    await preferences.remove(_currentUserEmailKey);
  }

  Future<String?> getThemeMode() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_themeModeKey);
  }

  Future<void> saveThemeMode(String themeMode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themeModeKey, themeMode);
  }
}

@Riverpod(keepAlive: true)
PreferencesService preferencesService(Ref ref) => PreferencesService();
