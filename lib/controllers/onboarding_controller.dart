import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class OnboardingController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<Map<String, String>> pages = [
    {
      'title': 'AI-Powered\nWorkouts',
      'subtitle': 'Get personalized workout plans crafted by artificial intelligence based on your body type, fitness goals, and experience level.',
      'icon': 'fitness_center',
      'color': 'primary',
    },
    {
      'title': 'Smart Nutrition\nTracking',
      'subtitle': 'AI-generated meal plans with macro tracking. Optimize your diet for muscle gain, fat loss, or maintenance with precision.',
      'icon': 'restaurant_menu',
      'color': 'orange',
    },
    {
      'title': 'Body Analysis\n& Coaching',
      'subtitle': 'Upload body photos for AI vision analysis. Get real-time coaching, progress insights, and adaptive recommendations.',
      'icon': 'psychology',
      'color': 'blue',
    },
  ];

  IconData getIcon(String name) {
    switch (name) {
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'restaurant_menu':
        return Icons.restaurant_menu_rounded;
      case 'psychology':
        return Icons.psychology_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  Color getColor(String name) {
    switch (name) {
      case 'primary':
        return const Color(0xFFFF3B30);
      case 'orange':
        return Colors.orangeAccent;
      case 'blue':
        return Colors.blueAccent;
      default:
        return const Color(0xFFFF3B30);
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skipToEnd() {
    completeOnboarding();
  }

  void completeOnboarding() {
    _storage.setBool('has_seen_onboarding', true);
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
