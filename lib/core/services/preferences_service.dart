import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_service.g.dart';

class PreferencesService {
  static const _currentUserIdKey = 'current_user_id';
  static const _themeModeKey = 'theme_mode';

  Future<void> saveCurrentUserId(int userId) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_currentUserIdKey, userId);
  }

  Future<int?> getCurrentUserId() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_currentUserIdKey);
  }

  Future<void> clearCurrentUser() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_currentUserIdKey);
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
