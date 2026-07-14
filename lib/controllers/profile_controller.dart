import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../repositories/profile_repository.dart';
import '../models/user_model.dart';
import '../services/supabase_service.dart';
import '../routes/app_routes.dart';
import 'dashboard_controller.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepo = ProfileRepository();
  final SupabaseService _supabase = Get.find<SupabaseService>();
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoading = true.obs;
  final Rxn<UserModel> userProfile = Rxn<UserModel>();

  // Edit Profile Form
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final goalWeightController = TextEditingController();
  final medicalNotesController = TextEditingController();

  final RxString selectedGender = 'Male'.obs;
  final RxString selectedActivityLevel = 'Moderate'.obs;
  final RxString selectedFitnessGoal = 'Muscle Gain'.obs;
  final RxString selectedExperienceLevel = 'Intermediate'.obs;
  final RxDouble bodyFatController = 15.0.obs;
  final dailyCaloriesController = TextEditingController();
  final dailyProteinController = TextEditingController();
  final dailyWaterGoalController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final profile = await _profileRepo.getProfile();
      userProfile.value = profile;
      _initializeEditControllers(profile);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile');
    } finally {
      isLoading.value = false;
    }
  }

  void _initializeEditControllers(UserModel profile) {
    nameController.text = profile.fullName;
    ageController.text = profile.age.toString();
    heightController.text = profile.height.toString();
    weightController.text = profile.weight.toString();
    goalWeightController.text = profile.goalWeight.toString();
    medicalNotesController.text = profile.medicalNotes;
    selectedGender.value = profile.gender;
    selectedActivityLevel.value = profile.activityLevel;
    selectedFitnessGoal.value = profile.fitnessGoal;
    selectedExperienceLevel.value = profile.experienceLevel;
    bodyFatController.value = profile.bodyFatPercentage;
    dailyCaloriesController.text = profile.dailyCalories.toString();
    dailyProteinController.text = profile.dailyProtein.toString();
    dailyWaterGoalController.text = profile.dailyWaterGoal.toString();
  }

  Future<void> updateProfile() async {
    if (userProfile.value == null) return;
    
    isLoading.value = true;
    try {
      final updatedProfile = userProfile.value!.copyWith(
        fullName: nameController.text,
        age: int.tryParse(ageController.text) ?? userProfile.value!.age,
        gender: selectedGender.value,
        height: double.tryParse(heightController.text) ?? userProfile.value!.height,
        weight: double.tryParse(weightController.text) ?? userProfile.value!.weight,
        goalWeight: double.tryParse(goalWeightController.text) ?? userProfile.value!.goalWeight,
        activityLevel: selectedActivityLevel.value,
        fitnessGoal: selectedFitnessGoal.value,
        experienceLevel: selectedExperienceLevel.value,
        medicalNotes: medicalNotesController.text,
        bodyFatPercentage: bodyFatController.value,
        dailyCalories: int.tryParse(dailyCaloriesController.text) ?? userProfile.value!.dailyCalories,
        dailyProtein: int.tryParse(dailyProteinController.text) ?? userProfile.value!.dailyProtein,
        dailyWaterGoal: int.tryParse(dailyWaterGoalController.text) ?? userProfile.value!.dailyWaterGoal,
      );

      await _profileRepo.updateProfile(updatedProfile);
      userProfile.value = updatedProfile;
      
      // Force refresh dashboard data if registered
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().loadDashboardData();
      }

      Get.back();
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      print('Update Profile Error: $e');
      Get.snackbar('Error', 'Failed to update profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    isLoading.value = true;
    try {
      final url = await _profileRepo.updateProfilePicture(File(image.path));
      userProfile.value = userProfile.value?.copyWith(profilePictureUrl: url);
      Get.snackbar('Success', 'Profile picture updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> togglePremium(bool status) async {
    if (userProfile.value == null) return;
    try {
      final updatedProfile = userProfile.value!.copyWith(isPremium: status);
      await _profileRepo.updateProfile(updatedProfile);
      userProfile.value = updatedProfile;
    } catch (e) {
      print('Failed to update premium status: $e');
    }
  }

  Future<void> logout() async {
    await _supabase.logOut();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    goalWeightController.dispose();
    medicalNotesController.dispose();
    dailyCaloriesController.dispose();
    dailyProteinController.dispose();
    dailyWaterGoalController.dispose();
    super.onClose();
  }
}
