import 'package:flutter/material.dart';

class ThemeGestauto {
  static const Color bleuCobalt = Color(0xFF2457D6);
  static const Color bleuFonce = Color(0xFF163A8A);
  static const Color bleuClair = Color(0xFFEAF0FF);

  static ThemeData obtenir() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: bleuCobalt,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      appBarTheme: const AppBarTheme(
        backgroundColor: bleuCobalt,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: bleuCobalt,
          foregroundColor: Colors.white,
          minimumSize: const Size(
            double.infinity,
            48,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  static ThemeData obtenirSombre() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: bleuCobalt,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF10141C),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF172033),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF1B2330),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: bleuCobalt,
          foregroundColor: Colors.white,
          minimumSize: const Size(
            double.infinity,
            48,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
