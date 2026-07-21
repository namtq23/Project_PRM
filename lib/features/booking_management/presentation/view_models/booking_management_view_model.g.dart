// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_management_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookingManagementViewModel)
final bookingManagementViewModelProvider =
    BookingManagementViewModelProvider._();

final class BookingManagementViewModelProvider
    extends
        $AsyncNotifierProvider<
          BookingManagementViewModel,
          List<BookingManagementModel>
        > {
  BookingManagementViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingManagementViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingManagementViewModelHash();

  @$internal
  @override
  BookingManagementViewModel create() => BookingManagementViewModel();
}

String _$bookingManagementViewModelHash() =>
    r'1ed60b24ec8b3ef8ea6ce478583d48195b7da4c8';

abstract class _$BookingManagementViewModel
    extends $AsyncNotifier<List<BookingManagementModel>> {
  FutureOr<List<BookingManagementModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<BookingManagementModel>>,
              List<BookingManagementModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<BookingManagementModel>>,
                List<BookingManagementModel>
              >,
              AsyncValue<List<BookingManagementModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
