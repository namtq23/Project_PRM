// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_details_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookingDetailsViewModel)
final bookingDetailsViewModelProvider = BookingDetailsViewModelFamily._();

final class BookingDetailsViewModelProvider
    extends
        $AsyncNotifierProvider<
          BookingDetailsViewModel,
          AdminBookingDetailModel?
        > {
  BookingDetailsViewModelProvider._({
    required BookingDetailsViewModelFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'bookingDetailsViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookingDetailsViewModelHash();

  @override
  String toString() {
    return r'bookingDetailsViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BookingDetailsViewModel create() => BookingDetailsViewModel();

  @override
  bool operator ==(Object other) {
    return other is BookingDetailsViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingDetailsViewModelHash() =>
    r'02a0d79f6a57da66510c74371d173393bc2b070d';

final class BookingDetailsViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          BookingDetailsViewModel,
          AsyncValue<AdminBookingDetailModel?>,
          AdminBookingDetailModel?,
          FutureOr<AdminBookingDetailModel?>,
          int
        > {
  BookingDetailsViewModelFamily._()
    : super(
        retry: null,
        name: r'bookingDetailsViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookingDetailsViewModelProvider call(int bookingId) =>
      BookingDetailsViewModelProvider._(argument: bookingId, from: this);

  @override
  String toString() => r'bookingDetailsViewModelProvider';
}

abstract class _$BookingDetailsViewModel
    extends $AsyncNotifier<AdminBookingDetailModel?> {
  late final _$args = ref.$arg as int;
  int get bookingId => _$args;

  FutureOr<AdminBookingDetailModel?> build(int bookingId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<AdminBookingDetailModel?>,
              AdminBookingDetailModel?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AdminBookingDetailModel?>,
                AdminBookingDetailModel?
              >,
              AsyncValue<AdminBookingDetailModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
