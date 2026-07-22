// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AnalyticsViewModel)
final analyticsViewModelProvider = AnalyticsViewModelProvider._();

final class AnalyticsViewModelProvider
    extends $NotifierProvider<AnalyticsViewModel, AnalyticsState> {
  AnalyticsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsViewModelHash();

  @$internal
  @override
  AnalyticsViewModel create() => AnalyticsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsState>(value),
    );
  }
}

String _$analyticsViewModelHash() =>
    r'cdef50604e382763c02dc72c51ac5b3dd04cbb62';

abstract class _$AnalyticsViewModel extends $Notifier<AnalyticsState> {
  AnalyticsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AnalyticsState, AnalyticsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AnalyticsState, AnalyticsState>,
              AnalyticsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
