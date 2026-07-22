// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_settings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(systemSettingsRepository)
final systemSettingsRepositoryProvider = SystemSettingsRepositoryProvider._();

final class SystemSettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SystemSettingsRepository,
          SystemSettingsRepository,
          SystemSettingsRepository
        >
    with $Provider<SystemSettingsRepository> {
  SystemSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemSettingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SystemSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SystemSettingsRepository create(Ref ref) {
    return systemSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SystemSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SystemSettingsRepository>(value),
    );
  }
}

String _$systemSettingsRepositoryHash() =>
    r'ada336b27fe0f669544dd009bf9282b35e5f84de';
