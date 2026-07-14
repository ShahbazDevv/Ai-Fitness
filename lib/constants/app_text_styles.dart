import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get displayLg => GoogleFonts.inter(
        fontSize: 48.sp,
        fontWeight: FontWeight.w800,
        height: 56 / 48,
        letterSpacing: -0.02 * 48,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineLg => GoogleFonts.inter(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.01 * 32,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineLgMobile => GoogleFonts.inter(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        height: 34 / 28,
        letterSpacing: -0.01 * 28,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMd => GoogleFonts.inter(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySm => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.textMuted,
      );

  static TextStyle get labelCaps => GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        height: 16 / 12,
        letterSpacing: 0.05 * 12,
        color: AppColors.textPrimary,
      );
}
