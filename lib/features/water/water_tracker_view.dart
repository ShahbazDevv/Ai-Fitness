import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/progress_controller.dart';
import '../../widgets/glass_card.dart';

class WaterTrackerView extends GetView<ProgressController> {
  const WaterTrackerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Water Intake')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final total = controller.waterLogs.fold(0, (sum, log) => sum + log.amountMl);

        return Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWaterSummary(total),
              SizedBox(height: 32.h),
              Text('Today\'s History', style: AppTextStyles.titleMd),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.waterLogs.length,
                  itemBuilder: (context, index) {
                    final log = controller.waterLogs[controller.waterLogs.length - 1 - index];
                    return _buildWaterLogTile(log);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWaterSummary(int total) {
    const goal = 2500;
    final progress = (total / goal).clamp(0.0, 1.0);

    return GlassCard(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily Total', style: AppTextStyles.bodySm),
                  Text('$total ml', style: AppTextStyles.headlineLgMobile.copyWith(color: Colors.blueAccent)),
                ],
              ),
              Icon(Icons.water_drop_rounded, color: Colors.blueAccent, size: 36.sp),
            ],
          ),
          SizedBox(height: 20.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12.h,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          ),
          SizedBox(height: 12.h),
          Text('Goal: $goal ml', style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp)),
        ],
      ),
    );
  }

  Widget _buildWaterLogTile(dynamic log) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.local_drink_rounded, color: Colors.blueAccent, size: 20),
              SizedBox(width: 16.w),
              Text('${log.amountMl} ml', style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          Text('Today', style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp)),
        ],
      ),
    );
  }
}
