// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookingDataSource)
final bookingDataSourceProvider = BookingDataSourceProvider._();

final class BookingDataSourceProvider
    extends
        $FunctionalProvider<
          BookingDataSource,
          BookingDataSource,
          BookingDataSource
        >
    with $Provider<BookingDataSource> {
  BookingDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingDataSourceHash();

  @$internal
  @override
  $ProviderElement<BookingDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookingDataSource create(Ref ref) {
    return bookingDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingDataSource>(value),
    );
  }
}

String _$bookingDataSourceHash() => r'25e2a89280246516a8a9afa6b7c1c16d9baed9f6';
