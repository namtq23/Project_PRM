// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
        isAutoDispose: false,
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

String _$bookingViewModelHash() => r'b4d5a8f4c7748ea721836e0c67f6ac72480df112';

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
    extends
        $AsyncNotifierProvider<BookingHistoryViewModel, List<BookingModel>> {
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
    r'4e8e3df4cc799a0245f715dd557a8b8990ad4d45';

abstract class _$BookingHistoryViewModel
    extends $AsyncNotifier<List<BookingModel>> {
  FutureOr<List<BookingModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<BookingModel>>, List<BookingModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<BookingModel>>, List<BookingModel>>,
              AsyncValue<List<BookingModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BookingDetailViewModel)
final bookingDetailViewModelProvider = BookingDetailViewModelFamily._();

final class BookingDetailViewModelProvider
    extends $AsyncNotifierProvider<BookingDetailViewModel, BookingModel?> {
  BookingDetailViewModelProvider._({
    required BookingDetailViewModelFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'bookingDetailViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookingDetailViewModelHash();

  @override
  String toString() {
    return r'bookingDetailViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BookingDetailViewModel create() => BookingDetailViewModel();

  @override
  bool operator ==(Object other) {
    return other is BookingDetailViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingDetailViewModelHash() =>
    r'02a0d79f6a57da66510c74371d173393bc2b0709';

final class BookingDetailViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          BookingDetailViewModel,
          AsyncValue<BookingModel?>,
          BookingModel?,
          FutureOr<BookingModel?>,
          int
        > {
  BookingDetailViewModelFamily._()
    : super(
        retry: null,
        name: r'bookingDetailViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookingDetailViewModelProvider call(int bookingId) =>
      BookingDetailViewModelProvider._(argument: bookingId, from: this);

  @override
  String toString() => r'bookingDetailViewModelProvider';
}

abstract class _$BookingDetailViewModel extends $AsyncNotifier<BookingModel?> {
  late final _$args = ref.$arg as int;
  int get bookingId => _$args;

  FutureOr<BookingModel?> build(int bookingId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BookingModel?>, BookingModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BookingModel?>, BookingModel?>,
              AsyncValue<BookingModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
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

String _$reviewViewModelHash() => r'6a91ca39d6148919b68a0fcc02e9115ab15aa486';

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
