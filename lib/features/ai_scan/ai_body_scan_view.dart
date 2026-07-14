import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/ai_scan_controller.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_button.dart';

class AiBodyScanView extends GetView<AiScanController> {
  const AiBodyScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Body Scan'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vision Analysis',
              style: AppTextStyles.headlineLgMobile,
            ),
            SizedBox(height: 8.h),
            Text(
              'Upload or take three photos of your body to get a detailed AI analysis of your progress.',
              style: AppTextStyles.bodySm,
            ),
            SizedBox(height: 32.h),
            _buildPhotoSelector('front', 'Front View', 'Stand straight facing the camera'),
            SizedBox(height: 16.h),
            _buildPhotoSelector('side', 'Side View', 'Turn 90 degrees to either side'),
            SizedBox(height: 16.h),
            _buildPhotoSelector('back', 'Back View', 'Turn your back to the camera'),
            SizedBox(height: 40.h),
            Obx(() => GlassButton(
                  text: 'Analyze My Physique',
                  onPressed: controller.startAnalysis,
                  isGradient: true,
                  isLoading: controller.isAnalyzing.value,
                  icon: Icons.auto_awesome_rounded,
                )),
            SizedBox(height: 20.h),
            Center(
              child: Text(
                'Your data is processed securely and privately.',
                style: AppTextStyles.bodySm.copyWith(fontSize: 10.sp, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSelector(String position, String title, String subtitle) {
    return Obx(() {
      final imageFile = position == 'front'
          ? controller.frontImage.value
          : position == 'side'
              ? controller.sideImage.value
              : controller.backImage.value;

      return GestureDetector(
        onTap: () => controller.pickImage(position),
        child: GlassCard(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.file(imageFile, fit: BoxFit.cover),
                      )
                    : Icon(Icons.add_a_photo_rounded, color: AppColors.primary, size: 28.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleMd.copyWith(fontSize: 16.sp)),
                    SizedBox(height: 4.h),
                    Text(subtitle, style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp)),
                  ],
                ),
              ),
              if (imageFile != null)
                const Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
            ],
          ),
        ),
      );
    });
  }
}
