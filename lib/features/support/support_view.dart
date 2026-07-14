import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_textfield.dart';
import '../../widgets/glass_button.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Help & Support')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How can we help you?', style: AppTextStyles.headlineLgMobile),
            SizedBox(height: 24.h),
            _buildContactMethod(
              'Email Support',
              'support@aifitness.com',
              Icons.email_outlined,
              () {},
            ),
            SizedBox(height: 16.h),
            _buildContactMethod(
              'Live Chat',
              'Chat with AI Assistant',
              Icons.chat_bubble_outline_rounded,
              () => Get.toNamed('/ai-coach-chat'),
            ),
            SizedBox(height: 32.h),
            Text('Send us a message', style: AppTextStyles.titleMd),
            SizedBox(height: 16.h),
            const GlassTextField(hintText: 'Subject', prefixIcon: Icons.subject_rounded),
            SizedBox(height: 16.h),
            const GlassTextField(hintText: 'Your Message', maxLines: 5),
            SizedBox(height: 24.h),
            GlassButton(
              text: 'Send Feedback',
              onPressed: () => Get.snackbar('Success', 'Message sent successfully'),
              isGradient: true,
            ),
            SizedBox(height: 40.h),
            Text('Frequently Asked Questions', style: AppTextStyles.titleMd),
            SizedBox(height: 16.h),
            _buildFaqTile('How does AI Body Scan work?', 'It uses computer vision to analyze your physique from three angles.'),
            _buildFaqTile('Is my data private?', 'Yes, all your photos and health data are encrypted and stored securely.'),
            _buildFaqTile('Can I cancel my premium?', 'You can manage and cancel your subscription anytime in Settings.'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactMethod(String title, String value, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primary, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodySm),
                Text(value, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 14.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
      childrenPadding: EdgeInsets.all(16.w),
      children: [
        Text(answer, style: AppTextStyles.bodySm),
      ],
    );
  }
}
