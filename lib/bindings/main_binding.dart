import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/fitness_controller.dart';
import '../controllers/ai_coach_controller.dart';
import '../controllers/progress_controller.dart';
import '../controllers/profile_controller.dart';
import '../services/ai/ai_coach_service.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
    Get.put(FitnessController());
    Get.put(AiCoachService(), permanent: true);
    Get.put(AiCoachController());
    Get.put(ProgressController());
  }
}
