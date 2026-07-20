// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookingRepository)
final bookingRepositoryProvider = BookingRepositoryProvider._();

final class BookingRepositoryProvider
    extends
        $FunctionalProvider<
          BookingRepository,
          BookingRepository,
          BookingRepository
        >
    with $Provider<BookingRepository> {
  BookingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookingRepository create(Ref ref) {
    return bookingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingRepository>(value),
    );
  }
}

String _$bookingRepositoryHash() => r'c50446247cfcc99090a4f2046a1000740b0a533c';

@ProviderFor(BookingViewModel)
final bookingViewModelProvider = BookingViewModelProvider._();

final class BookingViewModelProvider
    extends $NotifierProvider<BookingViewModel, BookingDraft> {
  BookingViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingViewModelHash();

  @$internal
  @override
  BookingViewModel create() => BookingViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingDraft value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingDraft>(value),
    );
  }
}

String _$bookingViewModelHash() => r'a17abd9cbcb60c379853bfa124ae4a975288c2c8';

abstract class _$BookingViewModel extends $Notifier<BookingDraft> {
  BookingDraft build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BookingDraft, BookingDraft>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookingDraft, BookingDraft>,
              BookingDraft,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BookingHistoryViewModel)
final bookingHistoryViewModelProvider = BookingHistoryViewModelProvider._();

final class BookingHistoryViewModelProvider
    extends $AsyncNotifierProvider<BookingHistoryViewModel, List<dynamic>> {
  BookingHistoryViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingHistoryViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingHistoryViewModelHash();

  @$internal
  @override
  BookingHistoryViewModel create() => BookingHistoryViewModel();
}

String _$bookingHistoryViewModelHash() =>
    r'ba2046db6652d4febfb2d80cfa58123313477ae4';

abstract class _$BookingHistoryViewModel extends $AsyncNotifier<List<dynamic>> {
  FutureOr<List<dynamic>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<dynamic>>, List<dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<dynamic>>, List<dynamic>>,
              AsyncValue<List<dynamic>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ReviewViewModel)
final reviewViewModelProvider = ReviewViewModelProvider._();

final class ReviewViewModelProvider
    extends $NotifierProvider<ReviewViewModel, AsyncValue<bool?>> {
  ReviewViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewViewModelHash();

  @$internal
  @override
  ReviewViewModel create() => ReviewViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<bool?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<bool?>>(value),
    );
  }
}

String _$reviewViewModelHash() => r'cca2084be148f4e6056133820ab3a6942e33f7c3';

abstract class _$ReviewViewModel extends $Notifier<AsyncValue<bool?>> {
  AsyncValue<bool?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool?>, AsyncValue<bool?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool?>, AsyncValue<bool?>>,
              AsyncValue<bool?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
