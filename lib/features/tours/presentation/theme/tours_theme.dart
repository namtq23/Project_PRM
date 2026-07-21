import 'package:flutter/material.dart';

abstract final class ToursTheme {
  // Brand colors from DESIGN.md
  static const primary = Color(0xFF0EA5E9); // Primary Sky Blue
  static const secondary = Color(0xFF14B8A6); // Secondary Teal
  static const accent = Color(0xFFF59E0B); // Accent Amber
  static const success = Color(0xFF22C55E); // Success Green
  static const warning = Color(0xFFF59E0B); // Warning Amber
  static const danger = Color(0xFFEF4444); // Danger Red

  // Dark Mode colors from Stitch markup
  static const background = Color(0xFF0C1324);
  static const surface = Color(0xFF0C1324);
  static const surfaceContainer = Color(0xFF191F31);
  static const surfaceContainerLow = Color(0xFF151B2D);
  static const surfaceContainerHigh = Color(0xFF23293C);
  static const surfaceContainerHighest = Color(0xFF2E3447);

  static const onSurface = Color(0xFFDCE1FB);
  static const onSurfaceVariant = Color(0xFFBDC8D1);
  static const outline = Color(0xFF87929A);
  static const outlineVariant = Color(0xFF3E484F);

  static const secondaryContainer = Color(0xFF3F465C);
  static const onSecondaryContainer = Color(0xFFADB4CE);

  // Border radiuses
  static const radiusDefault = 4.0;
  static const radiusLg = 8.0;
  static const radiusXl = 12.0;
  static const radiusFull = 999.0;

  // Spacings
  static const gutter = 24.0;
  static const stackLg = 32.0;
  static const marginMobile = 20.0;
  static const marginDesktop = 64.0;
  static const containerMax = 1280.0;
  static const stackSm = 8.0;
  static const stackMd = 16.0;

  // Typography helpers
  static const fontInter = 'Inter';

  static const textDisplay = TextStyle(
    fontFamily: fontInter,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: onSurface,
  );

  static const textHeadline = TextStyle(
    fontFamily: fontInter,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: onSurface,
  );

  static const textBodyMd = TextStyle(
    fontFamily: fontInter,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: onSurface,
  );

  static const textBodySm = TextStyle(
    fontFamily: fontInter,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: onSurfaceVariant,
  );

  static const textLabel = TextStyle(
    fontFamily: fontInter,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
    color: onSurface,
  );
}
