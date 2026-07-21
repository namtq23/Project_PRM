import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/widgets/route_placeholder_screen.dart';
import '../presentation/views/home_screen.dart';
import '../presentation/views/tour_management_screen.dart';
import '../presentation/views/search_results_screen.dart';
import '../presentation/views/search_screen.dart';
import '../presentation/views/tour_detail_screen.dart';

List<RouteBase> tourRoutes() => [
  GoRoute(
    path: RoutePaths.home,
    name: RouteNames.home,
    builder: (_, _) => const HomeScreen(),
  ),
  GoRoute(
    path: RoutePaths.search,
    name: RouteNames.search,
    builder: (_, _) => const SearchScreen(),
  ),
  GoRoute(
    path: RoutePaths.searchResults,
    name: RouteNames.searchResults,
    builder: (_, state) =>
        SearchResultsScreen(query: state.uri.queryParameters['q'] ?? ''),
  ),
  GoRoute(
    path: RoutePaths.wishlist,
    name: RouteNames.wishlist,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Wishlist'),
  ),
  GoRoute(
    path: RoutePaths.tourDetail,
    name: RouteNames.tourDetail,
    builder: (_, state) =>
        TourDetailScreen(tourId: int.parse(state.pathParameters['tourId']!)),
  ),
  GoRoute(
    path: '/admin/tours',
    name: 'tourManagement',
    builder: (_, _) => const TourManagementScreen(),
  ),
];
