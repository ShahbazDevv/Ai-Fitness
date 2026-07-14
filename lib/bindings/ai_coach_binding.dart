import 'package:get/get.dart';
import '../controllers/ai_coach_controller.dart';

class AiCoachBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiCoachController>(() => AiCoachController());
  }
}
