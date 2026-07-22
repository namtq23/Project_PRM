import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _lightPrimary = Color(0xFF0EA5E9);
  static const _lightBackground = Color(0xFFF8FAFC);
  static const _darkBackground = Color(0xFF020617);
  static const _darkSurface = Color(0xFF0F172A);
  static const _darkSurfaceContainer = Color(0xFF1E293B);
  static const _darkPrimary = Color(0xFF89CEFF);
  static const _darkOnPrimary = Color(0xFF00344F);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: _lightPrimary,
      brightness: Brightness.light,
      primary: _lightPrimary,
      surface: Colors.white,
    );
    return _baseTheme(scheme).copyWith(
      scaffoldBackgroundColor: _lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF0F172A),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE0F2FE),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? const Color(0xFF036B99)
                : const Color(0xFF64748B),
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _darkPrimary,
          brightness: Brightness.dark,
          primary: _darkPrimary,
          onPrimary: _darkOnPrimary,
          surface: _darkSurface,
          onSurface: const Color(0xFFF8FAFF),
          error: const Color(0xFFFF6B75),
        ).copyWith(
          surfaceContainer: _darkSurfaceContainer,
          surfaceContainerHighest: const Color(0xFF334155),
          outline: const Color(0xFF44474B),
          outlineVariant: const Color(0xFF334155),
        );
    return _baseTheme(scheme).copyWith(
      scaffoldBackgroundColor: _darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: Color(0xFFF8FAFF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _darkSurface,
        indicatorColor: _darkSurfaceContainer,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? _darkPrimary
                : const Color(0xFF94A3B8),
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? _darkPrimary
                : const Color(0xFF94A3B8),
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  static ThemeData _baseTheme(ColorScheme scheme) => ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Inter',
    visualDensity: VisualDensity.standard,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(44, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
