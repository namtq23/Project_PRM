import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_prm/features/bookings/models/booking_flow_models.dart';
import 'package:project_prm/features/bookings/models/booking_model.dart';
import 'package:project_prm/features/bookings/presentation/view_models/booking_view_model.dart';
import 'package:project_prm/features/bookings/presentation/views/booking_success_view.dart';
import 'package:project_prm/features/bookings/presentation/views/checkout_confirmation_view.dart';
import 'package:project_prm/features/bookings/presentation/views/payment_method_view.dart';
import 'package:project_prm/features/bookings/presentation/views/traveler_info_view.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    final notifier = container.read(bookingViewModelProvider.notifier);
    notifier.startBooking(tourId: 2, basePrice: 1250000);
    notifier.updateTravelerInfo(
      TravelerInfo(
        contactName: 'Nguyễn An',
        contactPhone: '0901234567',
        adultCount: 2,
        childCount: 1,
        selectedDate: DateTime(2027, 8, 25),
      ),
    );
    notifier.updatePaymentMethod(PaymentMethodType.creditCard);
  });

  tearDown(() => container.dispose());

  testWidgets('traveler view fits a 390px mobile viewport', (tester) async {
    _setMobileViewport(tester);
    await _pumpView(tester, container, const TravelerInfoView());

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text(
        'Giá đã bao gồm toàn bộ thuế và phí. Không phát sinh chi phí ẩn.',
      ),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('payment view fits a 390px mobile viewport', (tester) async {
    _setMobileViewport(tester);
    await _pumpView(tester, container, const PaymentMethodView());

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Thông tin chuyến đi'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('checkout view fits a 390px mobile viewport', (tester) async {
    _setMobileViewport(tester);
    await _pumpView(tester, container, const CheckoutConfirmationView());

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Chi phí tạm tính'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('success view fits a 390px mobile viewport', (tester) async {
    _setMobileViewport(tester);
    final booking = BookingModel(
      bookingId: 8,
      userId: 1,
      tourId: 2,
      bookingDate: DateTime(2027, 8, 25),
      totalCost: 3375000,
      paymentMethod: 'credit_card',
      status: 'pending',
      passengerQuantity: 3,
      confirmationCode: 'VNT-28490152',
    );
    await _pumpView(
      tester,
      container,
      BookingSuccessView(
        result: BookingResult(
          success: true,
          confirmationCode: booking.confirmationCode,
          booking: booking,
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Đặt tour thành công!'), findsOneWidget);
  });
}

void _setMobileViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 884);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _pumpView(
  WidgetTester tester,
  ProviderContainer container,
  Widget view,
) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: view),
    ),
  );
  await tester.pump();
}
