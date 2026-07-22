import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/theme_mode_view_model.dart';
import '../widgets/profile_widget.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool _bookingNotifications = true;
  bool _promotionNotifications = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeModeViewModelProvider);
    final isDarkMode = themeMode.asData?.value == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          _SettingsSection(
            title: 'Tùy chọn chung',
            children: [
              const _SettingsTile(
                icon: Icons.language_rounded,
                title: 'Ngôn ngữ',
                value: 'Tiếng Việt',
              ),
              _SettingsTile(
                icon: isDarkMode
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_outlined,
                title: 'Chế độ tối',
                subtitle: 'Dùng màu tối giống màn đặt chỗ',
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: themeMode.isLoading
                      ? null
                      : (value) => ref
                            .read(themeModeViewModelProvider.notifier)
                            .setDarkMode(value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _SettingsSection(
            title: 'Thông báo',
            children: [
              _SettingsTile(
                icon: Icons.confirmation_number_outlined,
                title: 'Cập nhật đặt chỗ',
                trailing: Switch(
                  value: _bookingNotifications,
                  onChanged: (value) =>
                      setState(() => _bookingNotifications = value),
                ),
              ),
              _SettingsTile(
                icon: Icons.local_offer_outlined,
                title: 'Ưu đãi và khuyến mãi',
                trailing: Switch(
                  value: _promotionNotifications,
                  onChanged: (value) =>
                      setState(() => _promotionNotifications = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const _SettingsSection(
            title: 'Thông tin',
            children: [
              _SettingsTile(
                icon: Icons.shield_outlined,
                title: 'Quyền riêng tư',
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                title: 'Điều khoản sử dụng',
              ),
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'Phiên bản ứng dụng',
                value: '1.0.0',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(ProfileRadii.large),
            ),
            child: Row(
              children: [
                Icon(Icons.palette_outlined, color: colors.onPrimaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isDarkMode
                        ? 'Đang dùng giao diện tối VietTravel.'
                        : 'Đang dùng giao diện sáng VietTravel.',
                    style: TextStyle(color: colors.onPrimaryContainer),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

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
              letterSpacing: .8,
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

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      minTileHeight: 64,
      leading: Icon(icon, color: colors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
            ),
      trailing:
          trailing ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value != null)
                Text(value!, style: TextStyle(color: colors.onSurfaceVariant)),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
            ],
          ),
    );
  }
}
