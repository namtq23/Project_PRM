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
}
