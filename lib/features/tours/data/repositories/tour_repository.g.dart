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
    extends
        $FunctionalProvider<
          AsyncValue<TourRepository>,
          TourRepository,
          FutureOr<TourRepository>
        >
    with $FutureModifier<TourRepository>, $FutureProvider<TourRepository> {
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
  $FutureProviderElement<TourRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TourRepository> create(Ref ref) {
    return tourRepository(ref);
  }
}

String _$tourRepositoryHash() => r'783637af463019b1050d351b9dc344247cb7298c';
