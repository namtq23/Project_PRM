import 'package:flutter/material.dart';

import 'booking_currency.dart';

abstract final class BookingDesign {
  static const background = Color(0xFF020617);
  static const surface = Color(0xFF0F172A);
  static const surfaceContainer = Color(0xFF1E293B);
  static const surfaceHigh = Color(0xFF334155);
  static const primary = Color(0xFF89CEFF);
  static const onPrimary = Color(0xFF00344F);
  static const text = Color(0xFFF8FAFF);
  static const mutedText = Color(0xFFC4C7CC);
  static const subtleText = Color(0xFF94A3B8);
  static const outline = Color(0xFF44474B);
  static const success = Color(0xFF4ADE80);
  static const danger = Color(0xFFFF6B75);
  static const warning = Color(0xFFFFB86E);

  static const pagePadding = EdgeInsets.symmetric(horizontal: 16);

  static InputDecoration fieldDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: subtleText),
      filled: true,
      fillColor: const Color(0xFF20272B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: danger, width: 1.5),
      ),
    );
  }
}

class BookingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookingAppBar({
    super.key,
    required this.title,
    this.bottom,
    this.actions,
  });

  final String title;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  @override
  Size get preferredSize =>
      Size.fromHeight(64 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: BookingDesign.surface,
      foregroundColor: BookingDesign.text,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 64,
      iconTheme: const IconThemeData(color: BookingDesign.primary),
      title: Text(
        title,
        style: const TextStyle(
          color: BookingDesign.text,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}

class BookingSectionCard extends StatelessWidget {
  const BookingSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: BookingDesign.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? BookingDesign.outline.withValues(alpha: 0.55),
        ),
      ),
      child: child,
    );
  }
}

class BookingSectionTitle extends StatelessWidget {
  const BookingSectionTitle({
    super.key,
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: BookingDesign.primary, size: 23),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: BookingDesign.text,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class BookingPrimaryButton extends StatelessWidget {
  const BookingPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: BookingDesign.primary,
          foregroundColor: BookingDesign.onPrimary,
          disabledBackgroundColor: BookingDesign.surfaceHigh,
          disabledForegroundColor: BookingDesign.subtleText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        child: isLoading
            ? const SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: BookingDesign.primary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(icon, size: 22),
                ],
              ),
      ),
    );
  }
}

class BookingBottomBar extends StatelessWidget {
  const BookingBottomBar({
    super.key,
    required this.total,
    required this.buttonLabel,
    required this.onPressed,
    this.isLoading = false,
  });

  final num total;
  final String buttonLabel;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BookingDesign.surface,
        border: Border(
          top: BorderSide(color: BookingDesign.outline.withValues(alpha: 0.5)),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalView = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tổng cộng',
                  style: TextStyle(
                    color: BookingDesign.mutedText,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatBookingCurrency(total),
                  maxLines: 1,
                  style: const TextStyle(
                    color: BookingDesign.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            );
            final button = BookingPrimaryButton(
              label: buttonLabel,
              onPressed: onPressed,
              isLoading: isLoading,
            );

            if (constraints.maxWidth < 340) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [totalView, const SizedBox(height: 10), button],
              );
            }

            return Row(
              children: [
                Expanded(child: totalView),
                const SizedBox(width: 12),
                SizedBox(width: 170, child: button),
              ],
            );
          },
        ),
      ),
    );
  }
}

String bookingTourTitle(int tourId) => switch (tourId) {
  1 => 'Trải nghiệm nghỉ dưỡng 5 sao Sunset Sanato',
  2 => 'Khám phá Cầu Vàng Bà Nà Hills & Phố cổ Hội An',
  3 => 'Mùa lúa chín Mù Cang Chải - Kỳ quan ruộng bậc thang',
  _ => 'Hành trình khám phá Việt Nam',
};

String bookingTourLocation(int tourId) => switch (tourId) {
  1 => 'Phú Quốc, Kiên Giang',
  2 => 'Đà Nẵng, Việt Nam',
  3 => 'Mù Cang Chải, Yên Bái',
  _ => 'Việt Nam',
};

String bookingTourImage(int tourId) => switch (tourId) {
  1 => 'assets/images/tours/phu_quoc.jpg',
  2 => 'assets/images/tours/da_nang.jpg',
  3 => 'assets/images/tours/mu_cang_chai.jpg',
  _ => 'assets/images/tours/home_hero.jpg',
};
