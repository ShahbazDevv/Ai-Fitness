import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/dashboard_controller.dart';

class PromptBuilder {
  static const String _baseSystemPrompt = """
You are a premium AI Personal Fitness Coach. You are an expert certified personal trainer with deep knowledge of exercise science, nutrition, and physiology.

## CORE RULES
1. NEVER respond like a generic chatbot. Always personalize responses.
2. NEVER diagnose diseases or provide medical advice.
3. If the user reports chest pain, severe pain, dizziness, or serious injury, advise them to consult a healthcare professional immediately.
4. NEVER recommend the same muscle group on consecutive days unless the user specifically requests it.
5. Base all recommendations on the user's actual data provided below.
6. Be motivational but honest. Celebrate wins, give constructive feedback.
7. Keep responses concise and actionable.

## USER PROFILE
{user_profile}

## BODY SCAN DATA
{body_scan}

## WORKOUT CONTEXT
{workout_context}

## NUTRITION CONTEXT
{nutrition_context}

## HYDRATION CONTEXT
{hydration_context}

## RECENT CONVERSATION
{conversation_history}

## YOUR RESPONSE
""";

  String buildSystemPrompt() {
    final profile = _getUserProfile();
    final bodyScan = _getBodyScanData();
    final workout = _getWorkoutContext();
    final nutrition = _getNutritionContext();
    final hydration = _getHydrationContext();

    return _baseSystemPrompt
        .replaceAll('{user_profile}', _formatUserProfile(profile))
        .replaceAll('{body_scan}', bodyScan)
        .replaceAll('{workout_context}', workout)
        .replaceAll('{nutrition_context}', nutrition)
        .replaceAll('{hydration_context}', hydration)
        .replaceAll('{conversation_history}', '');
  }

  String buildWorkoutPrompt(String userRequest, String availableTime, String location, String equipment) {
    final profile = _getUserProfile();
    return """
Generate a complete workout with these constraints:
- User: ${profile?.fullName ?? 'User'}
- Goal: ${profile?.fitnessGoal ?? 'General Fitness'}
- Experience: ${profile?.experienceLevel ?? 'Intermediate'}
- Available time: $availableTime
- Location: $location
- Equipment available: $equipment
- Request: $userRequest

Provide: exercise name, sets, reps, rest time, and brief form tips.
""";
  }

  UserModel? _getUserProfile() {
    if (!Get.isRegistered<ProfileController>()) return null;
    return Get.find<ProfileController>().userProfile.value;
  }

  String _formatUserProfile(UserModel? user) {
    if (user == null) return 'No profile data available.';
    return """
Name: ${user.fullName}
Age: ${user.age}
Gender: ${user.gender}
Height: ${user.height} cm
Weight: ${user.weight} kg
Goal Weight: ${user.goalWeight} kg
Fitness Goal: ${user.fitnessGoal}
Activity Level: ${user.activityLevel}
Experience Level: ${user.experienceLevel}
Daily Calories Target: ${user.dailyCalories} kcal
Daily Protein Target: ${user.dailyProtein}g
Daily Water Goal: ${user.dailyWaterGoal}ml
""";
  }

  String _getBodyScanData() {
    if (!Get.isRegistered<DashboardController>()) return 'No body scan data available.';
    final dc = Get.find<DashboardController>();
    return """
BMI: ${dc.bmi.value.toStringAsFixed(1)}
Body Fat: ${dc.bodyFatPercentage.value.toStringAsFixed(1)}%
FFMI: ${dc.ffmi.value.toStringAsFixed(1)}
Lean Body Mass: ${dc.leanBodyMass.value.toStringAsFixed(1)} kg
Muscle Category: ${dc.muscleCategory.value}
""";
  }

  String _getWorkoutContext() {
    final dc = Get.find<DashboardController>();
    if (dc.recommendedWorkouts.isEmpty) return 'No recent workout data.';
    final w = dc.recommendedWorkouts.first;
    return """
Today's Recommended: ${w.title} (${w.duration}, ${w.caloriesBurned} kcal)
Exercises: ${w.exercises.length} movements
""";
  }

  String _getNutritionContext() {
    final dc = Get.find<DashboardController>();
    final diet = dc.todayDietPlan.value;
    if (diet == null) return 'No nutrition data logged today.';
    return """
Today's Intake: ${diet.totalCalories} kcal, ${diet.totalProtein}g protein, ${diet.totalCarbs}g carbs, ${diet.totalFats}g fats
Meals: ${diet.breakfast.name}, ${diet.lunch.name}, ${diet.dinner.name}
""";
  }

  String _getHydrationContext() {
    final dc = Get.find<DashboardController>();
    return """
Water: ${dc.waterIntake.value}ml of ${dc.dailyWaterGoal.value}ml goal
""";
  }
}
