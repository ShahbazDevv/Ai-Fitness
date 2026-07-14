import 'package:get/get.dart';
import '../controllers/ai_scan_controller.dart';

class AiScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiScanController>(() => AiScanController());
  }
}
