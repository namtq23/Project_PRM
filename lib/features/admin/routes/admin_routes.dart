import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/widgets/route_placeholder_screen.dart';

import '../content_management/manage_categories/routes/manage_categories_routes.dart';
import '../content_management/manage_tours/routes/manage_tours_routes.dart';
import '../content_management/view_tour_stats/routes/tour_stats_routes.dart';
import '../reviews/routes/review_routes.dart';

import '../../booking_management/presentation/views/booking_management_screen.dart';
import '../../user_management/presentation/views/user_management_screen.dart';

List<RouteBase> adminRoutes() => [
  GoRoute(
    path: RoutePaths.adminDashboard,
    name: RouteNames.adminDashboard,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Dashboard'),
  ),
  ...manageToursRoutes(),
  ...manageCategoriesRoutes(),
  ...tourStatsRoutes(),
  ...reviewRoutes(),
  GoRoute(
    path: RoutePaths.adminBookings,
    name: RouteNames.adminBookings,
    builder: (_, _) => const BookingManagementScreen(),
  ),
  GoRoute(
    path: RoutePaths.adminUsers,
    name: RouteNames.adminUsers,
    builder: (_, _) => const UserManagementScreen(),
  ),
  GoRoute(
    path: RoutePaths.adminSettings,
    name: RouteNames.adminSettings,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Settings'),
  ),
];
