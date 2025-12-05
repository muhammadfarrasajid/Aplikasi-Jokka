import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Roboto', // ganti kalau pakai font lain
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFCC0000), // pakai salah satu merah Jokka
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: false,
      ),
    );
  }
}
