import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/profile_model.dart';
import '../view_models/profile_view_model.dart';
import '../widgets/profile_widget.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  static const _maxAvatarBytes = 5 * 1024 * 1024;
  static const _imageTypes = XTypeGroup(
    label: 'Ảnh',
    extensions: ['jpg', 'jpeg', 'png', 'webp'],
    mimeTypes: ['image/jpeg', 'image/png', 'image/webp'],
  );

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _avatarUrl;
  bool _initialized = false;
  bool _isSelectingImage = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_loadProfile);
  }

  Future<void> _loadProfile() async {
    final profile = await ref.read(profileViewModelProvider.future);
    if (!mounted || profile == null) return;
    _applyProfile(profile);
  }

  void _applyProfile(ProfileModel profile) {
    if (_initialized) return;
    setState(() {
      _nameController.text = profile.fullName;
      _emailController.text = profile.email;
      _phoneController.text = profile.phone ?? '';
      _avatarUrl = profile.avatarUrl;
      _initialized = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    setState(() => _isSelectingImage = true);
    try {
      final image = await openFile(acceptedTypeGroups: const [_imageTypes]);
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (bytes.length > _maxAvatarBytes) {
        _showMessage('Ảnh phải nhỏ hơn 5 MB.');
        return;
      }
      final extension = image.name.split('.').last.toLowerCase();
      final mimeType = switch (extension) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        _ => 'image/jpeg',
      };
      if (!mounted) return;
      setState(() {
        _avatarUrl = 'data:$mimeType;base64,${base64Encode(bytes)}';
      });
    } catch (_) {
      _showMessage('Không thể đọc ảnh đã chọn. Vui lòng thử ảnh khác.');
    } finally {
      if (mounted) setState(() => _isSelectingImage = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) return;
    setState(() => _isSubmitting = true);
    final success = await ref
        .read(profileViewModelProvider.notifier)
        .updateProfile(
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          avatarUrl: _avatarUrl,
        );
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (success) {
      _showMessage('Đã cập nhật hồ sơ.');
      Navigator.of(context).pop();
      return;
    }
    final error = ref.read(profileViewModelProvider).error;
    _showMessage(error?.toString() ?? 'Không thể cập nhật hồ sơ.');
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final profileState = ref.watch(profileViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa hồ sơ'), centerTitle: true),
      body: !_initialized && profileState.isLoading
          ? const ProfileSkeleton()
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  children: [
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ProfileAvatar(
                            fullName: _nameController.text,
                            avatarUrl: _avatarUrl,
                          ),
                          Positioned(
                            right: -2,
                            bottom: 0,
                            child: IconButton.filled(
                              tooltip: 'Đổi ảnh đại diện',
                              onPressed: _isSelectingImage ? null : _pickAvatar,
                              icon: _isSelectingImage
                                  ? const SizedBox.square(
                                      dimension: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 19,
                                    ),
                              style: IconButton.styleFrom(
                                backgroundColor: colors.primary,
                                foregroundColor: colors.onPrimary,
                                side: BorderSide(
                                  color: colors.surface,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _isSelectingImage ? null : _pickAvatar,
                      child: const Text('Chọn ảnh mới'),
                    ),
                    const SizedBox(height: 22),
                    _ProfileField(
                      controller: _nameController,
                      label: 'Họ và tên',
                      icon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        final name = value?.trim() ?? '';
                        if (name.isEmpty) return 'Vui lòng nhập họ và tên';
                        if (name.length < 2) return 'Họ và tên quá ngắn';
                        return null;
                      },
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
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _saveProfile(),
                      validator: (value) {
                        final phone = value?.trim() ?? '';
                        if (phone.isEmpty) return null;
                        if (!RegExp(r'^(?:\+84|0)\d{9}$').hasMatch(phone)) {
                          return 'Số điện thoại không hợp lệ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    FilledButton(
                      onPressed: _isSubmitting ? null : _saveProfile,
                      child: _isSubmitting
                          ? const SizedBox.square(
                              dimension: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text('Lưu thay đổi'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool readOnly;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    validator: validator,
    onChanged: onChanged,
    onFieldSubmitted: onFieldSubmitted,
    readOnly: readOnly,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      fillColor: readOnly
          ? Theme.of(context).colorScheme.surfaceContainerHighest
          : Theme.of(context).colorScheme.surface,
    ),
  );
}
