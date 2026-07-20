import 'package:go_router/go_router.dart';
import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../models/booking_flow_models.dart';
import '../models/booking_model.dart';
import '../presentation/views/traveler_info_view.dart';
import '../presentation/views/payment_method_view.dart';
import '../presentation/views/checkout_confirmation_view.dart';
import '../presentation/views/booking_success_view.dart';
import '../presentation/views/booking_failed_view.dart';
import '../presentation/views/booking_history_view.dart';
import '../presentation/views/booking_detail_view.dart';
import '../presentation/views/review_tour_view.dart';

List<RouteBase> bookingRoutes() => [
  GoRoute(
    path: RoutePaths.bookings,
    name: RouteNames.bookings,
    builder: (_, _) => const BookingHistoryView(),
  ),
  GoRoute(
    path: RoutePaths.bookingInfo,
    builder: (_, state) {
      final extra = state.extra;
      BookingStartArgs? startArgs;
      if (extra is BookingStartArgs) {
        startArgs = extra;
      } else {
        final tourId = int.tryParse(state.uri.queryParameters['tourId'] ?? '');
        final basePrice = double.tryParse(
          state.uri.queryParameters['basePrice'] ?? '',
        );
        if (tourId != null && basePrice != null) {
          startArgs = BookingStartArgs(tourId: tourId, basePrice: basePrice);
        }
      }
      return TravelerInfoView(startArgs: startArgs);
    },
  ),
  GoRoute(
    path: RoutePaths.bookingPayment,
    builder: (_, _) => const PaymentMethodView(),
  ),
  GoRoute(
    path: RoutePaths.bookingCheckout,
    builder: (_, _) => const CheckoutConfirmationView(),
  ),
  GoRoute(
    path: RoutePaths.bookingSuccess,
    builder: (_, state) =>
        BookingSuccessView(result: state.extra as BookingResult),
  ),
  GoRoute(
    path: RoutePaths.bookingFailed,
    builder: (_, state) => BookingFailedView(error: state.extra as String?),
  ),
  GoRoute(
    path: RoutePaths.bookingDetail,
    name: RouteNames.bookingDetail,
    builder: (_, state) {
      final id = int.parse(state.pathParameters['bookingId']!);
      return BookingDetailView(bookingId: id);
    },
  ),
  GoRoute(
    path: RoutePaths.reviewTour,
    builder: (_, state) {
      final id = int.parse(state.pathParameters['bookingId']!);
      final booking = state.extra as BookingModel?;
      return ReviewTourView(bookingId: id, booking: booking);
    },
  ),
];
