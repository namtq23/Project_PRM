// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_settings_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SystemSettingsViewModel)
final systemSettingsViewModelProvider = SystemSettingsViewModelProvider._();

final class SystemSettingsViewModelProvider
    extends
        $AsyncNotifierProvider<SystemSettingsViewModel, SystemSettingsModel> {
  SystemSettingsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemSettingsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemSettingsViewModelHash();

  @$internal
  @override
  SystemSettingsViewModel create() => SystemSettingsViewModel();
}

String _$systemSettingsViewModelHash() =>
    r'46d167a116cede03fddf2f56baba77e75203e7c1';

abstract class _$SystemSettingsViewModel
    extends $AsyncNotifier<SystemSettingsModel> {
  FutureOr<SystemSettingsModel> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SystemSettingsModel>, SystemSettingsModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SystemSettingsModel>, SystemSettingsModel>,
              AsyncValue<SystemSettingsModel>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
