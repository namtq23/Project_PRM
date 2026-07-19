import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8FAFC),
    drawer: const _GuestDrawer(),
    appBar: AppBar(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF0F172A),
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Khám phá',
        style: TextStyle(color: Color(0xFF036B99), fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          tooltip: 'Yêu thích',
          onPressed: () => context.goNamed(RouteNames.wishlist),
          icon: const Icon(Icons.favorite_border),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: const _HomeContent(),
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (index) {
        switch (index) {
          case 1:
            context.goNamed(RouteNames.search);
          case 2:
            context.goNamed(RouteNames.bookings);
          case 3:
            context.goNamed(RouteNames.wishlist);
          case 4:
            context.goNamed(RouteNames.profile);
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: 'Khám phá',
        ),
        NavigationDestination(icon: Icon(Icons.search), label: 'Tìm kiếm'),
        NavigationDestination(
          icon: Icon(Icons.confirmation_number_outlined),
          label: 'Đặt chỗ',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border),
          label: 'Yêu thích',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Cá nhân',
        ),
      ],
    ),
  );
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const HomeHero(),
      const SizedBox(height: 26),
      const HomeSectionHeader(title: 'Danh mục', action: 'Tất cả'),
      const SizedBox(height: 12),
      const CategoryChips(),
      const SizedBox(height: 30),
      const HomeSectionHeader(title: 'Tour nổi bật', action: 'Xem tất cả'),
      const SizedBox(height: 14),
      LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth >= 850
              ? (constraints.maxWidth - 32) / 3
              : constraints.maxWidth;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: featuredTours
                .map(
                  (tour) => SizedBox(
                    width: width,
                    child: TourCard(tour: tour),
                  ),
                )
                .toList(),
          );
        },
      ),
      const SizedBox(height: 30),
      const Text(
        'Điểm đến phổ biến',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 14),
      const DestinationGrid(),
      const SizedBox(height: 28),
    ],
  );
}

class _GuestDrawer extends StatelessWidget {
  const _GuestDrawer();

  @override
  Widget build(BuildContext context) => Drawer(
    child: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 38,
                    color: Color(0xFF036B99),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Bạn chưa đăng nhập',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Đăng nhập để quản lý chuyến đi của bạn.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => context.goNamed(RouteNames.login),
                    icon: const Icon(Icons.login),
                    label: const Text('Đăng nhập'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF036B99),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.goNamed(RouteNames.register),
                  child: const Text('Tạo tài khoản mới'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.explore_outlined),
            title: const Text('Khám phá'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('Tour yêu thích'),
            onTap: () => context.goNamed(RouteNames.wishlist),
          ),
          ListTile(
            leading: const Icon(Icons.confirmation_number_outlined),
            title: const Text('Đặt chỗ của tôi'),
            onTap: () => context.goNamed(RouteNames.bookings),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'VietTravel • Premium Travel',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
            ),
          ),
        ],
      ),
    ),
  );
}
