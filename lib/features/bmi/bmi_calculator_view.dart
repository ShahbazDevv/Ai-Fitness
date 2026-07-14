import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/progress_controller.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_textfield.dart';
import '../../widgets/glass_button.dart';

class BmiCalculatorView extends GetView<ProgressController> {
  const BmiCalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultCard(),
            SizedBox(height: 32.h),
            Text('Enter Details', style: AppTextStyles.titleMd),
            SizedBox(height: 16.h),
            GlassTextField(
              hintText: 'Height (cm)',
              controller: controller.heightController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.height_rounded,
              onChanged: (_) => controller.calculateBmi(),
            ),
            SizedBox(height: 16.h),
            GlassTextField(
              hintText: 'Weight (kg)',
              controller: controller.weightController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.monitor_weight_rounded,
              onChanged: (_) => controller.calculateBmi(),
            ),
            SizedBox(height: 40.h),
            GlassButton(
              text: 'Log Current Weight',
              onPressed: controller.saveWeightLog,
              isGradient: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Obx(() {
      final bmi = controller.calculatedBmi.value;
      final status = controller.bmiStatus.value;
      Color statusColor = Colors.greenAccent;
      
      if (status == 'Underweight') statusColor = Colors.orangeAccent;
      if (status == 'Overweight') statusColor = Colors.orangeAccent;
      if (status == 'Obese') statusColor = Colors.redAccent;

      return GlassCard(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Center(
          child: Column(
            children: [
              Text('Your BMI', style: AppTextStyles.bodySm),
              SizedBox(height: 8.h),
              Text(
                bmi.toStringAsFixed(1),
                style: AppTextStyles.displayLg.copyWith(color: AppColors.primary, fontSize: 56.sp),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.labelCaps.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
