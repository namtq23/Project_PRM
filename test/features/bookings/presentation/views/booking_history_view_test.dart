import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_prm/features/bookings/data/repositories/booking_repository.dart';
import 'package:project_prm/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:project_prm/features/bookings/models/booking_flow_models.dart';
import 'package:project_prm/features/bookings/models/booking_model.dart';
import 'package:project_prm/features/bookings/presentation/views/booking_history_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({'current_user_id': 9}));

  testWidgets('shows Stitch dark layout and filters bookings by tab', (
    tester,
  ) async {
    final repository = _FakeBookingRepository(bookings: _sampleBookings);

    await _pumpHistory(tester, repository);
    await tester.pumpAndSettle();

    expect(find.text('Chuyến đi'), findsNWidgets(2));
    expect(find.text('Sắp tới'), findsWidgets);
    expect(
      find.text('Khám phá Cầu Vàng Bà Nà Hills & Phố cổ Hội An'),
      findsOneWidget,
    );
    expect(find.text('Chi tiết'), findsOneWidget);

    await tester.tap(find.text('Đã hoàn thành'));
    await tester.pumpAndSettle();

    expect(
      find.text('Mùa lúa chín Mù Cang Chải - Kỳ quan ruộng bậc thang'),
      findsOneWidget,
    );
    expect(find.text('Hoàn thành'), findsOneWidget);

    await tester.tap(find.text('Đã hủy'));
    await tester.pumpAndSettle();

    expect(
      find.text('Trải nghiệm nghỉ dưỡng 5 sao Sunset Sanato'),
      findsOneWidget,
    );
    expect(find.text('Đã hủy'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows skeleton while booking history is loading', (
    tester,
  ) async {
    final repository = _FakeBookingRepository(
      historyFuture: Completer<List<BookingModel>>().future,
    );

    await _pumpHistory(tester, repository);
    await tester.pump();

    expect(find.byType(Shimmer), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Sắp tới'), findsOneWidget);
  });

  testWidgets('shows the empty state', (tester) async {
    await _pumpHistory(tester, _FakeBookingRepository(bookings: const []));
    await tester.pumpAndSettle();

    expect(find.text('Bạn chưa có chuyến đi sắp tới'), findsOneWidget);
  });

  testWidgets('shows the error state', (tester) async {
    await _pumpHistory(
      tester,
      _FakeBookingRepository(
        error: const BookingException('Không thể đọc dữ liệu đặt chỗ.'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không thể tải lịch sử đặt chỗ'), findsOneWidget);
    expect(find.text('Không thể đọc dữ liệu đặt chỗ.'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);
  });

  testWidgets('fits the 390 by 884 Stitch mobile viewport', (tester) async {
    tester.view.physicalSize = const Size(390, 884);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpHistory(
      tester,
      _FakeBookingRepository(bookings: _sampleBookings),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('3.375.000 ₫'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpHistory(
  WidgetTester tester,
  BookingRepository repository,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [bookingRepositoryProvider.overrideWithValue(repository)],
      child: const MaterialApp(home: BookingHistoryView()),
    ),
  );
}

final _sampleBookings = <BookingModel>[
  BookingModel(
    bookingId: 21,
    userId: 9,
    tourId: 2,
    bookingDate: DateTime(2027, 10, 15),
    totalCost: 3375000,
    paymentMethod: 'credit_card',
    status: 'pending',
    passengerQuantity: 2,
    confirmationCode: 'TRV-88291',
  ),
  BookingModel(
    bookingId: 22,
    userId: 9,
    tourId: 3,
    bookingDate: DateTime(2026, 5, 10),
    totalCost: 8200000,
    paymentMethod: 'e_wallet',
    status: 'completed',
    passengerQuantity: 1,
    confirmationCode: 'TRV-88304',
  ),
  BookingModel(
    bookingId: 23,
    userId: 9,
    tourId: 1,
    bookingDate: DateTime(2026, 2, 12),
    totalCost: 4500000,
    paymentMethod: 'bank_transfer',
    status: 'cancelled',
    passengerQuantity: 3,
    confirmationCode: 'TRV-88310',
  ),
];

class _FakeBookingRepository implements BookingRepository {
  _FakeBookingRepository({
    this.bookings = const [],
    this.historyFuture,
    this.error,
  });

  final List<BookingModel> bookings;
  final Future<List<BookingModel>>? historyFuture;
  final Object? error;

  @override
  Future<List<BookingModel>> getBookingHistory(int userId) async {
    final pendingHistory = historyFuture;
    if (pendingHistory != null) return pendingHistory;
    final historyError = error;
    if (historyError != null) throw historyError;
    return bookings;
  }

  @override
  Future<BookingResult> createBooking(BookingRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<BookingModel?> getBookingDetail({
    required int bookingId,
    required int userId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool> submitReview(ReviewRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<PromoResult> validatePromoCode(String code, double subtotal) {
    throw UnimplementedError();
  }
}
