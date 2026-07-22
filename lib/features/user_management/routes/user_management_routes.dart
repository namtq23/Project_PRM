import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../presentation/views/user_management_screen.dart';

List<RouteBase> userManagementRoutes() => [
  GoRoute(
    path: RoutePaths.adminUsers,
    name: RouteNames.adminUsers,
    builder: (_, _) => const UserManagementScreen(),
  ),
];
