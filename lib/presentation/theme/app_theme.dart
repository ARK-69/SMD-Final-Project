import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const navy = Color(0xFF071226);
  static const purple = Color(0xFF6C3BFF);
  static const pink = Color(0xFFFF6688);
  static const green = Color(0xFF22C55E);
  static const yellow = Color(0xFFF59E0B);
  static const surface = Color(0xFFF8FAFC);
}

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return _base(Brightness.light).copyWith(
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purple,
        primary: AppColors.purple,
        secondary: AppColors.pink,
      ),
    );
  }

  static ThemeData dark() {
    return _base(Brightness.dark).copyWith(
      scaffoldBackgroundColor: AppColors.navy,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: AppColors.purple,
        primary: AppColors.purple,
        secondary: AppColors.pink,
      ),
    );
  }

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF111C30) : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      chipTheme: ChipThemeData(
        selectedColor: AppColors.purple,
        backgroundColor: isDark ? const Color(0xFF17243A) : Colors.white,
        labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black87),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF111C30) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey.shade500),
      ),
    );
  }
}
