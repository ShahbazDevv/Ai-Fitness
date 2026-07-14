import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_button.dart';
import '../../controllers/profile_controller.dart';

class PremiumView extends StatelessWidget {
  const PremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        Icon(Icons.workspace_premium_rounded, size: 80.sp, color: AppColors.primary),
                        SizedBox(height: 24.h),
                        Text('Upgrade to PRO', style: AppTextStyles.headlineLg),
                        SizedBox(height: 8.h),
                        Text(
                          'Unlock the full power of AI for your fitness transformation.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLg.copyWith(color: AppColors.textMuted),
                        ),
                        SizedBox(height: 40.h),
                        _buildFeature('Unlimited AI Body Scans', 'Get deep insights into your physique any time.'),
                        _buildFeature('Personalized AI Coach', '24/7 access to your intelligent fitness partner.'),
                        _buildFeature('Advanced Progress Analytics', 'Detailed charts and predictive health tracking.'),
                        _buildFeature('Custom Diet & Workout Plans', 'AI-generated plans tailored to your specific goals.'),
                        SizedBox(height: 48.h),
                        _buildPricingCard(),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
                _buildBottomActions(profileController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          const Spacer(),
          Text('GO PREMIUM', style: AppTextStyles.labelCaps.copyWith(color: AppColors.primary)),
          const Spacer(),
          SizedBox(width: 48.w),
        ],
      ),
    );
  }

  Widget _buildFeature(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: Icon(Icons.check, color: Colors.white, size: 14.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold)),
                Text(subtitle, style: AppTextStyles.bodySm),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
    return GlassCard(
      padding: EdgeInsets.all(24.w),
      border: Border.all(color: AppColors.primary, width: 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Annual Plan', style: AppTextStyles.titleMd),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12.r)),
                child: Text('SAVE 50%', style: AppTextStyles.labelCaps.copyWith(fontSize: 10.sp)),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('\$99.99', style: AppTextStyles.displayLg.copyWith(fontSize: 40.sp)),
              Text('/year', style: AppTextStyles.bodyLg),
            ],
          ),
          SizedBox(height: 8.h),
          Text('Only \$8.33 per month, billed annually.', style: AppTextStyles.bodySm),
        ],
      ),
    );
  }

  Widget _buildBottomActions(ProfileController controller) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GlassButton(
            text: 'Subscribe Now',
            onPressed: () async {
              await controller.togglePremium(true);
              Get.back();
              Get.snackbar('Success', 'Premium unlocked! Enjoy your new features.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green.withValues(alpha: 0.7),
                  colorText: Colors.white);
            },
            isGradient: true,
          ),
          SizedBox(height: 16.h),
          Text(
            'Restore Purchase • Terms of Service',
            style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
