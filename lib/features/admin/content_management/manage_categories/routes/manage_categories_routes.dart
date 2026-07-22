import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/router/route_paths.dart';
import '../presentation/views/category_management_screen.dart';
import '../presentation/views/create_category_screen.dart';
import '../presentation/views/edit_category_screen.dart';

List<RouteBase> manageCategoriesRoutes() => [
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
];
