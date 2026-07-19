import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/widgets/route_placeholder_screen.dart';

List<RouteBase> bookingRoutes() => [
  GoRoute(
    path: RoutePaths.bookings,
    name: RouteNames.bookings,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Bookings'),
  ),
  GoRoute(
    path: RoutePaths.bookingDetail,
    name: RouteNames.bookingDetail,
    builder: (_, state) => RoutePlaceholderScreen(
      title: 'Booking Detail',
      details: 'Booking ID: ${state.pathParameters['bookingId']}',
    ),
  ),
];
