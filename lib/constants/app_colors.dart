import 'package:flutter/material.dart';

class AppColors {
  // Brand Backgrounds
  static const Color background = Color(0xFF0B0B0B); // Void Black
  static const Color surface = Color(0xFF1B1B1B);    // Dark Grey (Glass surface)
  static const Color surfaceContainer = Color(0xFF201F1F);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2A);
  
  // Crimson Accents
  static const Color primary = Color(0xFFFF3B30);    // Crimson Red
  static const Color primaryDark = Color(0xFFB3001B); // Deep Red
  static const Color accentRed = Color(0xFF8B0000);   // Dark Accent Red
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE5E2E1);
  static const Color textMuted = Color(0xFFA0A0A0);
  static const Color textDark = Color(0xFF131313);

  // Borders
  static const Color borderLight = Color(0x1AFFFFFF); // white/10
  static const Color borderMuted = Color(0x0DFFFFFF); // white/5
  static const Color outline = Color(0xFFAD8883);

  // Gradients
  static const LinearGradient redGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blackGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
