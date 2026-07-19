import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../widgets/auth_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AuthColors.background,
    body: SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text('Quay lại'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: AuthLogo(size: 52, icon: Icons.history),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Quên mật khẩu?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Đừng lo lắng, hãy nhập email liên kết với tài khoản của bạn. Chúng tôi sẽ gửi một mã xác nhận để bạn đặt lại mật khẩu mới.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AuthColors.muted, height: 1.5),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x130F172A), blurRadius: 22),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AuthTextField(
                              label: 'Địa chỉ Email',
                              hint: 'ví-dụ@email.com',
                              icon: Icons.mail_outline,
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail,
                            ),
                            const SizedBox(height: 18),
                            AuthPrimaryButton(
                              label: 'Gửi mã xác nhận',
                              onPressed: () =>
                                  _formKey.currentState!.validate(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    AuthSwitchText(
                      prefix: 'Bạn nhớ ra mật khẩu rồi?',
                      action: 'Đăng nhập ngay',
                      onTap: () => context.goNamed(RouteNames.login),
                    ),
                    const SizedBox(height: 38),
                    Row(
                      children: [
                        Expanded(
                          child: _DecorativeTile(
                            icon: Icons.landscape_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DecorativeTile(icon: Icons.explore_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: FloatingActionButton.small(
              onPressed: () {},
              backgroundColor: Colors.white,
              foregroundColor: AuthColors.primaryDark,
              child: const Icon(Icons.contact_support_outlined),
            ),
          ),
        ],
      ),
    ),
  );
}

class _DecorativeTile extends StatelessWidget {
  const _DecorativeTile({required this.icon});
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    height: 82,
    decoration: BoxDecoration(
      color: const Color(0xFFE2E8F0),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Icon(icon, size: 38, color: const Color(0xFF94A3B8)),
  );
}
