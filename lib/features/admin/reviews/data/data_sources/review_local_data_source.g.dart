// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_local_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: type=lint, type=warning

@ProviderFor(reviewLocalDataSource)
final reviewLocalDataSourceProvider = ReviewLocalDataSourceProvider._();

final class ReviewLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ReviewLocalDataSource,
          ReviewLocalDataSource,
          ReviewLocalDataSource
        >
    with $Provider<ReviewLocalDataSource> {
  ReviewLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ReviewLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReviewLocalDataSource create(Ref ref) {
    return reviewLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewLocalDataSource>(value),
    );
  }
}

String _$reviewLocalDataSourceHash() =>
    r'0a98b172a6b2c8928371984a8c9192bc09187ab3';
