import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/widgets/route_placeholder_screen.dart';

List<RouteBase> adminRoutes() => [
  GoRoute(
    path: RoutePaths.adminDashboard,
    name: RouteNames.adminDashboard,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Dashboard'),
  ),
  GoRoute(
    path: RoutePaths.adminTours,
    name: RouteNames.adminTours,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Tours'),
  ),
  GoRoute(
    path: RoutePaths.adminCategories,
    name: RouteNames.adminCategories,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Categories'),
  ),
  GoRoute(
    path: RoutePaths.adminBookings,
    name: RouteNames.adminBookings,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Bookings'),
  ),
  GoRoute(
    path: RoutePaths.adminUsers,
    name: RouteNames.adminUsers,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Users'),
  ),
  GoRoute(
    path: RoutePaths.adminReviews,
    name: RouteNames.adminReviews,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Reviews'),
  ),
  GoRoute(
    path: RoutePaths.adminSettings,
    name: RouteNames.adminSettings,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Settings'),
  ),
];
