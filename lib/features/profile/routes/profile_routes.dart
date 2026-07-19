import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/widgets/route_placeholder_screen.dart';

List<RouteBase> profileRoutes() => [
  GoRoute(
    path: RoutePaths.profile,
    name: RouteNames.profile,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Profile'),
  ),
  GoRoute(
    path: RoutePaths.settings,
    name: RouteNames.settings,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Settings'),
  ),
];
