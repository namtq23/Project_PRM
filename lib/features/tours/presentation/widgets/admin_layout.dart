import 'package:flutter/material.dart';
import '../theme/tours_theme.dart';
import '../views/create_tour_screen.dart';
import '../../../../core/widgets/admin_sidebar.dart';
import '../../../../app/router/route_paths.dart';

class AdminLayout extends StatelessWidget {
  const AdminLayout({
    required this.child,
    this.currentMenu = 'Tours',
    super.key,
  });

  final Widget child;
  final String currentMenu;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      drawer: !isWide ? Drawer(child: _buildSidebar(context)) : null,
      backgroundColor: ToursTheme.background,
      body: Row(
        children: [
          if (isWide) SizedBox(width: 256, child: _buildSidebar(context)),
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(context, !isWide),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return AdminSidebar(
      currentPath: _currentPathFor(currentMenu),
      onCreateTourPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CreateTourScreen()),
        );
      },
    );
  }

  String _currentPathFor(String menu) {
    switch (menu.toLowerCase()) {
      case 'dashboard':
        return RoutePaths.adminDashboard;
      case 'tours':
        return RoutePaths.adminTours;
      case 'categories':
        return RoutePaths.adminCategories;
      case 'bookings':
        return RoutePaths.adminBookings;
      case 'users':
        return RoutePaths.adminUsers;
      case 'reviews':
        return RoutePaths.adminReviews;
      case 'analytics':
        return RoutePaths.adminAnalytics;
      case 'settings':
        return RoutePaths.adminSettings;
      default:
        return RoutePaths.adminTours;
    }
  }

  Widget _buildTopHeader(BuildContext context, bool showMenuButton) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: ToursTheme.surfaceContainer,
        border: Border(
          bottom: BorderSide(color: ToursTheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          if (showMenuButton) ...[
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            const SizedBox(width: 8),
          ],
          // Search Field
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                height: 40,
                decoration: BoxDecoration(
                  color: ToursTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
                  border: Border.all(
                    color: ToursTheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm nhanh...',
                    hintStyle: TextStyle(
                      color: ToursTheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 18,
                      color: ToursTheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Actions
          IconButton(
            icon: const Icon(
              Icons.help_outline,
              color: ToursTheme.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: ToursTheme.onSurfaceVariant,
                ),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: ToursTheme.danger,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const VerticalDivider(
            color: ToursTheme.outlineVariant,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(width: 16),
          // Admin Profile
          const Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=100&auto=format&fit=crop',
                ),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hoàng Anh',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Chief Admin',
                    style: TextStyle(
                      color: ToursTheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
