import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../tours/presentation/views/tour_management_screen.dart';
import '../states/auth_state.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/auth_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authViewModelProvider.notifier)
        .loginWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (!mounted) return;
    final authState = ref.read(authViewModelProvider).value;
    if (authState is AuthAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TourManagementScreen()),
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    await ref.read(authViewModelProvider.notifier).loginWithGoogle();
    if (!mounted) return;
    final authState = ref.read(authViewModelProvider).value;
    if (authState is AuthAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TourManagementScreen()),
      );
    }
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
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: AuthLogo()),
                    const SizedBox(height: 14),
                    const Text(
                      'Khám phá Việt Nam',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Vui lòng nhập thông tin để truy cập tài khoản.',
                      style: TextStyle(color: AuthColors.muted),
                    ),
                    const SizedBox(height: 26),
                    AuthTextField(
                      label: 'Email của bạn',
                      hint: 'ten@vidu.com',
                      icon: Icons.mail_outline,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 18),
                    AuthTextField(
                      label: 'Mật khẩu',
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) => validateRequired(value, 'mật khẩu'),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            context.goNamed(RouteNames.forgotPassword),
                        child: const Text('Quên mật khẩu?'),
                      ),
                    ),
                    if (authState is AuthFailure) ...[
                      Text(
                        authState.message,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (authState is AuthCancelled) ...[
                      Text(
                        authState.message,
                        style: const TextStyle(color: AuthColors.muted),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (authState is AuthAuthenticated) ...[
                      Text(
                        'Đăng nhập thành công. Xin chào '
                        '${authState.user.fullName}!',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                    ],
                    AuthPrimaryButton(
                      label: isLoading ? 'Đang đăng nhập...' : 'Đăng nhập',
                      onPressed: isLoading ? null : _login,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: AuthDivider(),
                    ),
                    Row(
                      children: [
                        SocialButton(
                          label: isLoading
                              ? 'Đang kết nối Google...'
                              : 'Google',
                          icon: const GoogleMark(),
                          onPressed: isLoading ? null : _loginWithGoogle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AuthSwitchText(
                      prefix: 'Chưa có tài khoản?',
                      action: 'Đăng ký ngay',
                      onTap: () => context.goNamed(RouteNames.register),
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
