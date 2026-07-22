import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/tours_theme.dart';
import '../views/create_tour_screen.dart';

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
    return Container(
      color: ToursTheme.surfaceContainerLow,
      child: Column(
        children: [
          // Logo / Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ToursTheme.outlineVariant,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ToursTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.explore,
                    color: ToursTheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Voyage Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Executive Suite',
                        style: TextStyle(
                          color: ToursTheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              children: [
                _buildMenuItem(context, 'Dashboard', Icons.dashboard_outlined),
                _buildMenuItem(context, 'Tours', Icons.tour_outlined),
                _buildMenuItem(context, 'Categories', Icons.category_outlined),
                _buildMenuItem(context, 'Bookings', Icons.book_online_outlined),
                _buildMenuItem(context, 'Users', Icons.people_outline),
                _buildMenuItem(context, 'Reviews', Icons.star_outline),
                _buildMenuItem(context, 'Analytics', Icons.analytics_outlined),
                _buildMenuItem(context, 'Settings', Icons.settings_outlined),
              ],
            ),
          ),
          // Footer Add Tour Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ToursTheme.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateTourScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Thêm Tour Mới',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon) {
    final isActive = title.toLowerCase() == currentMenu.toLowerCase();

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isActive
            ? ToursTheme.primary.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(
            icon,
            color: isActive ? ToursTheme.primary : ToursTheme.onSurfaceVariant,
            size: 20,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : ToursTheme.onSurfaceVariant,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          onTap: () {
            if (title.toLowerCase() == 'tours') {
              context.go('/admin/tours');
            } else if (title.toLowerCase() == 'categories') {
              context.go('/admin/categories');
            } else if (title.toLowerCase() == 'analytics') {
              context.go('/admin/analytics');
            } else if (title.toLowerCase() == 'reviews') {
              context.go('/admin/reviews');
            } else if (title.toLowerCase() == 'dashboard') {
              context.go('/admin');
            }
          },
        ),
      ),
    );
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
