import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFE94F1B);
  static const dark = Color(0xFF351B18);
  static const cream = Color(0xFFF7F7F7);
  static const yellow = Color(0xFFF6CF57);
  static const paleYellow = Color(0xFFF7EAB0);
  static const card = Color(0xFFFFFFFF);
  static const grey = Color(0xFF938783);
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.cream,
      onSurface: AppColors.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.yellow,
      elevation: 0,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: AppColors.primary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.paleYellow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
      ),
      hintStyle: const TextStyle(color: AppColors.grey, fontSize: 13),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.dark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}
