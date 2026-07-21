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
    extends $AsyncNotifierProvider<SearchViewModel, SearchState> {
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

String _$searchViewModelHash() => r'34dbec48d95f5ab6a612bd9ece1f86a82cae90fc';

abstract class _$SearchViewModel extends $AsyncNotifier<SearchState> {
  FutureOr<SearchState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SearchState>, SearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SearchState>, SearchState>,
              AsyncValue<SearchState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
