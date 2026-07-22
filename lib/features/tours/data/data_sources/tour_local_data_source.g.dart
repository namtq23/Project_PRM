// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_local_data_source.dart';

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
          AsyncValue<TourLocalDataSource>,
          TourLocalDataSource,
          FutureOr<TourLocalDataSource>
        >
    with
        $FutureModifier<TourLocalDataSource>,
        $FutureProvider<TourLocalDataSource> {
  TourLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tourLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tourLocalDataSourceHash();

  @$internal
  @override
  $FutureProviderElement<TourLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TourLocalDataSource> create(Ref ref) {
    return tourLocalDataSource(ref);
  }
}

String _$tourLocalDataSourceHash() =>
    r'cbac9e022de2a94af24195c2d01ae2a26a62a2ff';
