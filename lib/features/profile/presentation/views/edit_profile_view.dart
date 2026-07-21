import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../authentication/presentation/states/auth_state.dart';
import '../../../authentication/presentation/view_models/auth_view_model.dart';
import '../widgets/profile_widget.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(authViewModelProvider).value;
    final user = state is AuthAuthenticated ? state.user : null;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: ProfilePalette.background,
    appBar: AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: const Text('Chỉnh sửa hồ sơ'),
      centerTitle: true,
    ),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    radius: 52,
                    backgroundColor: ProfilePalette.primarySoft,
                    child: Icon(
                      Icons.person_rounded,
                      size: 54,
                      color: ProfilePalette.primaryDark,
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: 0,
                    child: IconButton.filled(
                      tooltip: 'Đổi ảnh đại diện',
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt_outlined, size: 19),
                      style: IconButton.styleFrom(
                        backgroundColor: ProfilePalette.primary,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 34),
            _ProfileField(
              controller: _nameController,
              label: 'Họ và tên',
              icon: Icons.person_outline_rounded,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Vui lòng nhập họ và tên'
                  : null,
            ),
            const SizedBox(height: 18),
            _ProfileField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
            ),
            const SizedBox(height: 18),
            _ProfileField(
              controller: _phoneController,
              label: 'Số điện thoại',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),
            FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Giao diện đã sẵn sàng để kết nối chức năng lưu hồ sơ.',
                      ),
                    ),
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: ProfilePalette.primary,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ProfileRadii.medium),
                ),
              ),
              child: const Text(
                'Lưu thay đổi',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool readOnly;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    validator: validator,
    readOnly: readOnly,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: readOnly ? const Color(0xFFF1F5F9) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ProfileRadii.medium),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ProfileRadii.medium),
        borderSide: const BorderSide(color: ProfilePalette.border),
      ),
    ),
  );
}
