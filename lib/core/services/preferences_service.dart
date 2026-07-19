import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_service.g.dart';

class PreferencesService {
  static const _currentUserIdKey = 'current_user_id';

  Future<void> saveCurrentUserId(int userId) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_currentUserIdKey, userId);
  }

  Future<void> clearCurrentUser() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_currentUserIdKey);
  }
}

@Riverpod(keepAlive: true)
PreferencesService preferencesService(Ref ref) => PreferencesService();
