import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/glass_button.dart';
import '../../widgets/glass_textfield.dart';

import '../../widgets/app_logo.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),

                // App branding
                const Center(
                  child: AppLogo(size: 80),
                ),

                SizedBox(height: 32.h),

                // Title
                Center(
                  child: Text(
                    'Welcome Back',
                    style: AppTextStyles.headlineLg,
                  ),
                ),
                SizedBox(height: 8.h),
                Center(
                  child: Text(
                    'Sign in to continue your fitness journey',
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
                  ),
                ),

                SizedBox(height: 48.h),

                // Email field
                GlassTextField(
                  hintText: 'Email Address',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: controller.validateEmail,
                ),

                SizedBox(height: 16.h),

                // Password field
                Obx(() => GlassTextField(
                      hintText: 'Password',
                      controller: controller.passwordController,
                      isObscure: !controller.isPasswordVisible.value,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: controller.validatePassword,
                      suffixIcon: GestureDetector(
                        onTap: controller.togglePasswordVisibility,
                        child: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                          size: 22,
                        ),
                      ),
                    )),

                SizedBox(height: 12.h),

                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Sign In button
                Obx(() => GlassButton(
                      text: 'Sign In',
                      onPressed: controller.login,
                      isGradient: true,
                      isLoading: controller.isLoading.value,
                    )),

                SizedBox(height: 24.h),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.borderLight,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'OR',
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.borderLight,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Google sign-in (visual placeholder)
                ClipRRect(
                  borderRadius: BorderRadius.circular(27.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: double.infinity,
                      height: 54.h,
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(27.r),
                        border: Border.all(color: AppColors.borderLight, width: 1),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(27.r),
                          onTap: () {
                            Get.snackbar('Coming Soon', 'Google Sign-In will be available soon.',
                                snackPosition: SnackPosition.BOTTOM);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.g_mobiledata_rounded,
                                  color: Colors.white, size: 28.sp),
                              SizedBox(width: 8.w),
                              Text(
                                'Continue with Google',
                                style: AppTextStyles.bodyLg.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Register link
                Center(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.register),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
