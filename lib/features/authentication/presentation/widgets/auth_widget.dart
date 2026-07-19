import 'package:flutter/material.dart';

abstract final class AuthColors {
  static const primary = Color(0xFF0EA5E9);
  static const primaryDark = Color(0xFF036B99);
  static const background = Color(0xFFF8FAFC);
  static const text = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFCBD5E1);
}

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key, this.size = 56, this.icon = Icons.travel_explore});

  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(size * .24),
      boxShadow: const [
        BoxShadow(
          color: Color(0x220F172A),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Icon(icon, color: AuthColors.primaryDark, size: size * .5),
  );
}

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    required this.label,
    required this.hint,
    required this.icon,
    super.key,
    this.controller,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool obscureText;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscured = widget.obscureText;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    keyboardType: widget.keyboardType,
    obscureText: _obscured,
    validator: widget.validator,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      labelText: widget.label,
      hintText: widget.hint,
      prefixIcon: Icon(widget.icon, size: 20),
      suffixIcon: widget.obscureText
          ? IconButton(
              tooltip: _obscured ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
              onPressed: () => setState(() => _obscured = !_obscured),
              icon: Icon(
                _obscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            )
          : null,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AuthColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AuthColors.primary, width: 1.5),
      ),
    ),
  );
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 52,
    child: FilledButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: AuthColors.primaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(child: Divider()),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          'Hoặc tiếp tục với',
          style: TextStyle(color: AuthColors.muted, fontSize: 12),
        ),
      ),
      Expanded(child: Divider()),
    ],
  );
}

class SocialButton extends StatelessWidget {
  const SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Expanded(
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AuthColors.text,
        padding: const EdgeInsets.symmetric(vertical: 13),
        side: const BorderSide(color: AuthColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

String? validateRequired(String? value, String field) {
  if (value == null || value.trim().isEmpty) return 'Vui lòng nhập $field.';
  return null;
}

String? validateEmail(String? value) {
  final requiredError = validateRequired(value, 'email');
  if (requiredError != null) return requiredError;
  final valid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value!.trim());
  return valid ? null : 'Email không hợp lệ. Vui lòng kiểm tra lại.';
}

class AuthSwitchText extends StatelessWidget {
  const AuthSwitchText({
    required this.prefix,
    required this.action,
    required this.onTap,
    super.key,
  });
  final String prefix;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '$prefix ',
        style: const TextStyle(color: AuthColors.muted, fontSize: 13),
      ),
      TextButton(onPressed: onTap, child: Text(action)),
    ],
  );
}

class GoogleMark extends StatelessWidget {
  const GoogleMark({super.key});
  @override
  Widget build(BuildContext context) => const Text(
    'G',
    style: TextStyle(
      color: Color(0xFF4285F4),
      fontWeight: FontWeight.w800,
      fontSize: 17,
    ),
  );
}
