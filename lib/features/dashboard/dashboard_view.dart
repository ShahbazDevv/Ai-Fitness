import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/progress_ring.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/animated_progress_bar.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.loadDashboardData,
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  _buildHeader(),
                  SizedBox(height: 24.h),
                  _buildMainProgress(),
                  SizedBox(height: 24.h),
                  _buildQuickStats(),
                  SizedBox(height: 32.h),
                  _buildSectionTitle('AI Recommended Workout', AppRoutes.workoutPlan),
                  SizedBox(height: 16.h),
                  _buildWorkoutCard(),
                  SizedBox(height: 32.h),
                  _buildSectionTitle('Today\'s Diet Plan', AppRoutes.dietPlan),
                  SizedBox(height: 16.h),
                  _buildDietCard(),
                  SizedBox(height: 32.h),
                  _buildWaterTracker(),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    final profileController = Get.find<ProfileController>();
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello Champion!',
                style: AppTextStyles.headlineLgMobile,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                'Let\'s smash your goals today',
                style: AppTextStyles.bodySm,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.profile),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Obx(() {
              final user = profileController.userProfile.value;
              final url = user?.profilePictureUrl ?? '';
              final hasPhoto = url.isNotEmpty;
              return CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.surface,
                backgroundImage: hasPhoto ? CustomImageProvider.get(url) : null,
                child: hasPhoto
                    ? null
                    : Icon(Icons.person, color: AppColors.primary, size: 30.r),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildMainProgress() {
    final activity = controller.dailyActivity.value;
    final stepPercentage = (activity.steps / 10000).clamp(0.0, 1.0);

    return GlassCard(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;
          final ringSize = isNarrow ? 100.w : 120.w;
          final gap = isNarrow ? 16.w : 24.w;

          return Row(
            children: [
              ProgressRing(
                percentage: stepPercentage,
                size: ringSize,
                strokeWidth: 8,
                centerWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_walk_rounded, color: AppColors.primary, size: (isNarrow ? 18 : 22).sp),
                    Text(
                      activity.steps.toString(),
                      style: AppTextStyles.titleMd.copyWith(fontSize: (isNarrow ? 18 : 22).sp, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Steps',
                      style: AppTextStyles.bodySm.copyWith(fontSize: (isNarrow ? 8 : 10).sp),
                    ),
                  ],
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressInfo('Calories', '${activity.caloriesBurned}', 'kcal', Icons.local_fire_department_rounded),
                    SizedBox(height: isNarrow ? 12.h : 16.h),
                    _buildProgressInfo('Active Time', '${activity.activeMinutes}', 'mins', Icons.timer_rounded),
                    SizedBox(height: isNarrow ? 12.h : 16.h),
                    _buildProgressInfo('Distance', activity.distanceKm.toStringAsFixed(1), 'km', Icons.location_on_rounded),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressInfo(String label, String value, String unit, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp)),
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: AppTextStyles.titleMd.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' $unit',
                      style: AppTextStyles.bodySm.copyWith(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMetricDetail({
    required String title,
    required String value,
    required String description,
    required String healthyRange,
    required String suggestion,
    required IconData icon,
    required Color color,
  }) {
    Get.bottomSheet(
      GlassCard(
        borderRadius: 30,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
            SizedBox(height: 20.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 24.sp),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted)),
                    Text(value, style: AppTextStyles.headlineLgMobile.copyWith(color: color)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text('What this means', style: AppTextStyles.titleMd.copyWith(fontSize: 16.sp)),
            SizedBox(height: 8.h),
            Text(description, style: AppTextStyles.bodySm.copyWith(height: 1.5)),
            SizedBox(height: 20.h),
            Text('Healthy Range', style: AppTextStyles.titleMd.copyWith(fontSize: 16.sp)),
            SizedBox(height: 8.h),
            Text(healthyRange, style: AppTextStyles.bodySm.copyWith(height: 1.5, color: Colors.greenAccent)),
            SizedBox(height: 20.h),
            Text('Improvement Suggestions', style: AppTextStyles.titleMd.copyWith(fontSize: 16.sp)),
            SizedBox(height: 8.h),
            Text(suggestion, style: AppTextStyles.bodySm.copyWith(height: 1.5, color: AppColors.primary)),
            SizedBox(height: 32.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildQuickStats() {
    return Column(
      children: [
        _buildFfmiSection(),
        SizedBox(height: 16.h),
        _buildLeanMassBodyFatSection(),
        SizedBox(height: 16.h),
        _buildBmiSection(),
        SizedBox(height: 16.h),
        _buildNutritionGoals(),
        SizedBox(height: 24.h),
        _buildRecommendationSection(),
      ],
    );
  }

  Widget _buildFfmiSection() {
    return GestureDetector(
      onTap: () => _showMetricDetail(
        title: 'FFMI',
        value: controller.ffmi.value.toStringAsFixed(1),
        description: 'Fat-Free Mass Index (FFMI) is a more accurate measure of muscle development than BMI. It estimates your muscle mass relative to your height, giving a clearer picture of body composition for active individuals.',
        healthyRange: '18.0 - 20.0: Average\n20.0 - 22.0: Above Average\n22.0 - 25.0: Excellent\n25.0+: Superior/Professional',
        suggestion: 'To improve FFMI, focus on progressive overload training with adequate protein intake (1.6-2.2g per kg of bodyweight) and a slight caloric surplus. Prioritize compound lifts like squats, deadlifts, and bench press.',
        icon: Icons.fitness_center_rounded,
        color: AppColors.primary,
      ),
      child: GlassCard(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('FFMI Score', style: AppTextStyles.bodySm),
                Icon(Icons.fitness_center_rounded, color: AppColors.primary, size: 20.sp),
              ],
            ),
            SizedBox(height: 12.h),
            Obx(() => Text(
              controller.ffmi.value.toStringAsFixed(1),
              style: AppTextStyles.headlineLgMobile.copyWith(color: AppColors.primary),
              overflow: TextOverflow.ellipsis,
            )),
            SizedBox(height: 4.h),
            Obx(() => Text(
              controller.muscleCategory.value,
              style: AppTextStyles.labelCaps.copyWith(color: Colors.greenAccent, fontSize: 10.sp),
              overflow: TextOverflow.ellipsis,
            )),
            SizedBox(height: 12.h),
            Obx(() => ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: (controller.ffmi.value / 30).clamp(0.0, 1.0),
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 4.h,
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLeanMassBodyFatSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 360) {
          return Column(
            children: [
              _leanMassCard(),
              SizedBox(height: 12.h),
              _bodyFatCard(),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: _leanMassCard()),
            SizedBox(width: 16.w),
            Expanded(child: _bodyFatCard()),
          ],
        );
      },
    );
  }

  Widget _leanMassCard() {
    return GestureDetector(
      onTap: () => _showMetricDetail(
        title: 'Lean Body Mass',
        value: '${controller.leanBodyMass.value.toStringAsFixed(1)} kg',
        description: 'Lean Body Mass (LBM) is your total body weight minus fat mass. It includes muscle, bone, organs, and water. Tracking LBM helps you ensure you\'re building muscle, not just gaining weight.',
        healthyRange: 'Depends on height and gender.\nMen: 50-65% of total weight\nWomen: 45-60% of total weight\nHigher is generally better for athletes.',
        suggestion: 'Maintain a slight caloric surplus with 1.6-2.2g protein per kg of bodyweight. Prioritize resistance training 4-5 times per week with progressive overload.',
        icon: Icons.monitor_weight_rounded,
        color: Colors.blueAccent,
      ),
      child: GlassCard(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lean Body Mass', style: AppTextStyles.bodySm),
                Icon(Icons.monitor_weight_rounded, color: Colors.blueAccent, size: 20.sp),
              ],
            ),
            SizedBox(height: 12.h),
            Obx(() => Text(
              '${controller.leanBodyMass.value.toStringAsFixed(1)} kg',
              style: AppTextStyles.headlineLgMobile.copyWith(color: Colors.blueAccent),
              overflow: TextOverflow.ellipsis,
            )),
            SizedBox(height: 4.h),
            Text(
              'Fat Free Mass',
              style: AppTextStyles.labelCaps.copyWith(color: AppColors.textMuted, fontSize: 10.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyFatCard() {
    return GestureDetector(
      onTap: () => _showMetricDetail(
        title: 'Body Fat',
        value: '${controller.bodyFatPercentage.value.toStringAsFixed(1)}%',
        description: 'Body fat percentage measures the proportion of fat tissue in your body. Essential for health, but excess body fat increases disease risk. Athletes typically have lower body fat percentages.',
        healthyRange: 'Essential Fat: 10-13% (Women), 2-5% (Men)\nAthletes: 14-20% (Women), 6-13% (Men)\nFitness: 21-24% (Women), 14-17% (Men)\nAverage: 25-31% (Women), 18-24% (Men)',
        suggestion: 'To reduce body fat, maintain a caloric deficit of 300-500 calories per day while keeping protein high (1.8-2.2g per kg). Combine strength training with regular cardio for best results.',
        icon: Icons.percent_rounded,
        color: Colors.purpleAccent,
      ),
      child: GlassCard(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Body Fat', style: AppTextStyles.bodySm),
                Icon(Icons.percent_rounded, color: Colors.purpleAccent, size: 20.sp),
              ],
            ),
            SizedBox(height: 12.h),
            Obx(() => Text(
              '${controller.bodyFatPercentage.value.toStringAsFixed(1)}%',
              style: AppTextStyles.headlineLgMobile.copyWith(color: Colors.purpleAccent),
              overflow: TextOverflow.ellipsis,
            )),
            SizedBox(height: 4.h),
            Text(
              'Fat Mass',
              style: AppTextStyles.labelCaps.copyWith(color: AppColors.textMuted, fontSize: 10.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiSection() {
    return GestureDetector(
      onTap: () => _showMetricDetail(
        title: 'BMI',
        value: controller.bmi.value.toStringAsFixed(1),
        description: 'Body Mass Index (BMI) is a simple height-to-weight ratio. While useful for population studies, BMI does not distinguish between muscle and fat, making it less accurate for athletic individuals.',
        healthyRange: 'Underweight: < 18.5\nNormal: 18.5 - 24.9\nOverweight: 25 - 29.9\nObese: >= 30',
        suggestion: 'For fitness enthusiasts, FFMI and body fat percentage are more meaningful metrics. Use BMI as a general reference, but rely on body composition measurements for tracking progress.',
        icon: Icons.monitor_weight_rounded,
        color: Colors.orangeAccent,
      ),
      child: GlassCard(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(color: Colors.orangeAccent.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(Icons.monitor_weight_rounded, color: Colors.orangeAccent, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BMI', style: AppTextStyles.bodySm.copyWith(fontSize: 10.sp)),
                  Obx(() => Row(
                    children: [
                      Text(
                        controller.bmi.value.toStringAsFixed(1),
                        style: AppTextStyles.titleMd.copyWith(fontSize: 18.sp, color: Colors.orangeAccent),
                      ),
                      SizedBox(width: 8.w),
                      Obx(() => Text(
                        controller.bmiStatus.value,
                        style: AppTextStyles.labelCaps.copyWith(
                          color: controller.bmi.value < 18.5 || controller.bmi.value >= 30
                              ? Colors.redAccent : Colors.greenAccent,
                          fontSize: 10.sp,
                        ),
                      )),
                    ],
                  )),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 14.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionGoals() {
    return Obx(() {
      final diet = controller.todayDietPlan.value;
      return GlassCard(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Daily Nutrition Targets', style: AppTextStyles.titleMd.copyWith(fontSize: 16.sp), overflow: TextOverflow.ellipsis),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.restaurant_menu_rounded, color: AppColors.primary, size: 22.sp),
              ],
            ),
            SizedBox(height: 16.h),
            _buildNutrientRow('Calories', controller.dailyActivity.value.caloriesBurned, controller.dailyCaloriesGoal.value, 'kcal', AppColors.primary),
            SizedBox(height: 12.h),
            _buildNutrientRow('Protein', diet?.totalProtein ?? 0, controller.dailyProteinGoal.value, 'g', Colors.orangeAccent),
            SizedBox(height: 12.h),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 280;
                if (isNarrow) {
                  return Column(
                    children: [
                      _buildCompactNutrient('Carbs', diet?.totalCarbs ?? 0, 'g', Colors.greenAccent),
                      SizedBox(height: 8.h),
                      _buildCompactNutrient('Fats', diet?.totalFats ?? 0, 'g', Colors.blueAccent),
                      SizedBox(height: 8.h),
                      _buildCompactNutrient('Fiber', diet?.totalFiber ?? 0, 'g', Colors.purpleAccent),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: _buildCompactNutrient('Carbs', diet?.totalCarbs ?? 0, 'g', Colors.greenAccent)),
                    SizedBox(width: 12.w),
                    Expanded(child: _buildCompactNutrient('Fats', diet?.totalFats ?? 0, 'g', Colors.blueAccent)),
                    SizedBox(width: 12.w),
                    Expanded(child: _buildCompactNutrient('Fiber', diet?.totalFiber ?? 0, 'g', Colors.purpleAccent)),
                  ],
                );
              },
            ),
            SizedBox(height: 16.h),
            _buildNutrientRow('Water', controller.waterIntake.value, controller.dailyWaterGoal.value, 'ml', Colors.blueAccent),
          ],
        ),
      );
    });
  }

  Widget _buildNutrientRow(String label, int current, int goal, String unit, Color color) {
    final percentage = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp)),
            const Spacer(),
            Text(
              '$current / $goal $unit',
              style: AppTextStyles.bodySm.copyWith(fontSize: 11.sp, color: color, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(height: 4.h),
        AnimatedProgressBar(percentage: percentage, height: 6),
      ],
    );
  }

  Widget _buildCompactNutrient(String label, int value, String unit, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Text(value.toString(), style: AppTextStyles.titleMd.copyWith(fontSize: 18.sp, color: color)),
          Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 10.sp, color: AppColors.textMuted)),
          Text(unit, style: AppTextStyles.bodySm.copyWith(fontSize: 8.sp, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildRecommendationSection() {
    return GlassCard(
      backgroundColor: AppColors.primary.withValues(alpha: 0.08),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary, size: 24),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Obx(() {
              final user = Get.find<ProfileController>().userProfile.value;
              final bmiVal = controller.bmi.value;
              final bf = controller.bodyFatPercentage.value;

              String recommendation;
              if (user == null) {
                recommendation = 'Complete your profile to get personalized recommendations.';
              } else if (bmiVal > 27 && bf > 20) {
                recommendation = 'Based on your metrics, focus on fat loss with moderate cardio and a caloric deficit.';
              } else if (controller.ffmi.value > 22) {
                recommendation = 'Your muscle development looks solid. Focus on progressive overload for continued hypertrophy.';
              } else if (user.fitnessGoal.contains('Loss') || bf > 22) {
                recommendation = 'Increase protein intake to preserve muscle during your fat loss phase.';
              } else if (user.fitnessGoal.contains('Gain') || user.fitnessGoal == 'Hypertrophy') {
                recommendation = 'Stay in a slight caloric surplus with adequate protein to maximize muscle growth.';
              } else {
                recommendation = 'Keep up the consistency! Track your nutrition and training daily.';
              }

              return Text(
                recommendation,
                style: AppTextStyles.bodySm.copyWith(height: 1.4),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String route) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.titleMd),
        GestureDetector(
          onTap: () => Get.toNamed(route),
          child: Text(
            'See All',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutCard() {
    if (controller.recommendedWorkouts.isEmpty) {
      return GlassCard(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(Icons.fitness_center_rounded, color: AppColors.primary.withValues(alpha: 0.5), size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No Recommended Workout', style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4.h),
                  Text('Update your profile to get personalized workout recommendations.', style: AppTextStyles.bodySm.copyWith(fontSize: 11.sp)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    final workout = controller.recommendedWorkouts.first;

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.workoutPlan),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: CustomImage(
                    imageUrl: workout.imageUrl,
                    height: 140.h,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'AI Pick',
                      style: AppTextStyles.labelCaps.copyWith(fontSize: 9.sp, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(workout.title, style: AppTextStyles.titleMd.copyWith(fontSize: 16.sp), overflow: TextOverflow.ellipsis, maxLines: 1),
                        SizedBox(height: 4.h),
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 4.h,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.timer_outlined, size: 14.sp, color: AppColors.textMuted),
                                SizedBox(width: 4.w),
                                Text(workout.duration, style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp)),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.local_fire_department_outlined, size: 14.sp, color: AppColors.textMuted),
                                SizedBox(width: 4.w),
                                Text('${workout.caloriesBurned} kcal', style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietCard() {
    final diet = controller.todayDietPlan.value;
    if (diet == null) return const SizedBox();

    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CustomImage(
                  imageUrl: diet.breakfast.imageUrl,
                  width: 60.w,
                  height: 60.w,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Next Meal: Breakfast', style: AppTextStyles.bodySm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 10.sp)),
                    Text(diet.breakfast.name, style: AppTextStyles.titleMd.copyWith(fontSize: 14.sp)),
                    Text(
                      '${diet.breakfast.calories} kcal • ${diet.breakfast.protein}g Protein',
                      style: AppTextStyles.bodySm.copyWith(fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(child: _buildSimpleMacro('Calories', '${diet.totalCalories}', Colors.white)),
              Expanded(child: _buildSimpleMacro('Protein', '${diet.totalProtein}g', Colors.orangeAccent)),
              Expanded(child: _buildSimpleMacro('Carbs', '${diet.totalCarbs}g', Colors.greenAccent)),
              Expanded(child: _buildSimpleMacro('Fats', '${diet.totalFats}g', Colors.blueAccent)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleMacro(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.bodySm.copyWith(color: color, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
        Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 9.sp, color: AppColors.textMuted), overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildWaterTracker() {
    return GlassCard(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hydration', style: AppTextStyles.titleMd.copyWith(fontSize: 18.sp)),
                    Obx(() => Text(
                      '${controller.waterIntake.value} / ${controller.dailyWaterGoal.value} ml',
                      style: AppTextStyles.bodySm,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.water_drop_rounded, color: Colors.blueAccent, size: 28.sp),
            ],
          ),
          SizedBox(height: 16.h),
          Obx(() => ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: controller.dailyWaterGoal.value > 0
                  ? (controller.waterIntake.value / controller.dailyWaterGoal.value).clamp(0.0, 1.0)
                  : 0.0,
              minHeight: 10.h,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          )),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWaterAddButton(250),
              _buildWaterAddButton(500),
              _buildWaterAddButton(750),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaterAddButton(int ml) {
    return GestureDetector(
      onTap: () => controller.addWater(ml),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
        ),
        child: Text(
          '+$ml ml',
          style: AppTextStyles.bodySm.copyWith(color: Colors.blueAccent, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
