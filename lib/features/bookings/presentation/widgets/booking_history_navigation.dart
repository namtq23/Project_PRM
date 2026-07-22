import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import 'booking_design.dart';

class BookingHistoryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const BookingHistoryAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      backgroundColor: const Color(0xFF101417),
      foregroundColor: BookingDesign.mutedText,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 4,
      title: const Text(
        'Chuyến đi',
        style: TextStyle(
          color: BookingDesign.primary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Tooltip(
            message: 'Hồ sơ',
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.go(RoutePaths.profile),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: BookingDesign.surfaceHigh,
                  border: Border.all(color: BookingDesign.outline),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: BookingDesign.primary,
                  size: 25,
                ),
              ),
            ),
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: BookingDesign.surfaceContainer,
        ),
      ),
    );
  }
}

class BookingHistoryNavigationBar extends StatelessWidget {
  const BookingHistoryNavigationBar({super.key});

  static const _items = <({IconData icon, String label, String route})>[
    (icon: Icons.home_outlined, label: 'Trang chủ', route: RoutePaths.home),
    (icon: Icons.explore_outlined, label: 'Khám phá', route: RoutePaths.search),
    (
      icon: Icons.favorite_border,
      label: 'Yêu thích',
      route: RoutePaths.wishlist,
    ),
    (
      icon: Icons.confirmation_number_outlined,
      label: 'Chuyến đi',
      route: RoutePaths.bookings,
    ),
    (icon: Icons.person_outline, label: 'Hồ sơ', route: RoutePaths.profile),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF101417),
        border: Border(
          top: BorderSide(color: BookingDesign.outline.withValues(alpha: 0.45)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 76,
          child: Row(
            children: _items
                .map(
                  (item) => Expanded(
                    child: _BookingNavigationItem(
                      icon: item.icon,
                      label: item.label,
                      selected: item.route == RoutePaths.bookings,
                      onTap: item.route == RoutePaths.bookings
                          ? null
                          : () => context.go(item.route),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ),
    );
  }
}

class _BookingNavigationItem extends StatelessWidget {
  const _BookingNavigationItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = selected
        ? BookingDesign.primary
        : BookingDesign.mutedText;

    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 7),
        child: Material(
          color: selected ? const Color(0xFF082C3C) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 25, color: foregroundColor),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookingMenuDrawer extends StatelessWidget {
  const BookingMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: BookingDesign.surface,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 18),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: BookingDesign.surfaceHigh,
                    child: Icon(
                      Icons.person_outline,
                      color: BookingDesign.primary,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'VietTravel',
                      style: TextStyle(
                        color: BookingDesign.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: BookingDesign.outline, height: 1),
            _DrawerDestination(
              icon: Icons.home_outlined,
              label: 'Trang chủ',
              onTap: () => context.go(RoutePaths.home),
            ),
            _DrawerDestination(
              icon: Icons.confirmation_number_outlined,
              label: 'Chuyến đi',
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerDestination(
              icon: Icons.favorite_border,
              label: 'Yêu thích',
              onTap: () => context.go(RoutePaths.wishlist),
            ),
            _DrawerDestination(
              icon: Icons.person_outline,
              label: 'Hồ sơ',
              onTap: () => context.go(RoutePaths.profile),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerDestination extends StatelessWidget {
  const _DrawerDestination({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF082C3C) : Colors.transparent,
      child: ListTile(
        selected: selected,
        leading: Icon(
          icon,
          color: selected ? BookingDesign.primary : BookingDesign.mutedText,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: selected ? BookingDesign.primary : BookingDesign.text,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
