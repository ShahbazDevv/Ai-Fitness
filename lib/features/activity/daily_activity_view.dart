import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/progress_controller.dart';
import '../../widgets/glass_card.dart';

class DailyActivityView extends GetView<ProgressController> {
  const DailyActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Daily Activity')),
      body: Obx(() {
        final activity = controller.activity.value;
        if (activity == null) return const Center(child: CircularProgressIndicator());

        return SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              _buildBigStat(activity.steps, 'Steps', Icons.directions_walk_rounded, AppColors.primary),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(child: _buildSmallStat(activity.caloriesBurned, 'kcal', 'Calories', Icons.local_fire_department_rounded, Colors.orangeAccent)),
                  SizedBox(width: 16.w),
                  Expanded(child: _buildSmallStat(activity.activeMinutes, 'mins', 'Active', Icons.timer_rounded, Colors.blueAccent)),
                ],
              ),
              SizedBox(height: 24.h),
              _buildDistanceCard(activity.distanceKm),
              SizedBox(height: 40.h),
              _buildHourlyChartPlaceholder(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBigStat(int value, String label, IconData icon, Color color) {
    return GlassCard(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Column(
          children: [
            Icon(icon, color: color, size: 48.sp),
            SizedBox(height: 16.h),
            Text(value.toString(), style: AppTextStyles.displayLg.copyWith(fontSize: 48.sp)),
            Text(label, style: AppTextStyles.bodyLg.copyWith(color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStat(int value, String unit, String label, IconData icon, Color color) {
    return GlassCard(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value.toString(), style: AppTextStyles.titleMd.copyWith(fontSize: 22.sp, fontWeight: FontWeight.bold)),
              SizedBox(width: 4.w),
              Text(unit, style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp)),
            ],
          ),
          Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp)),
        ],
      ),
    );
  }

  Widget _buildDistanceCard(double distance) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: Colors.greenAccent.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.location_on_rounded, color: Colors.greenAccent),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Distance Covered', style: AppTextStyles.bodySm, overflow: TextOverflow.ellipsis),
                Text('${distance.toStringAsFixed(2)} km', style: AppTextStyles.titleMd, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyChartPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hourly Activity', style: AppTextStyles.titleMd),
        SizedBox(height: 16.h),
        GlassCard(
          padding: EdgeInsets.all(20.w),
          child: SizedBox(
            height: 150.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (index) {
                final height = (index * 10.0 + 20).h;
                return Container(
                  width: 12.w,
                  height: height,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: index == 8 ? 1 : 0.2),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
