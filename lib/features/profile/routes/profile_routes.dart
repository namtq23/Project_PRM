import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../presentation/views/edit_profile_view.dart';
import '../presentation/views/profile_view.dart';
import '../presentation/views/settings_view.dart';

List<RouteBase> profileRoutes() => [
  GoRoute(
    path: RoutePaths.profile,
    name: RouteNames.profile,
    builder: (_, _) => const ProfileView(),
  ),
  GoRoute(
    path: RoutePaths.editProfile,
    name: RouteNames.editProfile,
    builder: (_, _) => const EditProfileView(),
  ),
  GoRoute(
    path: RoutePaths.settings,
    name: RouteNames.settings,
    builder: (_, _) => const SettingsView(),
  ),
];
