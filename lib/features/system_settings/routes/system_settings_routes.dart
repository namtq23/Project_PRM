import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../presentation/views/system_settings_screen.dart';

List<RouteBase> systemSettingsRoutes() => [
  GoRoute(
    path: RoutePaths.adminSettings,
    name: RouteNames.adminSettings,
    builder: (context, state) => const SystemSettingsScreen(),
  ),
];
