// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_stats_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tourStatsRepository)
final tourStatsRepositoryProvider = TourStatsRepositoryProvider._();

final class TourStatsRepositoryProvider
    extends
        $FunctionalProvider<
          TourStatsRepository,
          TourStatsRepository,
          TourStatsRepository
        >
    with $Provider<TourStatsRepository> {
  TourStatsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tourStatsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tourStatsRepositoryHash();

  @$internal
  @override
  $ProviderElement<TourStatsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TourStatsRepository create(Ref ref) {
    return tourStatsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TourStatsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TourStatsRepository>(value),
    );
  }
}

String _$tourStatsRepositoryHash() =>
    r'e61a4a3ba57c6551393969ff24da0c29e53757a6';
