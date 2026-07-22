// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_mode_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ThemeModeViewModel)
final themeModeViewModelProvider = ThemeModeViewModelProvider._();

final class ThemeModeViewModelProvider
    extends $AsyncNotifierProvider<ThemeModeViewModel, ThemeMode> {
  ThemeModeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeViewModelHash();

  @$internal
  @override
  ThemeModeViewModel create() => ThemeModeViewModel();
}

String _$themeModeViewModelHash() =>
    r'5b7685a42bab551dc2a877c7529ae7ae5db26277';

abstract class _$ThemeModeViewModel extends $AsyncNotifier<ThemeMode> {
  FutureOr<ThemeMode> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ThemeMode>, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeMode>, ThemeMode>,
              AsyncValue<ThemeMode>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
