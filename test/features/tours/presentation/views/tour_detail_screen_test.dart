import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:project_prm/app/router/route_paths.dart';
import 'package:project_prm/features/bookings/models/booking_flow_models.dart';
import 'package:project_prm/features/tours/presentation/widgets/tour_detail_widgets.dart';

void main() {
  testWidgets('book now opens booking info with the selected tour', (
    tester,
  ) async {
    BookingStartArgs? receivedArgs;
    final router = GoRouter(
      initialLocation: '/tour-detail-test',
      routes: [
        GoRoute(
          path: '/tour-detail-test',
          builder: (context, _) => Scaffold(
            bottomNavigationBar: TourDetailBottomBar(
              price: 3850000,
              onBook: () => context.push(
                RoutePaths.bookingInfo,
                extra: const BookingStartArgs(tourId: 7, basePrice: 3850000),
              ),
            ),
          ),
        ),
        GoRoute(
          path: RoutePaths.bookingInfo,
          builder: (_, state) {
            receivedArgs = state.extra as BookingStartArgs?;
            return const Scaffold(body: Text('booking-info'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text('booking-info'), findsOneWidget);
    expect(receivedArgs?.tourId, 7);
    expect(receivedArgs?.basePrice, 3850000);
  });
}
