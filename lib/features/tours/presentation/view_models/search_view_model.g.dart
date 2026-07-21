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
    extends $AsyncNotifierProvider<SearchViewModel, List<Tour>?> {
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

String _$searchViewModelHash() => r'16da6c80e2f9a68a9005e5c500e00a401a2aae68';

abstract class _$SearchViewModel extends $AsyncNotifier<List<Tour>?> {
  FutureOr<List<Tour>?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Tour>?>, List<Tour>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Tour>?>, List<Tour>?>,
              AsyncValue<List<Tour>?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
