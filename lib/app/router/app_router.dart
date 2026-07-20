import 'package:go_router/go_router.dart';

import '../../features/admin/routes/admin_routes.dart';
import '../../features/authentication/routes/auth_routes.dart';
import '../../features/bookings/routes/booking_routes.dart';
import '../../features/profile/routes/profile_routes.dart';
import '../../features/tours/routes/tour_routes.dart';
import 'route_paths.dart';
import 'router_error_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.bookingInfo, // TEMP UI PREVIEW
  routes: [
    ...authenticationRoutes(),
    ...tourRoutes(),
    ...bookingRoutes(),
    ...profileRoutes(),
    ...adminRoutes(),
  ],
  errorBuilder: (_, state) => RouterErrorScreen(error: state.error),
);
