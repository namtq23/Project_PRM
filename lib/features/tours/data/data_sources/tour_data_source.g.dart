// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tourLocalDataSource)
final tourLocalDataSourceProvider = TourLocalDataSourceProvider._();

final class TourLocalDataSourceProvider
    extends
        $FunctionalProvider<
          TourLocalDataSource,
          TourLocalDataSource,
          TourLocalDataSource
        >
    with $Provider<TourLocalDataSource> {
  TourLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tourLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tourLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<TourLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TourLocalDataSource create(Ref ref) {
    return tourLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TourLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TourLocalDataSource>(value),
    );
  }
}

String _$tourLocalDataSourceHash() =>
    r'1f5e33743a16813138347784b52f9dc576544365';
