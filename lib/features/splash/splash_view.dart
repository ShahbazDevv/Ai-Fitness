import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/splash_controller.dart';
import '../../widgets/app_logo.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = controller;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -100.h * (2 - value),
                    left: -100.w * (2 - value),
                    child: Container(
                      width: 300.w,
                      height: 300.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.15 * value),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50.h * (2 - value),
                    right: -50.w * (2 - value),
                    child: Container(
                      width: 250.w,
                      height: 250.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.1 * value),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(size: 120),
                SizedBox(height: 32.h),
                Text(
                  'AI FITNESS',
                  style: AppTextStyles.headlineLg.copyWith(
                    letterSpacing: 8,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'EVOLVE YOUR PHYSIQUE',
                  style: AppTextStyles.labelCaps.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 2,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 60.h),
                SizedBox(
                  width: 40.w,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
