import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../models/profile_model.dart';

abstract final class ProfileRadii {
  static const medium = 14.0;
  static const large = 16.0;
}

ImageProvider<Object>? profileAvatarProvider(String? avatarUrl) {
  final value = avatarUrl?.trim();
  if (value == null || value.isEmpty) return null;
  if (value.startsWith('data:image/')) {
    try {
      return MemoryImage(base64Decode(value.substring(value.indexOf(',') + 1)));
    } on FormatException {
      return null;
    }
  }
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return NetworkImage(value);
  }
  return null;
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.fullName,
    this.avatarUrl,
    this.radius = 52,
    super.key,
  });

  final String fullName;
  final String? avatarUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final image = profileAvatarProvider(avatarUrl);
    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.primaryContainer,
      foregroundImage: image,
      child: image == null
          ? Text(
              _initials(fullName),
              style: TextStyle(
                color: colors.onPrimaryContainer,
                fontSize: radius * 0.58,
                fontWeight: FontWeight.w700,
              ),
            )
          : null,
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

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.profile, super.key});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ProfileAvatar(
              fullName: profile.fullName,
              avatarUrl: profile.avatarUrl,
            ),
            Positioned(
              right: -2,
              bottom: 2,
              child: Material(
                color: colors.primary,
                shape: CircleBorder(
                  side: BorderSide(color: colors.surface, width: 3),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => context.pushNamed(RouteNames.editProfile),
                  child: Padding(
                    padding: const EdgeInsets.all(9),
                    child: Icon(
                      Icons.edit_outlined,
                      color: colors.onPrimary,
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
          profile.fullName,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          profile.email,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
        if (profile.phone?.isNotEmpty == true) ...[
          const SizedBox(height: 5),
          Text(
            profile.phone!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ],
    );
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
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(ProfileRadii.large),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
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
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      minTileHeight: 72,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: colors.onPrimaryContainer, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: colors.onSurfaceVariant,
      ),
    );
  }
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
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: CircleAvatar(
            radius: 52,
            backgroundColor: colors.surfaceContainerHighest,
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(
          5,
          (_) => Container(
            height: 72,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(ProfileRadii.large),
            ),
          ),
        ),
      ],
    );
  }
}
