import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../services/notification_service.dart';
import '../../widgets/glass_card.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = Get.find<NotificationService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => notificationService.clearAll(),
            child: Text('Clear All', style: AppTextStyles.bodySm.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      body: Obx(() {
        if (notificationService.activeNotifications.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          itemCount: notificationService.activeNotifications.length,
          itemBuilder: (context, index) {
            final notification = notificationService.activeNotifications[index];
            return _buildNotificationTile(notification, notificationService);
          },
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 64.sp, color: AppColors.textMuted),
          SizedBox(height: 16.h),
          Text('No notifications yet', style: AppTextStyles.titleMd.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification, NotificationService service) {
    IconData icon;
    Color color;

    switch (notification['type']) {
      case 'activity':
        icon = Icons.fitness_center_rounded;
        color = AppColors.primary;
        break;
      case 'water':
        icon = Icons.local_drink_rounded;
        color = Colors.blueAccent;
        break;
      case 'coach':
        icon = Icons.psychology_rounded;
        color = Colors.purpleAccent;
        break;
      default:
        icon = Icons.notifications_rounded;
        color = AppColors.primary;
    }

    return Dismissible(
      key: Key(notification['id']),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => service.deleteNotification(notification['id']),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
      ),
      child: GlassCard(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification['title'], style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                  SizedBox(height: 4.h),
                  Text(notification['body'], style: AppTextStyles.bodySm.copyWith(color: AppColors.textSecondary), overflow: TextOverflow.ellipsis, maxLines: 2),
                  SizedBox(height: 8.h),
                  Text(notification['time'], style: AppTextStyles.labelCaps.copyWith(fontSize: 9.sp, color: AppColors.textMuted), overflow: TextOverflow.ellipsis, maxLines: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
