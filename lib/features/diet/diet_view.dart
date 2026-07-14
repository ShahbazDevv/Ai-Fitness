import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/fitness_controller.dart';
import '../../models/diet_model.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/custom_image.dart';

class DietView extends GetView<FitnessController> {
  const DietView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Diet Plan')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final plan = controller.dietPlan.value;
        if (plan == null) {
          return const Center(child: Text('No diet plan found.'));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMacroOverview(plan),
              SizedBox(height: 32.h),
              Text('Today\'s Meals', style: AppTextStyles.titleMd),
              SizedBox(height: 16.h),
              _buildMealCard('Breakfast', plan.breakfast),
              _buildMealCard('Morning Snack', plan.morningSnack),
              _buildMealCard('Lunch', plan.lunch),
              _buildMealCard('Evening Snack', plan.eveningSnack),
              _buildMealCard('Dinner', plan.dinner),
              _buildMealCard('Post Workout', plan.postWorkoutMeal),
              SizedBox(height: 32.h),
              _buildAiTip(),
              SizedBox(height: 40.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMacroOverview(DietPlanModel plan) {
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
                    Text('Total Calories', style: AppTextStyles.bodySm),
                    Text('${plan.totalCalories} kcal', style: AppTextStyles.headlineLgMobile.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
              Icon(Icons.restaurant_rounded, color: AppColors.primary, size: 32.sp),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(child: _buildMacroItem('Protein', '${plan.totalProtein}g', Colors.orangeAccent)),
              Expanded(child: _buildMacroItem('Carbs', '${plan.totalCarbs}g', Colors.greenAccent)),
              Expanded(child: _buildMacroItem('Fats', '${plan.totalFats}g', Colors.blueAccent)),
              Expanded(child: _buildMacroItem('Fiber', '${plan.totalFiber}g', Colors.purpleAccent)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 10.sp), overflow: TextOverflow.ellipsis),
        SizedBox(height: 4.h),
        Text(value, style: AppTextStyles.titleMd.copyWith(fontSize: 14.sp, color: color), overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildMealCard(String type, MealModel meal) {
    return GlassCard(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(16.r)),
            child: CustomImage(
              imageUrl: meal.imageUrl,
              width: 90.w,
              height: 90.w,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type, style: AppTextStyles.bodySm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 10.sp)),
                  Text(meal.name, style: AppTextStyles.titleMd.copyWith(fontSize: 14.sp), maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4.h),
                  Text('${meal.calories} kcal • ${meal.protein}g P • ${meal.carbs}g C', style: AppTextStyles.bodySm.copyWith(fontSize: 10.sp), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, size: 18),
            onPressed: () => _showMealDetails(meal),
          ),
        ],
      ),
    );
  }

  Widget _buildAiTip() {
    return GlassCard(
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary, size: 24.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              'Drinking 500ml of water before each meal can help improve digestion and keep you satiated.',
              style: AppTextStyles.bodySm.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  void _showMealDetails(MealModel meal) {
    Get.bottomSheet(
      SafeArea(
        child: GlassCard(
          borderRadius: 30,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
              SizedBox(height: 20.h),
              Text(meal.name, style: AppTextStyles.headlineLgMobile),
              SizedBox(height: 12.h),
              Text(meal.description, style: AppTextStyles.bodyLg.copyWith(color: AppColors.textSecondary), maxLines: 3, overflow: TextOverflow.ellipsis),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(child: _buildMacroDetail('Calories', '${meal.calories} kcal')),
                  Expanded(child: _buildMacroDetail('Protein', '${meal.protein}g')),
                  Expanded(child: _buildMacroDetail('Carbs', '${meal.carbs}g')),
                  Expanded(child: _buildMacroDetail('Fats', '${meal.fats}g')),
                ],
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildMacroDetail(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.bodySm, overflow: TextOverflow.ellipsis),
        Text(value, style: AppTextStyles.titleMd.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
