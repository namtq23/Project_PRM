import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/preferences_service.dart';

part 'theme_mode_view_model.g.dart';

@Riverpod(keepAlive: true)
class ThemeModeViewModel extends _$ThemeModeViewModel {
  @override
  Future<ThemeMode> build() async {
    final savedMode = await ref
        .watch(preferencesServiceProvider)
        .getThemeMode();
    return savedMode == ThemeMode.dark.name ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setDarkMode(bool enabled) async {
    final mode = enabled ? ThemeMode.dark : ThemeMode.light;
    state = AsyncData(mode);
    await ref.read(preferencesServiceProvider).saveThemeMode(mode.name);
  }
}
