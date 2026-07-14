import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/profile_controller.dart';
import '../../widgets/glass_textfield.dart';
import '../../widgets/glass_button.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Obx(() {
        if (controller.isLoading.value && controller.userProfile.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Basic Information'),
              GlassTextField(hintText: 'Full Name', controller: controller.nameController, prefixIcon: Icons.person_outline),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(child: GlassTextField(hintText: 'Age', controller: controller.ageController, keyboardType: TextInputType.number, prefixIcon: Icons.calendar_today_rounded)),
                  SizedBox(width: 16.w),
                  Expanded(child: _buildGenderDropdown()),
                ],
              ),
              SizedBox(height: 32.h),
              _buildSectionTitle('Body Metrics'),
              Row(
                children: [
                  Expanded(child: GlassTextField(hintText: 'Height (cm)', controller: controller.heightController, keyboardType: TextInputType.number, prefixIcon: Icons.height_rounded)),
                  SizedBox(width: 16.w),
                  Expanded(child: GlassTextField(hintText: 'Weight (kg)', controller: controller.weightController, keyboardType: TextInputType.number, prefixIcon: Icons.monitor_weight_rounded)),
                ],
              ),
              SizedBox(height: 16.h),
              GlassTextField(hintText: 'Goal Weight (kg)', controller: controller.goalWeightController, keyboardType: TextInputType.number, prefixIcon: Icons.flag_rounded),
              SizedBox(height: 16.h),
              _buildBodyFatSlider(),
              SizedBox(height: 32.h),
              _buildSectionTitle('Fitness Preferences'),
              _buildActivityDropdown(),
              SizedBox(height: 16.h),
              _buildGoalDropdown(),
              SizedBox(height: 16.h),
              _buildExperienceDropdown(),
              SizedBox(height: 32.h),
              _buildSectionTitle('Daily Nutrition Targets'),
              Row(
                children: [
                  Expanded(child: GlassTextField(hintText: 'Calories (kcal)', controller: controller.dailyCaloriesController, keyboardType: TextInputType.number, prefixIcon: Icons.local_fire_department_rounded)),
                  SizedBox(width: 16.w),
                  Expanded(child: GlassTextField(hintText: 'Protein (g)', controller: controller.dailyProteinController, keyboardType: TextInputType.number, prefixIcon: Icons.fitness_center_rounded)),
                ],
              ),
              SizedBox(height: 16.h),
              GlassTextField(hintText: 'Water Goal (ml)', controller: controller.dailyWaterGoalController, keyboardType: TextInputType.number, prefixIcon: Icons.water_drop_rounded),
              SizedBox(height: 32.h),
              _buildSectionTitle('Medical Notes'),
              GlassTextField(hintText: 'Any injuries or conditions...', controller: controller.medicalNotesController, maxLines: 3),
              SizedBox(height: 48.h),
              GlassButton(text: 'Save Changes', onPressed: controller.updateProfile, isGradient: true, isLoading: controller.isLoading.value),
              SizedBox(height: 40.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(title, style: AppTextStyles.titleMd.copyWith(fontSize: 18.sp)),
    );
  }

  Widget _buildGenderDropdown() {
    return _buildDropdown('Gender', controller.selectedGender, ['Male', 'Female', 'Other']);
  }

  Widget _buildActivityDropdown() {
    return _buildDropdown('Activity Level', controller.selectedActivityLevel, ['Sedentary', 'Light', 'Moderate', 'Active', 'Very Active']);
  }

  Widget _buildGoalDropdown() {
    return _buildDropdown('Fitness Goal', controller.selectedFitnessGoal, ['Weight Loss', 'Muscle Gain', 'Endurance', 'Flexibility', 'General Fitness', 'Hypertrophy', 'Fat Loss', 'Maintenance']);
  }

  Widget _buildExperienceDropdown() {
    return _buildDropdown('Experience Level', controller.selectedExperienceLevel, ['Beginner', 'Intermediate', 'Advanced']);
  }

  Widget _buildBodyFatSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text('Body Fat: ${controller.bodyFatController.value.toStringAsFixed(1)}%', style: AppTextStyles.bodyLg)),
        Obx(() => Slider(
              value: controller.bodyFatController.value,
              min: 3,
              max: 50,
              divisions: 470,
              activeColor: AppColors.primary,
              onChanged: (val) => controller.bodyFatController.value = val,
            )),
      ],
    );
  }

  Widget _buildDropdown(String label, RxString value, List<String> options) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.value,
              isExpanded: true,
              dropdownColor: AppColors.surface,
              style: AppTextStyles.bodyLg,
              onChanged: (val) => value.value = val!,
              items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
          )),
    );
  }
}
