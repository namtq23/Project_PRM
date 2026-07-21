import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/system_settings_model.dart';

part 'system_settings_repository.g.dart';

class SystemSettingsRepository {
  static const _settingsKey = 'system_settings_config';

  Future<SystemSettingsModel> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_settingsKey);
    if (jsonStr == null || jsonStr.isEmpty) {
      return SystemSettingsModel.defaults();
    }
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return SystemSettingsModel.fromMap(map);
    } catch (_) {
      return SystemSettingsModel.defaults();
    }
  }

  Future<void> saveSettings(SystemSettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(settings.toMap());
    await prefs.setString(_settingsKey, jsonStr);
  }
}

@Riverpod(keepAlive: true)
SystemSettingsRepository systemSettingsRepository(Ref ref) {
  return SystemSettingsRepository();
}
