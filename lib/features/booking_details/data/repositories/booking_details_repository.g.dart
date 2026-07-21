// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_details_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookingDetailsRepository)
final bookingDetailsRepositoryProvider = BookingDetailsRepositoryProvider._();

final class BookingDetailsRepositoryProvider
    extends
        $FunctionalProvider<
          BookingDetailsRepository,
          BookingDetailsRepository,
          BookingDetailsRepository
        >
    with $Provider<BookingDetailsRepository> {
  BookingDetailsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingDetailsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingDetailsRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookingDetailsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookingDetailsRepository create(Ref ref) {
    return bookingDetailsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingDetailsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingDetailsRepository>(value),
    );
  }
}

String _$bookingDetailsRepositoryHash() =>
    r'2247e3c439b204112f4a922a32baf6e6e745341c';
