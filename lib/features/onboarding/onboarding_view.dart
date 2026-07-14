import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/onboarding_controller.dart';
import '../../widgets/glass_button.dart';
import '../../widgets/onboarding_illustration.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: 16.h, right: 20.w),
                child: GestureDetector(
                  onTap: controller.skipToEnd,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.pages.length,
                itemBuilder: (context, index) {
                  final page = controller.pages[index];
                  return _buildPage(
                    icon: controller.getIcon(page['icon']!),
                    color: controller.getColor(page['color']!),
                    title: page['title']!,
                    subtitle: page['subtitle']!,
                  );
                },
              ),
            ),

            // Dot indicators
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: controller.currentPage.value == index ? 28.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        color: controller.currentPage.value == index
                            ? AppColors.primary
                            : AppColors.textMuted.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                )),

            SizedBox(height: 40.h),

            // Next / Get Started button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Obx(() => GlassButton(
                    text: controller.currentPage.value == controller.pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: controller.nextPage,
                    isGradient: true,
                    trailingIcon: Icon(
                      controller.currentPage.value == controller.pages.length - 1
                          ? Icons.arrow_forward_rounded
                          : Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  )),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OnboardingIllustration(icon: icon, color: color),
          SizedBox(height: 48.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineLg.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLg.copyWith(
              color: AppColors.textMuted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
