// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tourRepository)
final tourRepositoryProvider = TourRepositoryProvider._();

final class TourRepositoryProvider
    extends $FunctionalProvider<TourRepository, TourRepository, TourRepository>
    with $Provider<TourRepository> {
  TourRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tourRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tourRepositoryHash();

  @$internal
  @override
  $ProviderElement<TourRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TourRepository create(Ref ref) {
    return tourRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TourRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TourRepository>(value),
    );
  }
}

String _$tourRepositoryHash() => r'd037ea030fdb7389af48ecad89ae40c3828a82c7';
