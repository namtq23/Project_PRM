import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/admin/routes/admin_routes.dart';
import '../../features/authentication/presentation/states/auth_state.dart';
import '../../features/authentication/presentation/view_models/auth_view_model.dart';
import '../../features/authentication/routes/auth_routes.dart';
import '../../features/bookings/routes/booking_routes.dart';
import '../../features/profile/routes/profile_routes.dart';
import '../../features/tours/routes/tour_routes.dart';
import 'route_paths.dart';
import 'router_error_screen.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refreshNotifier = _RouterRefreshNotifier();
  ref
    ..listen(authViewModelProvider, (_, _) => refreshNotifier.refresh())
    ..onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: refreshNotifier,
    redirect: (_, state) {
      final auth = ref.read(authViewModelProvider);
      final location = state.matchedLocation;

      if (auth.isLoading || auth.value is AuthInitializing) {
        return location == RoutePaths.splash ? null : RoutePaths.splash;
      }

      final authState = auth.value;
      final isAuthenticationRoute = {
        RoutePaths.login,
        RoutePaths.register,
        RoutePaths.forgotPassword,
      }.contains(location);

      if (authState is! AuthAuthenticated) {
        return isAuthenticationRoute ? null : RoutePaths.login;
      }

      final isAdmin = authState.user.role.toLowerCase() == 'admin';
      final isAdminRoute =
          location == RoutePaths.adminDashboard ||
          location.startsWith('${RoutePaths.adminDashboard}/');
      if (isAdmin && !isAdminRoute) return RoutePaths.adminDashboard;
      if (!isAdmin && isAdminRoute) return RoutePaths.home;
      if (isAuthenticationRoute || location == RoutePaths.splash) {
        return isAdmin ? RoutePaths.adminDashboard : RoutePaths.home;
      }
      return null;
    },
    routes: [
      ...authenticationRoutes(),
      ...tourRoutes(),
      ...bookingRoutes(),
      ...profileRoutes(),
      ...adminRoutes(),
    ],
    errorBuilder: (_, state) => RouterErrorScreen(error: state.error),
  );
}

class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}
