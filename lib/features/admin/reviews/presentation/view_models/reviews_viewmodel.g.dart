// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: type=lint, type=warning

@ProviderFor(ReviewsViewModel)
final reviewsViewModelProvider = ReviewsViewModelProvider._();

final class ReviewsViewModelProvider
    extends $NotifierProvider<ReviewsViewModel, ReviewsState> {
  ReviewsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewsViewModelHash();

  @$internal
  @override
  ReviewsViewModel create() => ReviewsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewsState>(value),
    );
  }
}

String _$reviewsViewModelHash() => r'8e0d25283543722144d512cda87de95c5cc50f6f';

abstract class _$ReviewsViewModel extends $Notifier<ReviewsState> {
  ReviewsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReviewsState, ReviewsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReviewsState, ReviewsState>,
              ReviewsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
