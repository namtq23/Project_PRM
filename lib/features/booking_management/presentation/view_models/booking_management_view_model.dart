import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/booking_management_repository.dart';
import '../../models/booking_management_model.dart';

part 'booking_management_view_model.g.dart';

@riverpod
class BookingManagementViewModel extends _$BookingManagementViewModel {
  @override
  FutureOr<List<BookingManagementModel>> build() async {
    final repository = ref.watch(bookingManagementRepositoryProvider);
    await repository.seedIfEmpty(); // For demo purposes
    return repository.getAllBookings();
  }

  Future<void> approveBooking(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(bookingManagementRepositoryProvider);
      await repository.updateBookingStatus(id, 'approved');
      return repository.getAllBookings();
    });
  }

  Future<void> completeBooking(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(bookingManagementRepositoryProvider);
      await repository.updateBookingStatus(id, 'completed');
      return repository.getAllBookings();
    });
  }

  Future<void> cancelBooking(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(bookingManagementRepositoryProvider);
      await repository.updateBookingStatus(id, 'canceled');
      return repository.getAllBookings();
    });
  }

  Future<void> deleteBooking(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(bookingManagementRepositoryProvider);
      await repository.deleteBooking(id);
      return repository.getAllBookings();
    });
  }

  Future<void> createBooking({
    required String customerName,
    required String customerEmail,
    required String tourTitle,
    required double totalPrice,
    required int passengers,
    required DateTime bookingDate,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(bookingManagementRepositoryProvider);
      final now = DateTime.now();
      final booking = BookingManagementModel(
        id: 0,
        userId: 1,
        tourId: 1,
        customerName: customerName,
        customerEmail: customerEmail,
        tourTitle: tourTitle,
        bookingDate: bookingDate,
        status: 'pending',
        totalPrice: totalPrice,
        passengers: passengers,
        createdAt: now,
        updatedAt: now,
      );
      await repository.createBooking(booking);
      return repository.getAllBookings();
    });
  }
}
