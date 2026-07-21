import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../presentation/views/booking_management_screen.dart';

List<RouteBase> bookingManagementRoutes() => [
  GoRoute(
    path: RoutePaths.adminBookings,
    name: RouteNames.adminBookings,
    builder: (context, state) => const BookingManagementScreen(),
  ),
];
