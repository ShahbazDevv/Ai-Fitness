import 'package:get/get.dart';
import 'app_routes.dart';
import '../features/splash/splash_view.dart';
import '../bindings/main_binding.dart';
import '../features/main/main_view.dart';
import '../bindings/splash_binding.dart';
import '../features/onboarding/onboarding_view.dart';
import '../bindings/onboarding_binding.dart';
import '../features/auth/login_view.dart';
import '../features/auth/register_view.dart';
import '../features/auth/forgot_password_view.dart';
import '../bindings/auth_binding.dart';
import '../features/dashboard/dashboard_view.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/ai_scan_binding.dart';
import '../features/workout/workout_view.dart';
import '../bindings/fitness_binding.dart';
import '../features/diet/diet_view.dart';
import '../features/ai_coach/ai_coach_view.dart';
import '../bindings/ai_coach_binding.dart';
import '../features/ai_scan/ai_body_scan_view.dart';
import '../features/ai_scan/ai_analysis_result_view.dart';
import '../features/water/water_tracker_view.dart';
import '../bindings/progress_binding.dart';
import '../features/bmi/bmi_calculator_view.dart';
import '../features/progress/progress_view.dart';
import '../features/activity/daily_activity_view.dart';
import '../features/notifications/notifications_view.dart';
import '../features/profile/profile_view.dart';
import '../bindings/profile_binding.dart';
import '../features/profile/edit_profile_view.dart';
import '../features/settings/settings_view.dart';
import '../bindings/settings_binding.dart';
import '../features/premium/premium_view.dart';
import '../features/support/support_view.dart';
import '../features/support/privacy_view.dart';
import '../features/support/about_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.aiCoachChat,
      page: () => const AiCoachView(),
      binding: AiCoachBinding(),
    ),
    GetPage(
      name: AppRoutes.aiBodyScan,
      page: () => const AiBodyScanView(),
      binding: AiScanBinding(),
    ),
    GetPage(
      name: AppRoutes.aiAnalysisResult,
      page: () => const AiAnalysisResultView(),
      binding: AiScanBinding(),
    ),
    GetPage(
      name: AppRoutes.workoutPlan,
      page: () => const WorkoutView(),
      binding: FitnessBinding(),
    ),
    GetPage(
      name: AppRoutes.dietPlan,
      page: () => const DietView(),
      binding: FitnessBinding(),
    ),
    GetPage(
      name: AppRoutes.waterTracker,
      page: () => const WaterTrackerView(),
      binding: ProgressBinding(),
    ),
    GetPage(
      name: AppRoutes.bmiCalculator,
      page: () => const BmiCalculatorView(),
      binding: ProgressBinding(),
    ),
    GetPage(
      name: AppRoutes.progress,
      page: () => const ProgressView(),
      binding: ProgressBinding(),
    ),
    GetPage(
      name: AppRoutes.dailyActivity,
      page: () => const DailyActivityView(),
      binding: ProgressBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.premium,
      page: () => const PremiumView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.support,
      page: () => const SupportView(),
    ),
    GetPage(
      name: AppRoutes.privacy,
      page: () => const PrivacyView(),
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutView(),
    ),
  ];
}
