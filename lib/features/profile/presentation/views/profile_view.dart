import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../authentication/presentation/view_models/auth_view_model.dart';
import '../../models/profile_model.dart';
import '../view_models/profile_view_model.dart';
import '../widgets/profile_widget.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Cài đặt',
            onPressed: () => context.pushNamed(RouteNames.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: profile.when(
        loading: () => const ProfileSkeleton(),
        error: (error, _) => _ProfileError(
          onRetry: () => ref.invalidate(profileViewModelProvider),
        ),
        data: (value) => value == null
            ? const Center(child: Text('Không tìm thấy thông tin hồ sơ.'))
            : _ProfileContent(profile: value),
      ),
      bottomNavigationBar: const ProfileBottomNavigation(),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
    children: [
      ProfileHeader(profile: profile),
      const SizedBox(height: 28),
      ProfileMenuSection(
        title: 'Tài khoản',
        children: [
          ProfileMenuTile(
            icon: Icons.person_outline_rounded,
            title: 'Thông tin cá nhân',
            subtitle: 'Cập nhật tên, số điện thoại và ảnh đại diện',
            onTap: () => context.pushNamed(RouteNames.editProfile),
          ),
          ProfileMenuTile(
            icon: Icons.confirmation_number_outlined,
            title: 'Lịch sử đặt chỗ',
            subtitle: 'Xem và quản lý các chuyến đi của bạn',
            onTap: () => context.goNamed(RouteNames.bookings),
          ),
          ProfileMenuTile(
            icon: Icons.favorite_border_rounded,
            title: 'Tour yêu thích',
            subtitle: 'Những hành trình bạn đã lưu',
            onTap: () => context.goNamed(RouteNames.wishlist),
          ),
        ],
      ),
      const SizedBox(height: 20),
      ProfileMenuSection(
        title: 'Ứng dụng',
        children: [
          ProfileMenuTile(
            icon: Icons.settings_outlined,
            title: 'Cài đặt',
            subtitle: 'Ngôn ngữ, thông báo và giao diện',
            onTap: () => context.pushNamed(RouteNames.settings),
          ),
          const ProfileMenuTile(
            icon: Icons.help_outline_rounded,
            title: 'Trợ giúp & hỗ trợ',
            subtitle: 'Câu hỏi thường gặp và liên hệ VietTravel',
          ),
        ],
      ),
      const SizedBox(height: 24),
      OutlinedButton.icon(
        onPressed: () => ref.read(authViewModelProvider.notifier).logout(),
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Đăng xuất'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
          side: BorderSide(color: Theme.of(context).colorScheme.error),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ProfileRadii.medium),
          ),
        ),
      ),
    ],
  );
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_outlined, size: 48),
          const SizedBox(height: 12),
          const Text('Không thể tải thông tin hồ sơ.'),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    ),
  );
}
