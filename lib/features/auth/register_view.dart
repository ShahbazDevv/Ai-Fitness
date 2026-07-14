import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/glass_button.dart';
import '../../widgets/glass_textfield.dart';

import '../../widgets/app_logo.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: controller.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                // App branding
                const Center(
                  child: AppLogo(size: 70),
                ),

                SizedBox(height: 32.h),

                // Title
                Center(
                  child: Text(
                    'Create Account',
                    style: AppTextStyles.headlineLg,
                  ),
                ),
                SizedBox(height: 8.h),
                Center(
                  child: Text(
                    'Start your transformation today',
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
                  ),
                ),

                SizedBox(height: 36.h),

                // Name
                GlassTextField(
                  hintText: 'Full Name',
                  controller: controller.nameController,
                  keyboardType: TextInputType.name,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: controller.validateName,
                ),

                SizedBox(height: 16.h),

                // Email
                GlassTextField(
                  hintText: 'Email Address',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: controller.validateEmail,
                ),

                SizedBox(height: 16.h),

                // Password
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

                SizedBox(height: 16.h),

                // Confirm Password
                Obx(() => GlassTextField(
                      hintText: 'Confirm Password',
                      controller: controller.confirmPasswordController,
                      isObscure: !controller.isConfirmPasswordVisible.value,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: controller.validateConfirmPassword,
                      suffixIcon: GestureDetector(
                        onTap: controller.toggleConfirmPasswordVisibility,
                        child: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                          size: 22,
                        ),
                      ),
                    )),

                SizedBox(height: 12.h),

                // Terms text
                Text(
                  'By signing up, you agree to our Terms of Service and Privacy Policy.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12.sp,
                  ),
                ),

                SizedBox(height: 32.h),

                // Sign Up button
                Obx(() => GlassButton(
                      text: 'Create Account',
                      onPressed: controller.register,
                      isGradient: true,
                      isLoading: controller.isLoading.value,
                    )),

                SizedBox(height: 24.h),

                // Login link
                Center(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
                        children: [
                          TextSpan(
                            text: 'Sign In',
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
