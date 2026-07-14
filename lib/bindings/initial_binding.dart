import 'package:get/get.dart';
import '../services/connectivity_service.dart';
import '../services/huggingface_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../services/supabase_service.dart';
import '../services/health_service.dart';
import '../services/ai/conversation_manager.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ConnectivityService(), permanent: true);
    Get.put(SupabaseService(), permanent: true);
    Get.put(HuggingFaceService(), permanent: true);
    Get.put(StorageService(), permanent: true);
    Get.put(NotificationService(), permanent: true);
    Get.put(HealthService(), permanent: true);
    Get.put(ConversationManager(), permanent: true);
  }
}
