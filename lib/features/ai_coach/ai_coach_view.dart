import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_images.dart';
import '../../controllers/ai_coach_controller.dart';
import '../../widgets/ai_chat_bubble.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/custom_image.dart';


class AiCoachView extends GetView<AiCoachController> {
  const AiCoachView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Blurred fitness background
          Positioned.fill(
            child: Image.asset(
              AppImages.gymWorkout,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: AppColors.background.withValues(alpha: 0.85)),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && controller.messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }

                  if (controller.messages.isEmpty) {
                    return _buildEmptyState();
                  }

                  return Column(
                    children: [
                      _buildCheckInBanner(),
                      Expanded(
                        child: ListView.builder(
                          controller: controller.scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                          itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == controller.messages.length) {
                              return _buildTypingIndicator();
                            }
                            final message = controller.messages[index];
                            return AiChatBubble(
                              text: message.text,
                              isUser: message.isUser,
                              timestamp: message.timestamp,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
              _buildMessageInput(),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundImage: CustomImageProvider.get(AppImages.aiCoach),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI Coach', style: AppTextStyles.titleMd.copyWith(fontSize: 16.sp)),
              Row(
                children: [
                  Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text('Always Active', style: AppTextStyles.bodySm.copyWith(fontSize: 10.sp, color: Colors.green)),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.delete_sweep_outlined, size: 20.sp),
          onPressed: () => _showClearChatDialog(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: Icon(Icons.psychology_rounded, size: 64.sp, color: AppColors.primary),
            ),
            SizedBox(height: 24.h),
            Text(
              'How can I help you today?',
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMd,
            ),
            SizedBox(height: 12.h),
            Text(
              'Ask me about workout adjustments, nutrition tips, or recovery advice.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySm,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInBanner() {
    return Obx(() {
      if (!controller.showCheckIn.value) return const SizedBox.shrink();
      return Container(
        margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: AppColors.redGradient,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.fact_check_rounded, color: Colors.white, size: 20.sp),
                SizedBox(width: 8.w),
                Text('Daily Check-In', style: AppTextStyles.titleMd.copyWith(color: Colors.white, fontSize: 16.sp)),
                const Spacer(),
                GestureDetector(
                  onTap: () => controller.showCheckIn.value = false,
                  child: Icon(Icons.close, color: Colors.white70, size: 18.sp),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              "How did you sleep? | Energy (1-10) | Mood (1-10) | Soreness (1-10) | Pain notes?",
              style: AppTextStyles.bodySm.copyWith(color: Colors.white70, fontSize: 11.sp),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40.h,
                    child: TextField(
                      controller: controller.checkInController,
                      style: AppTextStyles.bodySm.copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'e.g. 8 | 7 | 8 | 3 | none',
                        hintStyle: TextStyle(color: Colors.white38, fontSize: 11.sp),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.15),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendCheckIn(),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: _sendCheckIn,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_rounded, color: AppColors.primary, size: 20.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _sendCheckIn() {
    final text = controller.checkInController.text.trim();
    if (text.isEmpty) return;
    controller.sendMessage(isCheckIn: true);
    controller.checkInController.clear();
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14.r,
            backgroundImage: CustomImageProvider.get(AppImages.aiCoach),
          ),
          SizedBox(width: 8.w),
          GlassCard(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            borderRadius: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) => TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 600 + index * 200),
                builder: (context, value, child) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: 6.r,
                    height: 6.r,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.4 + value * 0.6),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 24.h, top: 12.h),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              style: AppTextStyles.bodyLg.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Ask your coach...',
                filled: true,
                fillColor: AppColors.surface.withValues(alpha: 0.5),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => controller.sendMessage(),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: controller.sendMessage,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.redGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Icon(Icons.send_rounded, color: Colors.white, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Clear Chat History?', style: AppTextStyles.titleMd),
        content: Text('This will permanently delete all messages with your AI Coach.', style: AppTextStyles.bodySm),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              controller.clearChat();
              Get.back();
            },
            child: Text('Clear', style: AppTextStyles.bodySm.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
