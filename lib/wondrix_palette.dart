import 'package:flutter/material.dart';

class WondrixPalette {
  static const Color slateBg = Color(0xFF181B20);
  static const Color cardSurface = Color(0xFF23272F);
  static const Color accentIndigo = Color(0xFF6366F1);
  static const Color textLight = Color(0xFFF3F4F6);
  static const Color borderGray = Color(0xFF374151);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'AppFont',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: slateBg,
      colorScheme: const ColorScheme.dark(
        primary: accentIndigo,
        surface: cardSurface,
        onSurface: textLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: slateBg,
        foregroundColor: textLight,
        elevation: 0,
      ),
    );
  }
}
