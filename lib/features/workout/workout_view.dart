import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/fitness_controller.dart';
import '../../models/workout_model.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/custom_image.dart';

class WorkoutView extends GetView<FitnessController> {
  const WorkoutView({super.key});

  static const List<String> _bodyParts = ['All', 'Push', 'Pull', 'Legs', 'Full Body'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Workout Plans')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.workouts.isEmpty) {
          return const Center(child: Text('No workouts found.'));
        }

        return Column(
          children: [
            _buildBodyPartFilter(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                itemCount: _filteredWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = _filteredWorkouts[index];
                  return _buildWorkoutItem(workout);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  List<WorkoutModel> get _filteredWorkouts {
    if (controller.selectedBodyPart.value == 'All') {
      return controller.workouts;
    }
    return controller.workouts.where((w) => w.bodyPart == controller.selectedBodyPart.value).toList();
  }

  Widget _buildBodyPartFilter() {
    return Container(
      height: 50.h,
      margin: EdgeInsets.only(top: 16.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: _bodyParts.length,
        itemBuilder: (context, index) {
          final part = _bodyParts[index];
          final isSelected = controller.selectedBodyPart.value == part;
          return Container(
            margin: EdgeInsets.only(right: 12.w),
            child: ChoiceChip(
              label: Text(part),
              selected: isSelected,
              onSelected: (val) {
                if (val) controller.selectedBodyPart.value = part;
              },
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary,
              labelStyle: AppTextStyles.bodySm.copyWith(
                color: isSelected ? Colors.white : AppColors.textMuted,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutItem(WorkoutModel workout) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CustomImage(
                  imageUrl: workout.imageUrl,
                  height: 180.h,
                  width: double.infinity,
                ),
              ),
              if (workout.isAiRecommended)
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text('AI RECOMMENDED', style: AppTextStyles.labelCaps.copyWith(fontSize: 10.sp, color: Colors.white)),
                  ),
                ),
              Positioned(
                bottom: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(workout.category, style: AppTextStyles.labelCaps.copyWith(fontSize: 10.sp)),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(workout.title, style: AppTextStyles.titleMd, overflow: TextOverflow.ellipsis),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 8.h,
            children: [
              _buildInfoChip(Icons.timer_outlined, workout.duration),
              _buildInfoChip(Icons.local_fire_department_outlined, '${workout.caloriesBurned} kcal'),
              _buildInfoChip(Icons.fitness_center_rounded, '${workout.exercises.length} Exercises'),
            ],
          ),
          SizedBox(height: 16.h),
          _buildExerciseList(workout.exercises),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: AppColors.textMuted),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp), overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _buildExerciseList(List<ExerciseModel> exercises) {
    return Column(
      children: exercises.map((ex) => _buildExerciseTile(ex)).toList(),
    );
  }

  Widget _buildExerciseTile(ExerciseModel exercise) {
    return GlassCard(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.fitness_center_rounded, color: AppColors.primary, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.name, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                if (exercise.targetMuscle.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(exercise.targetMuscle, style: AppTextStyles.bodySm.copyWith(fontSize: 10.sp, color: AppColors.primary)),
                  ),
                SizedBox(height: 4.h),
                Text(
                  '${exercise.sets} sets x ${exercise.reps} reps • ${exercise.restSeconds}s rest',
                  style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (exercise.equipmentNeeded.isNotEmpty)
            Container(
              constraints: BoxConstraints(maxWidth: 80.w),
              margin: EdgeInsets.only(left: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                exercise.equipmentNeeded,
                style: AppTextStyles.bodySm.copyWith(fontSize: 10.sp),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
        ],
      ),
    );
  }
}
