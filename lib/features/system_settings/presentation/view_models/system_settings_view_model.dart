import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/system_settings_repository.dart';
import '../../models/system_settings_model.dart';

part 'system_settings_view_model.g.dart';

@riverpod
class SystemSettingsViewModel extends _$SystemSettingsViewModel {
  @override
  FutureOr<SystemSettingsModel> build() async {
    final repository = ref.watch(systemSettingsRepositoryProvider);
    return repository.loadSettings();
  }

  Future<void> updateSettings(SystemSettingsModel newSettings) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(systemSettingsRepositoryProvider);
      await repository.saveSettings(newSettings);
      return newSettings;
    });
  }

  Future<void> toggleMaintenanceMode(bool enabled) async {
    final current =
        state.asData?.value ?? state.value ?? SystemSettingsModel.defaults();
    final updated = current.copyWith(isMaintenanceMode: enabled);
    await updateSettings(updated);
  }
}
