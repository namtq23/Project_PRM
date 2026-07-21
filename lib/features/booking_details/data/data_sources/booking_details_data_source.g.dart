// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_details_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookingDetailsDataSource)
final bookingDetailsDataSourceProvider = BookingDetailsDataSourceProvider._();

final class BookingDetailsDataSourceProvider
    extends
        $FunctionalProvider<
          BookingDetailsLocalDataSource,
          BookingDetailsLocalDataSource,
          BookingDetailsLocalDataSource
        >
    with $Provider<BookingDetailsLocalDataSource> {
  BookingDetailsDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingDetailsDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingDetailsDataSourceHash();

  @$internal
  @override
  $ProviderElement<BookingDetailsLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookingDetailsLocalDataSource create(Ref ref) {
    return bookingDetailsDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingDetailsLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingDetailsLocalDataSource>(
        value,
      ),
    );
  }
}

String _$bookingDetailsDataSourceHash() =>
    r'1147e3c439b204112f4a922a32baf6e6e745341b';
