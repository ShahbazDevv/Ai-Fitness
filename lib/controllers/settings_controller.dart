import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/supabase_service.dart';
import '../services/storage_service.dart';
import '../routes/app_routes.dart';

class SettingsController extends GetxController {
  final SupabaseService _supabase = Get.find<SupabaseService>();
  final StorageService _storage = Get.find<StorageService>();

  final RxBool pushNotifications = true.obs;
  final RxBool emailUpdates = false.obs;
  final RxBool darkMode = true.obs;

  final RxString weightUnit = 'Kilograms (kg)'.obs;
  final RxString distanceUnit = 'Kilometers (km)'.obs;

  final List<String> weightUnitOptions = ['Kilograms (kg)', 'Pounds (lbs)'];
  final List<String> distanceUnitOptions = ['Kilometers (km)', 'Miles (mi)'];

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    darkMode.value = _storage.getBool('dark_mode') ?? true;
    pushNotifications.value = _storage.getBool('push_notifications') ?? true;
    emailUpdates.value = _storage.getBool('email_updates') ?? false;
    weightUnit.value = _storage.getString('weight_unit') ?? 'Kilograms (kg)';
    distanceUnit.value = _storage.getString('distance_unit') ?? 'Kilometers (km)';
  }

  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
    _storage.setBool('push_notifications', value);
  }

  void toggleEmailUpdates(bool value) {
    emailUpdates.value = value;
    _storage.setBool('email_updates', value);
  }

  void toggleDarkMode(bool value) {
    darkMode.value = value;
    _storage.setBool('dark_mode', value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void setWeightUnit(String unit) {
    weightUnit.value = unit;
    _storage.setString('weight_unit', unit);
  }

  void setDistanceUnit(String unit) {
    distanceUnit.value = unit;
    _storage.setString('distance_unit', unit);
  }

  void showWeightUnitPicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text('Weight Unit', style: AppTextStyles.titleMd),
            SizedBox(height: 16.h),
            ...weightUnitOptions.map((unit) => ListTile(
              title: Text(unit, style: AppTextStyles.bodyLg),
              trailing: weightUnit.value == unit
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                  : null,
              onTap: () {
                setWeightUnit(unit);
                Get.back();
              },
            )),
          ],
        ),
      ),
    );
  }

  void showDistanceUnitPicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text('Distance Unit', style: AppTextStyles.titleMd),
            SizedBox(height: 16.h),
            ...distanceUnitOptions.map((unit) => ListTile(
              title: Text(unit, style: AppTextStyles.bodyLg),
              trailing: distanceUnit.value == unit
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                  : null,
              onTap: () {
                setDistanceUnit(unit);
                Get.back();
              },
            )),
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    await _supabase.logOut();
    Get.offAllNamed(AppRoutes.login);
  }

  void exportData() {
    Get.snackbar('Export', 'Your data export has started.');
  }

  Future<void> deleteAccount() async {
    if (_supabase.isMockMode) {
      Get.snackbar('Account Deleted', 'Your account has been successfully deleted.');
      logout();
      return;
    }
    try {
      final userId = _supabase.currentUser.value?.id;
      if (userId != null) {
        await _supabase.client.from('profiles').delete().eq('id', userId);
        await _supabase.client.auth.admin.deleteUser(userId);
      }
      await _supabase.logOut();
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar('Account Deleted', 'Your account has been permanently deleted.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete account: $e');
    }
  }
}