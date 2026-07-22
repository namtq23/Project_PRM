import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/widgets/route_placeholder_screen.dart';

import '../content_management/manage_categories/routes/manage_categories_routes.dart';
import '../content_management/manage_tours/routes/manage_tours_routes.dart';
import '../content_management/view_tour_stats/routes/tour_stats_routes.dart';
import '../reviews/routes/review_routes.dart';

import '../../booking_management/routes/booking_management_routes.dart';
import '../../system_settings/routes/system_settings_routes.dart';
import '../../user_management/routes/user_management_routes.dart';

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
  ...bookingManagementRoutes(),
  ...userManagementRoutes(),
  ...systemSettingsRoutes(),
];
