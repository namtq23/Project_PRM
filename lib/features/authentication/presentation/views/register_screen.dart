import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../states/auth_state.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/auth_widget.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateFullName(String? value) {
    final error = validateRequired(value, 'họ và tên');
    if (error != null) return error;
    return value!.trim().length < 2
        ? 'Họ và tên phải có ít nhất 2 ký tự.'
        : null;
  }

  String? _validatePassword(String? value) {
    final error = validateRequired(value, 'mật khẩu');
    if (error != null) return error;
    return value!.length < 8 ? 'Mật khẩu phải có ít nhất 8 ký tự.' : null;
  }

  String? _validateConfirmPassword(String? value) {
    final error = validateRequired(value, 'xác nhận mật khẩu');
    if (error != null) return error;
    return value != _passwordController.text
        ? 'Mật khẩu xác nhận không khớp.'
        : null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authViewModelProvider.notifier)
        .registerLocal(
          fullName: _fullNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider).value;
    final isLoading = authState is AuthLoading;
    return Scaffold(
      backgroundColor: AuthColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 540),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: AuthLogo(size: 48, icon: Icons.flight_takeoff),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Tạo tài khoản mới',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AuthTextField(
                      controller: _fullNameController,
                      label: 'Họ và tên',
                      hint: 'Nguyễn Văn A',
                      icon: Icons.person_outline,
                      validator: _validateFullName,
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'example@gmail.com',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Mật khẩu',
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _confirmPasswordController,
                      label: 'Xác nhận mật khẩu',
                      hint: '••••••••',
                      icon: Icons.lock_reset_outlined,
                      obscureText: true,
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 20),
                    if (authState is AuthFailure) ...[
                      Text(
                        authState.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (authState is AuthRegistrationSuccess) ...[
                      Text(
                        'Tạo tài khoản thành công cho '
                        '${authState.user.fullName}.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    AuthPrimaryButton(
                      label: isLoading ? 'Đang đăng ký...' : 'Đăng ký',
                      icon: Icons.arrow_forward,
                      onPressed: isLoading ? null : _register,
                    ),
                    const SizedBox(height: 22),
                    AuthSwitchText(
                      prefix: 'Bạn đã có tài khoản?',
                      action: 'Đăng nhập ngay',
                      onTap: () => context.goNamed(RouteNames.login),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
