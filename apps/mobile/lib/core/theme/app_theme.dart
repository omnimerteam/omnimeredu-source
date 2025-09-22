import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // --- Light Theme ---
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: "Inter",
    scaffoldBackgroundColor: AppColors.backgroundLight,
    primaryColor: AppColors.primary,
    colorScheme:
        ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.blue,
          background: AppColors.backgroundLight,
          error: AppColors.red,
          onPrimary: AppColors.textLight,
          onSecondary: AppColors.textLight,
          onBackground: AppColors.textDark,
          surface: AppColors.grey100,
          onSurface: AppColors.textDark,
        ).copyWith(
          // thêm semantic colors
          tertiary: AppColors.success,
          surfaceTint: AppColors.grey200,
        ),

    // Input field
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.extraLightBlue,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Text
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

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    // Chips (tags, status, filter options)
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.grey200,
      selectedColor: AppColors.primary.withOpacity(0.2),
      secondarySelectedColor: AppColors.blue.withOpacity(0.2),
      labelStyle: const TextStyle(color: AppColors.textDark),
      secondaryLabelStyle: const TextStyle(color: AppColors.textDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    cardTheme: CardThemeData(
      color: Colors.grey[100], // nền tối cho dark
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
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
      surface: AppColors.grey800,
      onSurface: AppColors.textLight,
    ).copyWith(tertiary: AppColors.success, surfaceTint: AppColors.grey700),

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

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        foregroundColor: AppColors.lightBlue,
        side: const BorderSide(color: AppColors.lightBlue, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightBlue,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.grey700,
      selectedColor: AppColors.primary.withOpacity(0.25),
      secondarySelectedColor: AppColors.lightBlue.withOpacity(0.25),
      labelStyle: const TextStyle(color: AppColors.textLight),
      secondaryLabelStyle: const TextStyle(color: AppColors.textLight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    cardTheme: CardThemeData(
      color: AppColors.grey900,
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}
