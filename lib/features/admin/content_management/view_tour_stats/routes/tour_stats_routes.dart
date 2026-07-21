import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/router/route_paths.dart';
import '../presentation/views/tour_statistics_screen.dart';

List<RouteBase> tourStatsRoutes() => [
  GoRoute(
    path: RoutePaths.adminAnalytics,
    name: RouteNames.adminAnalytics,
    builder: (_, _) => const TourStatisticsScreen(),
  ),
];
