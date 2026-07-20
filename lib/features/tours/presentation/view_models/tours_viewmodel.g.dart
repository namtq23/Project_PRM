// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tours_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ToursViewModel)
final toursViewModelProvider = ToursViewModelProvider._();

final class ToursViewModelProvider
    extends $NotifierProvider<ToursViewModel, ToursState> {
  ToursViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toursViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toursViewModelHash();

  @$internal
  @override
  ToursViewModel create() => ToursViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ToursState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToursState>(value),
    );
  }
}

String _$toursViewModelHash() => r'2ea0be0308ffb161d9531de815077a085b3c1ede';

abstract class _$ToursViewModel extends $Notifier<ToursState> {
  ToursState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ToursState, ToursState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ToursState, ToursState>,
              ToursState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
