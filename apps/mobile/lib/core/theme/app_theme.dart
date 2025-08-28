import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // --- Light Theme ---
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: "Inter", // body text mặc định
    scaffoldBackgroundColor: AppColors.backgroundLight,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.blue,
      background: AppColors.backgroundLight,
      error: AppColors.red,
      onPrimary: AppColors.backgroundLight,
      onSecondary: AppColors.backgroundLight,
      onBackground: AppColors.textDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.extraLightBlue,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: 16,
        fontFamily: "Inter",
        color: AppColors.textDark,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontFamily: "Nunito",
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        fontFamily: "PlayfairDisplay",
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      buttonColor: AppColors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // --- Dark Theme ---
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Inter",
    scaffoldBackgroundColor: AppColors.backgroundDark,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.lightBlue,
      background: AppColors.backgroundDark,
      error: AppColors.darkRed,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onBackground: AppColors.textLight,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.blue.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: 16,
        fontFamily: "Inter",
        color: AppColors.textLight,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontFamily: "Nunito",
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        fontFamily: "PlayfairDisplay",
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      buttonColor: AppColors.lightBlue,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
