import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/progress_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../repositories/fitness_repository.dart';
import '../../models/workout_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/glass_card.dart';

class ProgressView extends GetView<ProgressController> {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Progress')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFfmiLeanMassStats(),
              SizedBox(height: 24.h),
              _buildWeightChart(),
              SizedBox(height: 24.h),
              _buildFfmiChart(),
              SizedBox(height: 24.h),
              _buildWorkoutHistory(),
              SizedBox(height: 24.h),
              Text('Weight History', style: AppTextStyles.titleMd),
              SizedBox(height: 16.h),
              _buildWeightHistory(),
              SizedBox(height: 40.h),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.bmiCalculator),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_chart_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildFfmiLeanMassStats() {
    if (!Get.isRegistered<DashboardController>()) return const SizedBox();
    final dashboardController = Get.find<DashboardController>();
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Text('FFMI', style: AppTextStyles.bodySm),
                Obx(() => Text(
                      dashboardController.ffmi.value.toStringAsFixed(1),
                      style: AppTextStyles.titleMd.copyWith(color: AppColors.primary, fontSize: 20.sp),
                    )),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GlassCard(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Text('Lean Mass', style: AppTextStyles.bodySm),
                Obx(() => Text(
                      '${dashboardController.leanBodyMass.value.toStringAsFixed(1)}kg',
                      style: AppTextStyles.titleMd.copyWith(color: Colors.blueAccent, fontSize: 20.sp),
                    )),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GlassCard(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Text('Body Fat', style: AppTextStyles.bodySm),
                Obx(() {
                  final bf = controller.estimatedBodyFat.value;
                  return Column(
                    children: [
                      Text(
                        bf > 0 ? '${bf.toStringAsFixed(1)}%' : '--',
                        style: AppTextStyles.titleMd.copyWith(color: Colors.orangeAccent, fontSize: 20.sp),
                      ),
                      if (controller.bodyFatStatus.value.isNotEmpty)
                        Text(
                          controller.bodyFatStatus.value,
                          style: AppTextStyles.labelCaps.copyWith(color: Colors.orangeAccent, fontSize: 8.sp),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightChart() {
    if (controller.weightLogs.isEmpty) return const SizedBox();

    final spots = controller.weightLogs.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.weight);
    }).toList();

    return GlassCard(
      padding: EdgeInsets.only(top: 24.h, right: 24.w, left: 8.w, bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weight Trend', style: AppTextStyles.bodySm),
                Text('${controller.weightLogs.last.weight} kg', style: AppTextStyles.titleMd.copyWith(fontSize: 24.sp)),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 200.h,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.3),
                          AppColors.primary.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFfmiChart() {
    if (controller.ffmiHistory.length < 2) return const SizedBox();

    final spots = controller.ffmiHistory.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();

    return GlassCard(
      padding: EdgeInsets.only(top: 24.h, right: 24.w, left: 8.w, bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FFMI Trend', style: AppTextStyles.bodySm),
                Obx(() => Text(
                      controller.ffmiHistory.last.toStringAsFixed(1),
                      style: AppTextStyles.titleMd.copyWith(fontSize: 24.sp, color: Colors.blueAccent),
                    )),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 200.h,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(colors: [Colors.blueAccent, AppColors.primary]),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent.withValues(alpha: 0.3),
                          Colors.blueAccent.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutHistory() {
    final repo = FitnessRepository();
    final Future<List<WorkoutModel>> futureWorkouts = repo.getWorkouts();
    return FutureBuilder<List<WorkoutModel>>(
      future: futureWorkouts,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox();
        final workouts = snapshot.data!;
        final recent = workouts.take(3).toList();
        return _workoutHistoryList(recent);
      },
    );
  }

  Widget _workoutHistoryList(List<WorkoutModel> recent) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Workouts', style: AppTextStyles.titleMd),
        SizedBox(height: 16.h),
        ...recent.map((w) => Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(w.title, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                        SizedBox(height: 4.h),
                        Text('${w.duration} \u2022 ${w.caloriesBurned} cal', style: AppTextStyles.bodySm.copyWith(fontSize: 11.sp, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      w.category,
                      style: AppTextStyles.labelCaps.copyWith(color: AppColors.primary, fontSize: 9.sp),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildWeightHistory() {
    return Column(
      children: controller.weightLogs.reversed.map((log) => _buildHistoryTile(log)).toList(),
    );
  }

  Widget _buildHistoryTile(dynamic log) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.date, style: AppTextStyles.bodySm, overflow: TextOverflow.ellipsis),
                Text('BMI: ${log.bmi.toStringAsFixed(1)}', style: AppTextStyles.bodySm.copyWith(fontSize: 11.sp, color: AppColors.primary), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Text('${log.weight} kg', style: AppTextStyles.titleMd.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
