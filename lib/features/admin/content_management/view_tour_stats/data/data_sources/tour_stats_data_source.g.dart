// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_stats_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: type=lint, type=warning

@ProviderFor(tourStatsDataSource)
final tourStatsDataSourceProvider = TourStatsDataSourceProvider._();

final class TourStatsDataSourceProvider
    extends
        $FunctionalProvider<
          TourStatsDataSource,
          TourStatsDataSource,
          TourStatsDataSource
        >
    with $Provider<TourStatsDataSource> {
  TourStatsDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tourStatsDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tourStatsDataSourceHash();

  @$internal
  @override
  $ProviderElement<TourStatsDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TourStatsDataSource create(Ref ref) {
    return tourStatsDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TourStatsDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TourStatsDataSource>(value),
    );
  }
}

String _$tourStatsDataSourceHash() =>
    r'0a98b172a6b2c8928371984a8c9192bc09187ab1';
