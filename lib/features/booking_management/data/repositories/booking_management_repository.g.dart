// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_management_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookingManagementRepository)
final bookingManagementRepositoryProvider =
    BookingManagementRepositoryProvider._();

final class BookingManagementRepositoryProvider
    extends
        $FunctionalProvider<
          BookingManagementRepository,
          BookingManagementRepository,
          BookingManagementRepository
        >
    with $Provider<BookingManagementRepository> {
  BookingManagementRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingManagementRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingManagementRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookingManagementRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookingManagementRepository create(Ref ref) {
    return bookingManagementRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingManagementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingManagementRepository>(value),
    );
  }
}

String _$bookingManagementRepositoryHash() =>
    r'2247e3c439b204112f4a922a32baf6e6e745341a';
