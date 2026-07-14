import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/supabase_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';
import '../services/huggingface_service.dart';
import '../services/notification_service.dart';

class SplashController extends GetxController {
  bool _hasNavigated = false;

  @override
  void onInit() {
    super.onInit();
    print('SplashController: onInit');
    _initAndNavigate();
    
    // Safety fallback: if we are still on splash after 15 seconds, force navigate to Login
    Future.delayed(const Duration(seconds: 15), () {
      if (!_hasNavigated) {
        print('SplashController: Safety fallback triggered (15s timeout)');
        _navigate(AppRoutes.login);
      }
    });
  }

  Future<void> _initAndNavigate() async {
    try {
      print('SplashController: Initializing services...');
      
      // Step 1: Initialize essential services
      // We wrap individual inits to track which one might be slow
      await Future.wait([
        _initService('Connectivity', () => Get.find<ConnectivityService>().init()),
        _initService('Supabase', () => Get.find<SupabaseService>().init()),
        _initService('HuggingFace', () => Get.find<HuggingFaceService>().init()),
        _initService('Storage', () => Get.find<StorageService>().init()),
        _initService('Notifications', () => Get.find<NotificationService>().init()),
      ]).timeout(const Duration(seconds: 12));

      print('SplashController: Services ready. Waiting 1.5s for branding.');
      await Future.delayed(const Duration(milliseconds: 1500));

      final supabase = Get.find<SupabaseService>();
      final storage = Get.find<StorageService>();
      
      final hasSeenOnboarding = storage.getBool('has_seen_onboarding') ?? false;
      final isLoggedIn = supabase.isAuthenticated.value;

      print('SplashController: State -> OnboardingSeen: $hasSeenOnboarding, LoggedIn: $isLoggedIn');

      if (!hasSeenOnboarding) {
        _navigate(AppRoutes.onboarding);
      } else if (isLoggedIn) {
        _navigate(AppRoutes.main);
      } else {
        _navigate(AppRoutes.login);
      }
    } catch (e) {
      print('SplashController: Initialization failed: $e');
      _navigate(AppRoutes.login);
    }
  }

  Future<void> _initService(String name, Future Function() initFn) async {
    try {
      print('SplashController: Starting $name init...');
      await initFn();
      print('SplashController: $name init complete.');
    } catch (e) {
      print('SplashController: $name init error: $e');
      // We don't rethrow here to allow other services to attempt init
    }
  }

  void _navigate(String route) {
    if (_hasNavigated) return;
    _hasNavigated = true;
    print('SplashController: Navigating to $route');
    Get.offAllNamed(route);
  }
}
