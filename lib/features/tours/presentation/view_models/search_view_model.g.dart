// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchViewModel)
final searchViewModelProvider = SearchViewModelProvider._();

final class SearchViewModelProvider
    extends $AsyncNotifierProvider<SearchViewModel, List<TourModel>?> {
  SearchViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchViewModelHash();

  @$internal
  @override
  SearchViewModel create() => SearchViewModel();
}

String _$searchViewModelHash() => r'9b459fd057cde0048e220a8fbb99b3e626a38cb1';

abstract class _$SearchViewModel extends $AsyncNotifier<List<TourModel>?> {
  FutureOr<List<TourModel>?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<TourModel>?>, List<TourModel>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<TourModel>?>, List<TourModel>?>,
              AsyncValue<List<TourModel>?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
