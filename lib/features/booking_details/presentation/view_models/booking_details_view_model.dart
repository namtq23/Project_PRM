import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/booking_details_repository.dart';
import '../../models/admin_booking_detail_model.dart';

part 'booking_details_view_model.g.dart';

@riverpod
class BookingDetailsViewModel extends _$BookingDetailsViewModel {
  @override
  FutureOr<AdminBookingDetailModel?> build(int bookingId) async {
    return ref
        .watch(bookingDetailsRepositoryProvider)
        .getBookingDetail(bookingId);
  }

  Future<void> cancelBooking() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(bookingDetailsRepositoryProvider)
          .updateBookingStatus(current.id, 'canceled');
      return current.copyWith(
        status: 'canceled',
        timeline: [
          ActivityTimelineItem(
            title: 'Booking Cancelled',
            timestamp:
                '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year} • ${DateTime.now().hour}:${DateTime.now().minute}',
            note: '"Admin: Booking was cancelled."',
            isPrimary: true,
          ),
          ...current.timeline.map(
            (e) => ActivityTimelineItem(
              title: e.title,
              timestamp: e.timestamp,
              note: e.note,
              isPrimary: false,
            ),
          ),
        ],
      );
    });
  }

  Future<void> confirmPayment() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(bookingDetailsRepositoryProvider)
          .updateBookingStatus(current.id, 'completed');
      return current.copyWith(
        status: 'completed',
        depositPaid: current.totalPrice,
        balanceDue: 0.0,
        timeline: [
          ActivityTimelineItem(
            title: 'Payment Completed',
            timestamp:
                '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year} • ${DateTime.now().hour}:${DateTime.now().minute}',
            note: '"Admin: Full payment confirmed."',
            isPrimary: true,
          ),
          ...current.timeline.map(
            (e) => ActivityTimelineItem(
              title: e.title,
              timestamp: e.timestamp,
              note: e.note,
              isPrimary: false,
            ),
          ),
        ],
      );
    });
  }
}
