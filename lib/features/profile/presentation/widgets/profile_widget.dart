import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../authentication/domain/models/app_user.dart';

abstract final class ProfilePalette {
  static const primary = Color(0xFF0EA5E9);
  static const primaryDark = Color(0xFF036B99);
  static const primarySoft = Color(0xFFE0F2FE);
  static const background = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const text = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);
  static const danger = Color(0xFFDC2626);
  static const dangerBorder = Color(0xFFFECACA);
}

abstract final class ProfileRadii {
  static const medium = 14.0;
  static const large = 16.0;
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.user, super.key});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user.avatarUrl?.trim();
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 52,
              backgroundColor: ProfilePalette.primarySoft,
              foregroundImage: avatarUrl == null || avatarUrl.isEmpty
                  ? null
                  : NetworkImage(avatarUrl),
              child: Text(
                _initials(user.fullName),
                style: const TextStyle(
                  color: ProfilePalette.primaryDark,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              right: -2,
              bottom: 2,
              child: Material(
                color: ProfilePalette.primary,
                shape: const CircleBorder(
                  side: BorderSide(color: Colors.white, width: 3),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => context.pushNamed(RouteNames.editProfile),
                  child: const Padding(
                    padding: EdgeInsets.all(9),
                    child: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.fullName,
          style: const TextStyle(
            color: ProfilePalette.text,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          user.email,
          style: const TextStyle(color: ProfilePalette.muted, fontSize: 15),
        ),
      ],
    );
  }

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return '?';
    return words.length == 1
        ? words.first[0].toUpperCase()
        : '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 10),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: ProfilePalette.muted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: ProfilePalette.surface,
          borderRadius: BorderRadius.circular(ProfileRadii.large),
          border: Border.all(color: ProfilePalette.border),
        ),
        child: Column(children: children),
      ),
    ],
  );
}

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    minTileHeight: 72,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    leading: Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: ProfilePalette.primarySoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: ProfilePalette.primaryDark, size: 22),
    ),
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: ProfilePalette.text,
      ),
    ),
    subtitle: Text(
      subtitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: ProfilePalette.muted, fontSize: 12),
    ),
    trailing: const Icon(
      Icons.chevron_right_rounded,
      color: ProfilePalette.muted,
    ),
  );
}

class ProfileBottomNavigation extends StatelessWidget {
  const ProfileBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: 4,
    onDestinationSelected: (index) {
      switch (index) {
        case 0:
          context.goNamed(RouteNames.home);
        case 1:
          context.goNamed(RouteNames.search);
        case 2:
          context.goNamed(RouteNames.bookings);
        case 3:
          context.goNamed(RouteNames.wishlist);
      }
    },
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.explore_outlined),
        label: 'Khám phá',
      ),
      NavigationDestination(
        icon: Icon(Icons.search_rounded),
        label: 'Tìm kiếm',
      ),
      NavigationDestination(
        icon: Icon(Icons.confirmation_number_outlined),
        label: 'Đặt chỗ',
      ),
      NavigationDestination(
        icon: Icon(Icons.favorite_border_rounded),
        label: 'Yêu thích',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline_rounded),
        selectedIcon: Icon(Icons.person_rounded),
        label: 'Cá nhân',
      ),
    ],
  );
}

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Center(
        child: CircleAvatar(radius: 52, backgroundColor: ProfilePalette.border),
      ),
      const SizedBox(height: 20),
      ...List.generate(
        5,
        (_) => Container(
          height: 72,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: ProfilePalette.surface,
            borderRadius: BorderRadius.circular(ProfileRadii.large),
          ),
        ),
      ),
    ],
  );
}
