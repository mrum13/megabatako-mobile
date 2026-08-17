import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // private constructor, mencegah instansiasi

  // === Primary Colors ===
  static const Color primary = Color(0xFF1E3A8A);
  static const Color primaryLight = Color(0xFF6C9BF5);
  static const Color primaryDark = Color(0xFF1A4FC4);

  // === Secondary Colors ===
  static const Color secondary = Color(0xFF0D9488);
  static const Color secondaryLight = Color(0xFFFFC069);
  static const Color secondaryDark = Color(0xFFCC7A00);

  // === Neutral / Background ===
  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF8F9FF);
  static const Color cardStatisticsBackground = Color(0xFFDFE9FA);

  // === Text Colors ===
  static const Color textPrimary = Color(0xFF121C28);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // === Border & Divider ===
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE0E0E0);

  // === Status Colors ===
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // === Dark Mode (opsional) ===
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFECECEC);

}