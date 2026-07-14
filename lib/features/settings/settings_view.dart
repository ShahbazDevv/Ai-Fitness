import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_images.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_image.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(24.w),
        children: [
          _buildProfileSection(),
          SizedBox(height: 32.h),
          _buildSettingsSection('Preferences', [
            Obx(() => _buildSwitchTile('Push Notifications', controller.pushNotifications.value, controller.togglePushNotifications)),
            Obx(() => _buildSwitchTile('Email Updates', controller.emailUpdates.value, controller.toggleEmailUpdates)),
            Obx(() => _buildSwitchTile('Dark Mode', controller.darkMode.value, controller.toggleDarkMode)),
          ]),
          SizedBox(height: 32.h),
          _buildSettingsSection('Units', [
            Obx(() => _buildSelectionTile('Weight Unit', controller.weightUnit.value, controller.showWeightUnitPicker)),
            Obx(() => _buildSelectionTile('Distance Unit', controller.distanceUnit.value, controller.showDistanceUnitPicker)),
          ]),
          SizedBox(height: 32.h),
          _buildSettingsSection('Data', [
            _buildActionTile('Export Fitness Data', Icons.download_rounded, onTap: controller.exportData),
            _buildActionTile('Delete Account', Icons.delete_forever_rounded, color: AppColors.primary, onTap: () => _confirmDelete()),
          ]),
          SizedBox(height: 32.h),
          _buildActionTile('Logout', Icons.logout_rounded, onTap: () => _confirmLogout()),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(onPressed: () { Get.back(); controller.logout(); }, child: const Text('Logout', style: TextStyle(color: AppColors.primary))),
        ],
      ),
    );
  }

  void _confirmDelete() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(onPressed: () { Get.back(); controller.deleteAccount(); }, child: const Text('Delete', style: TextStyle(color: AppColors.primary))),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    if (!Get.isRegistered<ProfileController>()) return const SizedBox();
    final profileController = Get.find<ProfileController>();
    return Obx(() {
      final profile = profileController.userProfile.value;
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () => Get.toNamed(AppRoutes.editProfile),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundImage: CustomImageProvider.get(profile?.profilePictureUrl ?? AppImages.userProfile),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.fullName ?? 'User',
                      style: AppTextStyles.titleMd,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      profile?.email ?? '',
                      style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 24.sp),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMd.copyWith(fontSize: 16.sp, color: AppColors.textMuted)),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool)? onChanged) {
    return ListTile(
      title: Text(title, style: AppTextStyles.bodyLg),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildSelectionTile(String title, String current, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: AppTextStyles.bodyLg),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(current, style: AppTextStyles.bodySm.copyWith(color: AppColors.primary)),
          Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20.sp),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildActionTile(String title, IconData icon, {Color? color, VoidCallback? onTap}) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: (color ?? Colors.white70).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: color ?? Colors.white70, size: 18.sp),
      ),
      title: Text(title, style: AppTextStyles.bodyLg.copyWith(color: color)),
      onTap: onTap,
    );
  }
}