import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../presentation/views/forgot_password_screen.dart';
import '../presentation/views/login_screen.dart';
import '../presentation/views/register_screen.dart';
import '../presentation/views/splash_screen.dart';

List<RouteBase> authenticationRoutes() => [
  GoRoute(
    path: RoutePaths.splash,
    name: RouteNames.splash,
    builder: (_, _) => const SplashScreen(),
  ),
  GoRoute(
    path: RoutePaths.login,
    name: RouteNames.login,
    builder: (_, _) => const LoginScreen(),
  ),
  GoRoute(
    path: RoutePaths.register,
    name: RouteNames.register,
    builder: (_, _) => const RegisterScreen(),
  ),
  GoRoute(
    path: RoutePaths.forgotPassword,
    name: RouteNames.forgotPassword,
    builder: (_, _) => const ForgotPasswordScreen(),
  ),
];
