import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/ai_scan_controller.dart';
import '../../widgets/glass_card.dart';

class AiAnalysisResultView extends GetView<AiScanController> {
  const AiAnalysisResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final result = controller.analysisResult.value;

    if (result == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Analysis')),
        body: const Center(child: Text('No analysis result found.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Vision Analysis', style: AppTextStyles.titleMd),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.redGradient,
                ),
                child: Center(
                  child: Icon(Icons.auto_awesome_rounded, size: 80.sp, color: Colors.white.withValues(alpha: 0.3)),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(24.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSummaryRow(result),
                SizedBox(height: 32.h),
                _buildSection('Body Metrics', [
                  _buildMetricTile('Body Fat', result['bodyFat'] != null ? (result['bodyFat'].toString().contains('%') ? result['bodyFat'].toString() : result['bodyFat'].toString() + '%') : 'N/A', Icons.percent_rounded),
                  _buildMetricTile('Muscle Mass', result['muscleMass'] ?? 'N/A', Icons.fitness_center_rounded),
                  _buildMetricTile('Posture', result['posture'] ?? 'N/A', Icons.accessibility_new_rounded),
                  _buildMetricTile('BMI', result['bmi'] ?? 'N/A', Icons.monitor_weight_rounded),
                  _buildMetricTile('FFMI', result['ffmi'] ?? 'N/A', Icons.fitness_center_rounded),
                ]),
                SizedBox(height: 32.h),
                _buildSection('Physique Analysis', [
                  _buildInfoTile('Strengths', result['strength'] ?? '', Icons.thumb_up_alt_rounded, Colors.greenAccent),
                  SizedBox(height: 12.h),
                  _buildInfoTile('Weaknesses', result['weakness'] ?? '', Icons.warning_rounded, Colors.orangeAccent),
                ]),
                SizedBox(height: 32.h),
                _buildPlanSection('AI Recommendations', result),
                SizedBox(height: 40.h),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 54.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27.r)),
                  ),
                  child: const Text('Back to Dashboard'),
                ),
                SizedBox(height: 40.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(Map<String, dynamic> result) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryItem('Fitness Level', result['fitnessLevel'] ?? 'Beginner'),
        Container(width: 1, height: 40, color: AppColors.borderLight),
        _buildSummaryItem('Status', 'Analyzed'),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp)),
        SizedBox(height: 4.h),
        Text(value, style: AppTextStyles.titleMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMd),
        SizedBox(height: 16.h),
        ...children,
      ],
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22.sp),
          SizedBox(width: 16.w),
          Text(label, style: AppTextStyles.bodyLg),
          const Spacer(),
          Text(value, style: AppTextStyles.titleMd.copyWith(fontSize: 16.sp, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String content, IconData icon, Color color) {
    return GlassCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20.sp),
              SizedBox(width: 10.w),
              Text(title, style: AppTextStyles.titleMd.copyWith(fontSize: 16.sp, color: color)),
            ],
          ),
          SizedBox(height: 8.h),
          Text(content, style: AppTextStyles.bodySm.copyWith(color: AppColors.textSecondary, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildPlanSection(String title, Map<String, dynamic> result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMd),
        SizedBox(height: 16.h),
        _buildExpandableTile('Workout Strategy', result['workoutPlan'] ?? '', Icons.fitness_center_rounded),
        SizedBox(height: 12.h),
        _buildExpandableTile('Nutrition Focus', result['dietPlan'] ?? '', Icons.restaurant_menu_rounded),
        SizedBox(height: 12.h),
        _buildExpandableTile('Recovery Advice', result['advice'] ?? '', Icons.spa_rounded),
      ],
    );
  }

  Widget _buildExpandableTile(String title, String content, IconData icon) {
    return ExpansionTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
      childrenPadding: EdgeInsets.all(16.w),
      expandedAlignment: Alignment.topLeft,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: AppColors.surface.withValues(alpha: 0.3),
      collapsedBackgroundColor: AppColors.surface.withValues(alpha: 0.5),
      children: [
        Text(content, style: AppTextStyles.bodySm.copyWith(height: 1.5)),
      ],
    );
  }
}
