import 'package:get/get.dart';
import '../controllers/fitness_controller.dart';

class FitnessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FitnessController>(() => FitnessController());
  }
}
