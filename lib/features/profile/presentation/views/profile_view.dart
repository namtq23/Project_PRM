import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../authentication/domain/models/app_user.dart';
import '../../../authentication/presentation/states/auth_state.dart';
import '../../../authentication/presentation/view_models/auth_view_model.dart';
import '../widgets/profile_widget.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authViewModelProvider);
    final authState = auth.value;

    return Scaffold(
      backgroundColor: ProfilePalette.background,
      appBar: AppBar(
        backgroundColor: ProfilePalette.surface,
        surfaceTintColor: Colors.transparent,
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
      body: auth.isLoading
          ? const ProfileSkeleton()
          : authState is AuthAuthenticated
          ? _ProfileContent(user: authState.user)
          : const Center(child: Text('Không thể tải thông tin hồ sơ.')),
      bottomNavigationBar: const ProfileBottomNavigation(),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
    children: [
      ProfileHeader(user: user),
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
          foregroundColor: ProfilePalette.danger,
          side: const BorderSide(color: ProfilePalette.dangerBorder),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ProfileRadii.medium),
          ),
        ),
      ),
    ],
  );
}
