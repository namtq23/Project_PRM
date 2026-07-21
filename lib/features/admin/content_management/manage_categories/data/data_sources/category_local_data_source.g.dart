// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_local_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: type=lint, type=warning

@ProviderFor(categoryLocalDataSource)
final categoryLocalDataSourceProvider = CategoryLocalDataSourceProvider._();

final class CategoryLocalDataSourceProvider
    extends
        $FunctionalProvider<
          CategoryLocalDataSource,
          CategoryLocalDataSource,
          CategoryLocalDataSource
        >
    with $Provider<CategoryLocalDataSource> {
  CategoryLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<CategoryLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryLocalDataSource create(Ref ref) {
    return categoryLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryLocalDataSource>(value),
    );
  }
}

String _$categoryLocalDataSourceHash() =>
    r'0d1815819beb412c5a8c986a5ec2188985de6011';
