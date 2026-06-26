import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.gold,
        onSecondary: AppColors.white,
        surface: AppColors.surfaceCard,
        onSurface: AppColors.textPrimary,
        error: AppColors.cancelled,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: const TextTheme(
        displayLarge:   TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
        displayMedium:  TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
        displaySmall:   TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
        headlineLarge:  TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
        headlineMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
        headlineSmall:  TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
        titleLarge:     TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
        titleMedium:    TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
        titleSmall:     TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
        bodyLarge:      TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
        bodyMedium:     TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary),
        bodySmall:      TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary),
        labelLarge:     TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
        labelMedium:    TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary),
        labelSmall:     TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.textHint,
          fontSize: 14,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
        side: const BorderSide(color: AppColors.divider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.white,
        secondary: AppColors.gold,
        onSecondary: AppColors.white,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkTextPrimary,
        error: AppColors.cancelled,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: const TextTheme(
        displayLarge:   TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
        displayMedium:  TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
        displaySmall:   TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
        headlineLarge:  TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
        headlineMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
        headlineSmall:  TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
        titleLarge:     TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
        titleMedium:    TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
        titleSmall:     TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
        bodyLarge:      TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
        bodyMedium:     TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextSecondary),
        bodySmall:      TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextSecondary),
        labelLarge:     TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
        labelMedium:    TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextSecondary),
        labelSmall:     TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.darkTextSecondary,
          fontSize: 14,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkCard,
        selectedColor: AppColors.primaryLight,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: AppColors.darkTextPrimary,
        ),
        side: const BorderSide(color: AppColors.darkDivider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
