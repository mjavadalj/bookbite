import 'package:flutter/material.dart';

abstract final class BookBiteTokens {
  static const canvas = Color(0xFFF3EFE6);
  static const surface = Color(0xFFFBF8F1);
  static const softSurface = Color(0xFFF7F2E8);
  static const foreground = Color(0xFF293128);
  static const secondaryText = Color(0xFF6E7268);
  static const border = Color(0xFFDDD5C8);
  static const primary = Color(0xFF566A4A);
  static const atmosphericSage = Color(0xFF8FA07C);
  static const selectedSurface = Color(0xFFE4E7DE);
  static const navigationIcon = secondaryText;
  static const shelfWood = Color(0xFFE8D6B6);
  static const shelfEdge = Color(0xFFCDB792);
  static const shelfBoard = Color(0xFFB58E5C);
  static const shelfShadowSoft = Color(0x1F5B4328);
  static const shelfShadowStrong = Color(0x3D5B4328);
  static const bookSpinePalette = <Color>[
    Color(0xFF6B795D),
    Color(0xFFD8CDB7),
    Color(0xFF879273),
    Color(0xFFC7B998),
    primary,
    Color(0xFFE2D9C6),
  ];
  static const activityLow = Color(0xFFC8D2BE);
  static const activityMedium = Color(0xFF98AA89);
  static const activityHigh = Color(0xFF6F865F);

  static const space1 = 8.0;
  static const space2 = 16.0;
  static const space3 = 24.0;
  static const controlRadius = 16.0;
  static const surfaceRadius = 24.0;
  static const minimumTapTarget = Size(48, 48);
  static const motionDuration = Duration(milliseconds: 180);
}

abstract final class BookBiteTheme {
  static final light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: BookBiteTokens.canvas,
    colorScheme: const ColorScheme.light(
      primary: BookBiteTokens.primary,
      onPrimary: BookBiteTokens.surface,
      secondary: BookBiteTokens.atmosphericSage,
      onSecondary: BookBiteTokens.foreground,
      surface: BookBiteTokens.surface,
      onSurface: BookBiteTokens.foreground,
      outline: BookBiteTokens.border,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: BookBiteTokens.foreground,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      titleLarge: TextStyle(
        color: BookBiteTokens.foreground,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      bodyLarge: TextStyle(
        color: BookBiteTokens.foreground,
        fontSize: 16,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: BookBiteTokens.secondaryText,
        fontSize: 14,
        height: 1.5,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: BookBiteTokens.surface,
      indicatorColor: BookBiteTokens.selectedSurface,
      iconTheme: WidgetStatePropertyAll(
        IconThemeData(color: BookBiteTokens.navigationIcon, size: 26),
      ),
      labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12)),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: BookBiteTokens.minimumTapTarget,
        foregroundColor: BookBiteTokens.primary,
        side: const BorderSide(color: BookBiteTokens.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BookBiteTokens.controlRadius),
        ),
      ),
    ),
  );
}
