import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/glass_button.dart';
import '../../widgets/glass_textfield.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

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
            key: controller.forgotPasswordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // Lock icon
                Center(
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface.withValues(alpha: 0.6),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.lock_reset_rounded,
                      size: 36.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Title
                Center(
                  child: Text(
                    'Reset Password',
                    style: AppTextStyles.headlineLg,
                  ),
                ),
                SizedBox(height: 12.h),
                Center(
                  child: Text(
                    'Enter the email associated with your account\nand we\'ll send a reset link.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                // Email field
                GlassTextField(
                  hintText: 'Email Address',
                  controller: controller.resetEmailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: controller.validateEmail,
                ),

                SizedBox(height: 32.h),

                // Send Reset Link button
                Obx(() => GlassButton(
                      text: 'Send Reset Link',
                      onPressed: controller.forgotPassword,
                      isGradient: true,
                      isLoading: controller.isLoading.value,
                    )),

                SizedBox(height: 24.h),

                // Back to login link
                Center(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      'Back to Sign In',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
