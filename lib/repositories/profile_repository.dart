import 'dart:io';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/supabase_service.dart';
import '../services/storage_service.dart';
import '../constants/app_images.dart';

class ProfileRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();
  final StorageService _storage = Get.find<StorageService>();

  Future<UserModel> getProfile() async {
    final user = _supabase.currentUser.value;
    if (user == null && !_supabase.isMockMode) {
      throw Exception('User not authenticated');
    }
    
    final userId = user?.id ?? 'user_1';
    if (_supabase.isMockMode) {
      return UserModel(
        id: userId,
        email: 'alex@aifitness.com',
        fullName: 'Alex Carter',
        age: 26,
        gender: 'Male',
        height: 178.0,
        weight: 75.0,
        goalWeight: 78.0,
        activityLevel: 'Active',
        fitnessGoal: 'Hypertrophy',
        medicalNotes: 'Slight lower back tension',
        profilePictureUrl: AppImages.userProfile,
        isPremium: true,
      );
    }

    try {
      final response = await _supabase.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile(UserModel profile) async {
    if (_supabase.isMockMode) return;
    try {
      await _supabase.client
          .from('profiles')
          .update(profile.toJson())
          .eq('id', profile.id);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateProfilePicture(File file) async {
    final userId = _supabase.currentUser.value?.id ?? 'user_1';
    try {
      final publicUrl = await _storage.uploadProfileImage(file, userId);
      
      // Update public URL inside profile table
      if (!_supabase.isMockMode) {
        await _supabase.client
            .from('profiles')
            .update({'profile_picture_url': publicUrl})
            .eq('id', userId);
      }
      return publicUrl;
    } catch (e) {
      rethrow;
    }
  }
}
