import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/router/route_paths.dart';

abstract class _SidebarTokens {
  static const Color background = Color(0xFF151B2D); // surface-container-low
  static const Color primary = Color(0xFF8ED5FF);
  static const Color primaryContainer = Color(0xFF38BDF8);
  static const Color onPrimaryContainer = Color(0xFF004965);
  static const Color secondaryContainer = Color(0xFF3F465C);
  static const Color onSurface = Color(0xFFDCE1FB);
  static const Color onSurfaceVariant = Color(0xFFBDC8D1);
  static const Color outlineVariant = Color(0xFF3E484F);
}

class AdminSidebarItem {
  final String title;
  final IconData icon;
  final String path;

  const AdminSidebarItem({
    required this.title,
    required this.icon,
    required this.path,
  });
}

class AdminSidebar extends StatelessWidget {
  final String currentPath;
  final VoidCallback? onCreateTourPressed;

  const AdminSidebar({
    super.key,
    required this.currentPath,
    this.onCreateTourPressed,
  });

  static const List<AdminSidebarItem> items = [
    AdminSidebarItem(
      title: 'Dashboard',
      icon: Icons.grid_view_rounded,
      path: RoutePaths.adminDashboard,
    ),
    AdminSidebarItem(
      title: 'Tours',
      icon: Icons.explore_outlined,
      path: RoutePaths.adminTours,
    ),
    AdminSidebarItem(
      title: 'Categories',
      icon: Icons.category_outlined,
      path: RoutePaths.adminCategories,
    ),
    AdminSidebarItem(
      title: 'Bookings',
      icon: Icons.book_online_outlined,
      path: RoutePaths.adminBookings,
    ),
    AdminSidebarItem(
      title: 'Users',
      icon: Icons.group_outlined,
      path: RoutePaths.adminUsers,
    ),
    AdminSidebarItem(
      title: 'Reviews',
      icon: Icons.rate_review_outlined,
      path: RoutePaths.adminReviews,
    ),
    AdminSidebarItem(
      title: 'Analytics',
      icon: Icons.analytics_outlined,
      path: RoutePaths.adminAnalytics,
    ),
    AdminSidebarItem(
      title: 'Settings',
      icon: Icons.settings_outlined,
      path: RoutePaths.adminSettings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: _SidebarTokens.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Area
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Voyage Admin',
                  style: TextStyle(
                    color: _SidebarTokens.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'EXECUTIVE SUITE',
                  style: TextStyle(
                    color: _SidebarTokens.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: _SidebarTokens.outlineVariant,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          const SizedBox(height: 12),

          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isActive =
                    currentPath == item.path ||
                    (item.path != RoutePaths.adminDashboard &&
                        currentPath.startsWith(item.path));

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
                          Navigator.pop(context);
                        }
                        if (currentPath != item.path) {
                          context.go(item.path);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? _SidebarTokens.secondaryContainer
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              size: 20,
                              color: isActive
                                  ? _SidebarTokens.primary
                                  : _SidebarTokens.onSurfaceVariant,
                            ),
                            const SizedBox(width: 14),
                            Text(
                              item.title,
                              style: TextStyle(
                                color: isActive
                                    ? _SidebarTokens.onSurface
                                    : _SidebarTokens.onSurfaceVariant,
                                fontSize: 14,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Action Button: + Create New Tour
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
                    Navigator.pop(context);
                  }
                  if (onCreateTourPressed != null) {
                    onCreateTourPressed!();
                  } else {
                    context.go(RoutePaths.adminTours);
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  'Create New Tour',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _SidebarTokens.primaryContainer,
                  foregroundColor: _SidebarTokens.onPrimaryContainer,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
