import 'package:flutter/material.dart';

class WondrixTheme {
  static const bg = Color(0xFFFBFBFA);
  static const surface = Color(0xFFFFFFFF);
  static const edge = Color(0xFFE8E7E4);
  static const accent = Color(0xFF4F46E5);
  static const accentLight = Color(0xFF818CF8);
  static const ink = Color(0xFF1E1B4B);
  static const muted = Color(0xFF6B7280);
  static const success = Color(0xFF16A34A);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      fontFamily: 'AppFont',
      primaryColor: accent,
      colorScheme: const ColorScheme.light(
        primary: accent,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: ink,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: edge, width: 1.5),
        ),
      ),
    );
  }
}
