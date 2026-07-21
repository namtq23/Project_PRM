import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/widgets/route_placeholder_screen.dart';
import '../../booking_details/presentation/views/booking_details_screen.dart';
import '../../booking_management/presentation/views/booking_management_screen.dart';
import '../../system_settings/presentation/views/system_settings_screen.dart';
import '../../user_management/presentation/views/user_management_screen.dart';

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
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Categories'),
  ),
  GoRoute(
    path: RoutePaths.adminBookings,
    name: RouteNames.adminBookings,
    builder: (_, _) => const BookingManagementScreen(),
  ),
  GoRoute(
    path: RoutePaths.adminUsers,
    name: RouteNames.adminUsers,
    builder: (_, _) => const UserManagementScreen(),
  ),
  GoRoute(
    path: RoutePaths.adminReviews,
    name: RouteNames.adminReviews,
    builder: (_, _) => const RoutePlaceholderScreen(title: 'Admin Reviews'),
  ),
  GoRoute(
    path: RoutePaths.adminSettings,
    name: RouteNames.adminSettings,
    builder: (_, _) => const SystemSettingsScreen(),
  ),
  GoRoute(
    path: RoutePaths.adminBookingDetail,
    name: RouteNames.adminBookingDetail,
    builder: (_, state) {
      final bookingIdStr = state.pathParameters['bookingId'] ?? '0';
      final bookingId = int.tryParse(bookingIdStr) ?? 0;
      return BookingDetailsScreen(bookingId: bookingId);
    },
  ),
];
