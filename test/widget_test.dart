import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_prm/app/app.dart';
import 'package:project_prm/features/booking_management/data/repositories/booking_management_repository.dart';
import 'package:project_prm/features/booking_management/models/booking_management_model.dart';

class _FakeBookingRepository implements BookingManagementRepository {
  @override
  Future<List<BookingManagementModel>> getAllBookings() async {
    return [
      BookingManagementModel(
        id: 9821,
        userId: 1,
        tourId: 101,
        customerName: 'Elena Jensen',
        customerEmail: 'elena.j@corporate.com',
        tourTitle: 'Icelandic Northern Lights',
        bookingDate: DateTime(2023, 10, 24),
        status: 'completed',
        totalPrice: 4250.0,
        passengers: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<void> seedIfEmpty() async {}

  @override
  Future<void> updateBookingStatus(int id, String status) async {}

  @override
  Future<void> deleteBooking(int id) async {}

  @override
  Future<int> createBooking(BookingManagementModel booking) async => 1;
}

void main() {
  testWidgets('router starts on booking management route', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookingManagementRepositoryProvider.overrideWithValue(
            _FakeBookingRepository(),
          ),
        ],
        child: const TourBookingApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Booking Management'), findsWidgets);
  });
}
