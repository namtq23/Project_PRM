// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CategoriesViewModel)
final categoriesViewModelProvider = CategoriesViewModelProvider._();

final class CategoriesViewModelProvider
    extends $NotifierProvider<CategoriesViewModel, CategoriesState> {
  CategoriesViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesViewModelHash();

  @$internal
  @override
  CategoriesViewModel create() => CategoriesViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoriesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoriesState>(value),
    );
  }
}

String _$categoriesViewModelHash() =>
    r'9ef67a96a66295644c8ec4a2d29469916ef10ecc';

abstract class _$CategoriesViewModel extends $Notifier<CategoriesState> {
  CategoriesState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CategoriesState, CategoriesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CategoriesState, CategoriesState>,
              CategoriesState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
