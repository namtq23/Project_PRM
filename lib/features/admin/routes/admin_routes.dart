import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/widgets/route_placeholder_screen.dart';
import '../../booking_management/routes/booking_management_routes.dart';
import '../../system_settings/routes/system_settings_routes.dart';
import '../../user_management/routes/user_management_routes.dart';

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
  ...bookingManagementRoutes(),
  ...userManagementRoutes(),
  GoRoute(
    path: RoutePaths.adminReviews,
    name: RouteNames.adminReviews,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Reviews'),
  ),
  ...systemSettingsRoutes(),
];
