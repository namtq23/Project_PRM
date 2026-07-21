import 'package:flutter/material.dart';

import '../widgets/profile_widget.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _bookingNotifications = true;
  bool _promotionNotifications = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: ProfilePalette.background,
    appBar: AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: const Text('Cài đặt'),
      centerTitle: true,
    ),
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
              icon: Icons.dark_mode_outlined,
              title: 'Chế độ tối',
              trailing: Switch(
                value: _darkMode,
                onChanged: (value) => setState(() => _darkMode = value),
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
            _SettingsTile(icon: Icons.shield_outlined, title: 'Quyền riêng tư'),
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
      ],
    ),
  );
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

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
            letterSpacing: .8,
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ProfileRadii.large),
          border: Border.all(color: ProfilePalette.border),
        ),
        child: Column(children: children),
      ),
    ],
  );
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.value,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => ListTile(
    minTileHeight: 64,
    leading: Icon(icon, color: ProfilePalette.primaryDark),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    trailing:
        trailing ??
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value != null)
              Text(value!, style: const TextStyle(color: ProfilePalette.muted)),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              color: ProfilePalette.muted,
            ),
          ],
        ),
  );
}
