import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/router/route_paths.dart';
import '../../../../tours/presentation/views/create_tour_screen.dart';
import '../../../../tours/presentation/views/tour_management_screen.dart';

List<RouteBase> manageToursRoutes() => [
  GoRoute(
    path: RoutePaths.adminTours,
    name: RouteNames.adminTours,
    builder: (_, _) => const TourManagementScreen(),
  ),
  GoRoute(
    path: '/admin/tours/create',
    name: 'adminToursCreate',
    builder: (_, _) => const CreateTourScreen(),
  ),
  GoRoute(
    path: '/admin/tours/edit/:id',
    name: 'adminToursEdit',
    builder: (_, state) {
      return const TourManagementScreen();
    },
  ),
];
