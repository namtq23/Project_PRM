import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_prm/features/bookings/models/booking_flow_models.dart';
import 'package:project_prm/features/bookings/presentation/view_models/booking_view_model.dart';
import 'package:project_prm/features/bookings/presentation/views/traveler_info_view.dart';

void main() {
  testWidgets('initializes booking draft after the first widget frame', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: TravelerInfoView(
            startArgs: BookingStartArgs(tourId: 2, basePrice: 1250000),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    final draft = container.read(bookingViewModelProvider);
    expect(draft.tourId, 2);
    expect(draft.basePrice, 1250000);
  });
}
