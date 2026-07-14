import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/profile_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/custom_image.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value && controller.userProfile.value == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.userProfile.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load profile details'),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: controller.fetchProfile,
                  child: const Text('Retry'),
                ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: controller.logout,
                  child: const Text('Logout', style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
          );
        }

        final profile = controller.userProfile.value!;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280.h,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeader(profile),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_note_rounded),
                  onPressed: () => Get.toNamed(AppRoutes.editProfile),
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSection('Health Metrics', [
                    _buildMetricRow(profile),
                  ]),
                  SizedBox(height: 32.h),
                  _buildSection('Account Settings', [
                    _buildSettingsTile('Premium Subscription', Icons.workspace_premium_rounded, AppColors.primary, () => Get.toNamed(AppRoutes.premium)),
                    _buildSettingsTile('Notifications', Icons.notifications_none_rounded, Colors.blueAccent, () => Get.toNamed(AppRoutes.notifications)),
                    _buildSettingsTile('General Settings', Icons.settings_outlined, Colors.grey, () => Get.toNamed(AppRoutes.settings)),
                  ]),
                  SizedBox(height: 32.h),
                  _buildSection('Support', [
                    _buildSettingsTile('Help & Support', Icons.help_outline_rounded, Colors.greenAccent, () => Get.toNamed(AppRoutes.support)),
                    _buildSettingsTile('Privacy Policy', Icons.privacy_tip_outlined, Colors.tealAccent, () => Get.toNamed(AppRoutes.privacy)),
                    _buildSettingsTile('About AI Fitness', Icons.info_outline_rounded, Colors.amberAccent, () => Get.toNamed(AppRoutes.about)),
                  ]),
                  SizedBox(height: 48.h),
                  _buildLogoutButton(),
                  SizedBox(height: 40.h),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(dynamic profile) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.background, AppColors.surface],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundImage: CustomImageProvider.get(profile.profilePictureUrl),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: controller.uploadProfilePicture,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18.sp),
                      ),
                    ),
                  ),
                ],
              ),
          SizedBox(height: 16.h),
          Text(profile.fullName, style: AppTextStyles.headlineLgMobile, overflow: TextOverflow.ellipsis, maxLines: 1),
          Text(profile.email, style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted), overflow: TextOverflow.ellipsis, maxLines: 1),
          if (profile.isPremium)
            Container(
              margin: EdgeInsets.only(top: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Text('PREMIUM MEMBER', style: AppTextStyles.labelCaps.copyWith(color: AppColors.primary, fontSize: 9.sp)),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMd.copyWith(fontSize: 16.sp, color: AppColors.textMuted)),
        SizedBox(height: 16.h),
        ...children,
      ],
    );
  }

  Widget _buildMetricRow(dynamic profile) {
    return Row(
      children: [
        Expanded(child: _buildMetricItem('Weight', '${profile.weight} kg')),
        SizedBox(width: 12.w),
        Expanded(child: _buildMetricItem('Height', '${profile.height} cm')),
        SizedBox(width: 12.w),
        Expanded(child: _buildMetricItem('Goal', profile.fitnessGoal)),
      ],
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return GlassCard(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 11.sp)),
          SizedBox(height: 4.h),
          Text(value, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold, fontSize: 13.sp), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(child: Text(title, style: AppTextStyles.bodyLg, overflow: TextOverflow.ellipsis)),
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 14.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
              TextButton(onPressed: controller.logout, child: const Text('Logout', style: TextStyle(color: AppColors.primary))),
            ],
          ),
        );
      },
      child: Center(
        child: Text(
          'Logout',
          style: AppTextStyles.bodyLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
