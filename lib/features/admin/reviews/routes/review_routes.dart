import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/router/route_paths.dart';
import '../presentation/views/review_management_screen.dart';

List<RouteBase> reviewRoutes() => [
  GoRoute(
    path: RoutePaths.adminReviews,
    name: RouteNames.adminReviews,
    builder: (_, _) => const ReviewManagementScreen(),
  ),
];
