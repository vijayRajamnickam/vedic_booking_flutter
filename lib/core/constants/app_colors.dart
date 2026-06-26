import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary purple palette (from splash/header gradient)
  static const Color primaryDark = Color(0xFF2D0050);
  static const Color primary = Color(0xFF4A0080);
  static const Color primaryMedium = Color(0xFF6A1B9A);
  static const Color primaryLight = Color(0xFF9C27B0);
  static const Color primarySurface = Color(0xFFF3E5F5);

  // Gold / amber accent
  static const Color gold = Color(0xFFE8A020);
  static const Color goldLight = Color(0xFFF5C842);
  static const Color buttonGradientStart = Color(0xFFF5A623);
  static const Color buttonGradientEnd = Color(0xFFE87020);

  // Status colours
  static const Color pending = Color(0xFFF59E0B);
  static const Color pendingSurface = Color(0xFFFFF8E1);
  static const Color confirmed = Color(0xFF10B981);
  static const Color confirmedSurface = Color(0xFFE8F5E9);
  static const Color completed = Color(0xFF6366F1);
  static const Color completedSurface = Color(0xFFEDE9FE);
  static const Color cancelled = Color(0xFFEF4444);
  static const Color cancelledSurface = Color(0xFFFFEBEE);

  // Stats card backgrounds
  static const Color cardPurple = Color(0xFF7C3AED);
  static const Color cardAmber = Color(0xFFF59E0B);
  static const Color cardGreen = Color(0xFF10B981);
  static const Color cardRed = Color(0xFFEF4444);

  // Neutral / surface
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F7FE);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE8E8F0);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFADB5BD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Dark theme surfaces
  static const Color darkBackground = Color(0xFF0F0020);
  static const Color darkSurface = Color(0xFF1A0035);
  static const Color darkCard = Color(0xFF250045);
  static const Color darkDivider = Color(0xFF3D1066);
  static const Color darkTextPrimary = Color(0xFFF5F3FF);
  static const Color darkTextSecondary = Color(0xFFBBAFD4);

  // Gradient list
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, primary],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D0050), Color(0xFF6B21A8)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [buttonGradientStart, buttonGradientEnd],
  );
}
