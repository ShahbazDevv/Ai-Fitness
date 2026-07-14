import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../controllers/main_controller.dart';
import '../dashboard/dashboard_view.dart';
import '../workout/workout_view.dart';
import '../ai_coach/ai_coach_view.dart';
import '../progress/progress_view.dart';
import '../profile/profile_view.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const DashboardView(),
      const WorkoutView(),
      const AiCoachView(),
      const ProgressView(),
      const ProfileView(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        controller.onWillPop();
      },
      child: Scaffold(
        body: Obx(() => AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: IndexedStack(
            key: ValueKey(controller.selectedIndex.value),
            index: controller.selectedIndex.value,
            children: pages,
          ),
        )),
        bottomNavigationBar: Obx(() => Container(
          padding: EdgeInsets.only(top: 8.h),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.95),
            border: Border(top: BorderSide(color: AppColors.borderLight, width: 0.5)),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textMuted,
            selectedFontSize: 11.sp,
            unselectedFontSize: 11.sp,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            items: [
              _navItem(Icons.dashboard_rounded, Icons.dashboard_outlined, 'Home'),
              _navItem(Icons.fitness_center_rounded, Icons.fitness_center_outlined, 'Workouts'),
              _navItem(Icons.psychology_rounded, Icons.psychology_outlined, 'AI Coach'),
              _navItem(Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Progress'),
              _navItem(Icons.person_rounded, Icons.person_outline, 'Profile'),
            ].asMap().entries.map((e) {
              final idx = e.key;
              final item = e.value;
              final isSelected = controller.selectedIndex.value == idx;
              return BottomNavigationBarItem(
                icon: Icon(isSelected ? item.$1 : item.$2, size: 24.r),
                label: item.$3,
              );
            }).toList(),
          ),
        )),
      ),
    );
  }

  (IconData, IconData, String) _navItem(IconData filled, IconData outlined, String label) {
    return (filled, outlined, label);
  }
}
