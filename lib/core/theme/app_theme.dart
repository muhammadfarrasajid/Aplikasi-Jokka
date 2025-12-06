// File: lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

// Kelas Warna untuk dipakai di HomePage
class JokkaColors {
  static const Color primary = Color(0xFFE53935);
  static const Color background = Color(0xFFF5F5F5);
  static const Color textPrimary = Colors.black;
}

// Style Text untuk dipakai di HomePage
const TextStyle headingStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

// Kelas Tema untuk dipakai di main.dart (FIX Error AppTheme)
class AppTheme {
  static ThemeData get light {
    return ThemeData(
      primaryColor: JokkaColors.primary,
      scaffoldBackgroundColor: JokkaColors.background,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: JokkaColors.primary),
    );
  }
}