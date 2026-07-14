import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Privacy Matters', style: AppTextStyles.headlineLgMobile),
            SizedBox(height: 16.h),
            _buildTextSection(
              'Information We Collect',
              'We collect information you provide directly to us, including your health profile, photos for body analysis, and chat history with the AI Coach.',
            ),
            _buildTextSection(
              'How We Use Information',
              'We use the information to provide personalized fitness recommendations, analyze your progress, and improve our AI models.',
            ),
            _buildTextSection(
              'Data Security',
              'We implement a variety of security measures to maintain the safety of your personal information. Your photos are processed securely and are never shared with third parties without your consent.',
            ),
            _buildTextSection(
              'Your Rights',
              'You have the right to access, update, or delete your personal data at any time through the application settings.',
            ),
            SizedBox(height: 40.h),
            Text('Last Updated: July 2026', style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleMd.copyWith(fontSize: 18.sp, color: AppColors.primary)),
          SizedBox(height: 12.h),
          Text(
            content,
            style: AppTextStyles.bodyLg.copyWith(height: 1.6, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
