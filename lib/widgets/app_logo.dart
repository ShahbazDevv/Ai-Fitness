import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AppLogo({
    super.key,
    this.size = 100,
    this.showText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size.w,
          height: size.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.redGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: (size * 0.6).w,
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(height: 16.h),
          Text(
            'AI FITNESS',
            style: TextStyle(
              color: Colors.white,
              fontSize: (size * 0.2).sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
        ],
      ],
    );
  }
}
