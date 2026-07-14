import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_images.dart';
import '../../widgets/custom_image.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('About AI Fitness')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Container(
              width: 120.w,
              height: 120.w,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const CustomImage(imageUrl: AppImages.logo, fit: BoxFit.contain),
            ),
            SizedBox(height: 24.h),
            Text('AI Fitness', style: AppTextStyles.headlineLg),
            Text('Version 1.0.0', style: AppTextStyles.bodySm),
            SizedBox(height: 40.h),
            Text(
              'AI Fitness is your intelligent partner in achieving peak physical condition. Our mission is to democratize high-end personal training and nutrition through the power of Artificial Intelligence.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLg.copyWith(height: 1.6),
            ),
            SizedBox(height: 32.h),
            _buildInfoRow('Developed By', 'Shahbaz'),
            _buildInfoRow('Website', 'www.aifitness.com'),
            _buildInfoRow('Support', 'support@aifitness.com'),
            SizedBox(height: 48.h),
            Text(
              '© 2026 AI Fitness. All rights reserved.',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySm),
          Text(value, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
