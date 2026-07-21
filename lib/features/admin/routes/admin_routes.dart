import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/widgets/route_placeholder_screen.dart';
import '../../categories/presentation/views/category_management_screen.dart';
import '../../categories/presentation/views/create_category_screen.dart';
import '../../categories/presentation/views/edit_category_screen.dart';

import '../../analytics/presentation/views/tour_statistics_screen.dart';

import '../../reviews/presentation/views/review_management_screen.dart';

List<RouteBase> adminRoutes() => [
  GoRoute(
    path: RoutePaths.adminDashboard,
    name: RouteNames.adminDashboard,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Dashboard'),
  ),
  GoRoute(
    path: RoutePaths.adminTours,
    name: RouteNames.adminTours,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Tours'),
  ),
  GoRoute(
    path: RoutePaths.adminCategories,
    name: RouteNames.adminCategories,
    builder: (_, _) => const CategoryManagementScreen(),
  ),
  GoRoute(
    path: '/admin/categories/create',
    name: 'adminCategoriesCreate',
    builder: (_, _) => const CreateCategoryScreen(),
  ),
  GoRoute(
    path: '/admin/categories/edit/:id',
    name: 'adminCategoriesEdit',
    builder: (_, state) {
      final idStr = state.pathParameters['id'];
      final id = int.tryParse(idStr ?? '');
      return EditCategoryScreen(categoryId: id);
    },
  ),
  GoRoute(
    path: RoutePaths.adminBookings,
    name: RouteNames.adminBookings,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Bookings'),
  ),
  GoRoute(
    path: RoutePaths.adminUsers,
    name: RouteNames.adminUsers,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Users'),
  ),
  GoRoute(
    path: RoutePaths.adminReviews,
    name: RouteNames.adminReviews,
    builder: (_, _) => const ReviewManagementScreen(),
  ),
  GoRoute(
    path: RoutePaths.adminSettings,
    name: RouteNames.adminSettings,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Settings'),
  ),
  GoRoute(
    path: RoutePaths.adminAnalytics,
    name: RouteNames.adminAnalytics,
    builder: (_, _) => const TourStatisticsScreen(),
  ),
];
