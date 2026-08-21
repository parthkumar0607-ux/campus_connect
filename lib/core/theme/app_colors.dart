import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  // New Midnight Navy + Indigo + Electric Blue + Cyan palette
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color blue = Color(0xFF3B82F6); // Electric Blue
  static const Color cyan = Color(0xFF22D3EE); // Cyan
  static const Color accentPink = Color(0xFFEC5DC8); // kept for rare use

  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color online = Color(0xFF34D399);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Legacy token aliases used across the app
  static const Color secondary = Color(0xFF94A3B8);
  static const Color divider = Color(0xFF263247);
  static const Color accentCyan = cyan;

  static const Color background = Color(0xFF070A12);
  static const Color surface = Color(0xFF101625);
  static const Color surfaceElevated = Color(0xFF161E30);
  static const Color surfaceSoft = Color(0xFF1B2636);
  static const Color surfaceGlass = Color(0xFF10141A);

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF748394);
  static const Color border = Color(0xFF263247);
  static const Color glow = Color(0x223B82F6);
}
