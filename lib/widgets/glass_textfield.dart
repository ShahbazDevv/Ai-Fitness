import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class GlassTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObscure;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final int maxLines;

  const GlassTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      style: AppTextStyles.bodyLg.copyWith(color: AppColors.textPrimary),
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.textMuted, size: 20.sp)
            : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
