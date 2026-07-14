import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

class ConversationManager extends GetxService {
  final RxBool hasCheckedInToday = false.obs;
  final RxInt sleepHours = 7.obs;
  final RxInt energyLevel = 5.obs;
  final RxInt moodLevel = 5.obs;
  final RxInt sorenessLevel = 3.obs;
  final RxString painNotes = ''.obs;

  final List<String> _usedMotivations = [];
  final Set<String> _askedQuestions = {};

  static const List<String> _motivations = [
    "You're doing great! Every rep brings you closer to your goals.",
    "Consistency beats intensity. Show up today!",
    "Your future self will thank you for today's effort.",
    "Progress is progress, no matter how small. Keep going!",
    "Champions are made in the training, not the gym. You've got this!",
    "Your body can stand almost anything. It's your mind you need to convince.",
    "The only bad workout is the one that didn't happen.",
    "Small daily improvements lead to stunning results.",
    "You don't have to be extreme, just consistent.",
    "Your only competition is the person you were yesterday.",
    "Strength does not come from the body. It comes from the will.",
    "Push yourself because no one else is going to do it for you.",
    "The pain you feel today will be the strength you feel tomorrow.",
    "Discipline is doing what needs to be done, even when you don't want to.",
    "Your body achieves what your mind believes.",
  ];

  String getMotivation() {
    final available = _motivations.where((m) => !_usedMotivations.contains(m)).toList();
    if (available.isEmpty) {
      _usedMotivations.clear();
      final msg = _motivations[DateTime.now().millisecondsSinceEpoch % _motivations.length];
      _usedMotivations.add(msg);
      return msg;
    }
    final index = DateTime.now().millisecondsSinceEpoch % available.length;
    final msg = available[index];
    _usedMotivations.add(msg);
    return msg;
  }

  String getWorkoutCompleteMotivation() {
    final profile = Get.find<ProfileController>().userProfile.value;
    final name = profile?.fullName ?? '';
    final messages = [
      "Excellent work, $name! You just got stronger.",
      "Crushed it, $name! That's progress in the bank.",
      "Great session, $name! Your consistency is inspiring.",
      "Well done, $name! Your muscles are growing right now.",
      "Solid workout, $name! That's another step towards your goal.",
    ];
    return messages[DateTime.now().millisecondsSinceEpoch % messages.length];
  }

  String getWorkoutSkippedMotivation() {
    final messages = [
      "Rest is also part of progress. Make sure to hit your next session!",
      "No worries — one missed workout doesn't define your journey. Get back on track tomorrow!",
      "Listen to your body. Just make sure today's rest becomes tomorrow's energy.",
      "It's okay to take a break. Just don't make it a habit — consistency is key!",
    ];
    return messages[DateTime.now().millisecondsSinceEpoch % messages.length];
  }

  String getProteinGoalMotivation() {
    final messages = [
      "Protein goal smashed! Your muscles are getting the fuel they need.",
      "Great nutrition today! That protein is building serious muscle.",
      "Nailed your protein intake! Recovery will be top-notch.",
    ];
    return messages[DateTime.now().millisecondsSinceEpoch % messages.length];
  }

  String getWaterGoalMotivation() {
    final messages = [
      "Hydration goal complete! Your performance will thank you.",
      "Perfect hydration today! Every cell in your body is celebrating.",
      "Water goal achieved! Stay hydrated, stay strong.",
    ];
    return messages[DateTime.now().millisecondsSinceEpoch % messages.length];
  }

  String getWeightProgressMotivation(double startWeight, double currentWeight, double goalWeight) {
    final lost = startWeight - currentWeight;
    final remaining = currentWeight - goalWeight;
    if (lost > 0) {
      return "You've lost $lost kg! Keep the momentum going. Only ${remaining.abs()} kg to go!";
    } else if (currentWeight > startWeight) {
      return "You're gaining weight — that's great for muscle growth! Stay consistent with your training.";
    }
    return "Your weight is steady. Focus on body composition changes through training.";
  }

  String getConsistencyMotivation(int streak) {
    if (streak >= 7) {
      return "Incredible! $streak day streak! You're building an unstoppable habit.";
    } else if (streak >= 3) {
      return "$streak day streak and going strong! Keep showing up!";
    }
    return "Starting a streak? Day $streak — let's make it count!";
  }

  void markQuestionAsked(String question) {
    _askedQuestions.add(question.toLowerCase().trim());
  }

  bool hasQuestionBeenAsked(String question) {
    return _askedQuestions.contains(question.toLowerCase().trim());
  }

  void resetCheckIn() {
    hasCheckedInToday.value = false;
  }

  bool get shouldAskCheckIn {
    final now = DateTime.now();
    final hour = now.hour;
    return !hasCheckedInToday.value && hour >= 6 && hour <= 22;
  }
}
