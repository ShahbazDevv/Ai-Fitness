import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';

class NotificationService extends GetxService {
  final RxList<Map<String, dynamic>> activeNotifications = <Map<String, dynamic>>[].obs;
  SharedPreferences? _prefs;

  Future<NotificationService> init() async {
    try {
      _prefs = await SharedPreferences.getInstance().timeout(const Duration(seconds: 5));
    } catch (e) {
      print('NotificationService init error: $e');
    }
    _loadLocalNotifications();
    return this;
  }

  void _loadLocalNotifications() {
    // Standard starting alerts matching Stitch specs
    activeNotifications.value = [
      {
        'id': '1',
        'title': 'Morning Sprint Complete!',
        'body': 'You burned 450 kcal today. Keep it up!',
        'time': 'Today, 07:30 AM',
        'type': 'activity'
      },
      {
        'id': '2',
        'title': 'Hydration Reminder',
        'body': 'Time to drink some water. Drink 250ml now to stay on track.',
        'time': 'Today, 10:00 AM',
        'type': 'water'
      },
      {
        'id': '3',
        'title': 'AI Coach Advice',
        'body': 'Your recovery is high today. Ready to crush your Upper Body session?',
        'time': 'Yesterday, 06:00 PM',
        'type': 'coach'
      }
    ];
  }

  Future<void> sendNotification(String title, String body, String type) async {
    final newNotif = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'body': body,
      'time': 'Just now',
      'type': type
    };
    activeNotifications.insert(0, newNotif);
    
    // Trigger in-app UI feedback using GetX snackbar
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.surface.withValues(alpha: 0.85),
      colorText: AppColors.textPrimary,
      borderRadius: 16,
      borderColor: AppColors.primary.withValues(alpha: 0.3),
      borderWidth: 1,
    );
  }

  /// Check if a preference key exists (utility for reminders)
  bool hasPreference(String key) => _prefs?.containsKey(key) ?? false;

  Future<void> clearAll() async {
    activeNotifications.clear();
  }

  Future<void> deleteNotification(String id) async {
    activeNotifications.removeWhere((n) => n['id'] == id);
  }
}
