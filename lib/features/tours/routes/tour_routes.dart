import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/widgets/route_placeholder_screen.dart';
import '../presentation/views/home_screen.dart';

List<RouteBase> tourRoutes() => [
  GoRoute(
    path: RoutePaths.home,
    name: RouteNames.home,
    builder: (_, _) => const HomeScreen(),
  ),
  GoRoute(
    path: RoutePaths.search,
    name: RouteNames.search,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Search'),
  ),
  GoRoute(
    path: RoutePaths.wishlist,
    name: RouteNames.wishlist,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Wishlist'),
  ),
  GoRoute(
    path: RoutePaths.tourDetail,
    name: RouteNames.tourDetail,
    builder: (_, state) => RoutePlaceholderScreen(
      title: 'Tour Detail',
      details: 'Tour ID: ${state.pathParameters['tourId']}',
    ),
  ),
];
