import 'package:get/get.dart';
import '../repositories/fitness_repository.dart';
import '../models/workout_model.dart';
import '../models/diet_model.dart';
import '../models/progress_model.dart';
import '../services/health_service.dart';
import '../controllers/profile_controller.dart';

class DashboardController extends GetxController {
  final FitnessRepository _fitnessRepo = FitnessRepository();
  final HealthService _healthService = Get.find<HealthService>();

  final RxBool isLoading = true.obs;
  final RxBool isHealthAvailable = true.obs;
  
  // Data Observables
  final Rx<DailyActivityModel> dailyActivity = DailyActivityModel(steps: 0, caloriesBurned: 0, activeMinutes: 0, distanceKm: 0).obs;
  final RxList<WorkoutModel> recommendedWorkouts = <WorkoutModel>[].obs;
  final Rxn<DietPlanModel> todayDietPlan = Rxn<DietPlanModel>();
  final RxInt waterIntake = 0.obs;

  // Body Metrics
  final RxDouble ffmi = 0.0.obs;
  final RxDouble leanBodyMass = 0.0.obs;
  final RxDouble bmi = 0.0.obs;
  final RxDouble bodyFatPercentage = 0.0.obs;
  final RxString muscleCategory = 'Normal'.obs;
  final RxString bmiStatus = ''.obs;

  // Daily Nutrition Goals (from user profile)
  final RxInt dailyCaloriesGoal = 2400.obs;
  final RxInt dailyProteinGoal = 180.obs;
  final RxInt dailyWaterGoal = 3000.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    
    // Recalculate FFMI when profile changes
    ever(Get.find<ProfileController>().userProfile, (_) => _calculateMetrics());
  }

  void _calculateMetrics() {
    final user = Get.find<ProfileController>().userProfile.value;
    if (user == null) return;

    final weight = user.weight;
    final heightMeters = user.height / 100;
    final bodyFat = user.bodyFatPercentage / 100;

    // BMI = Weight(kg) / Height(m)^2
    bmi.value = weight / (heightMeters * heightMeters);
    _updateBmiStatus(bmi.value);

    // Lean Body Mass (kg) = Weight * (1 - Body Fat %)
    leanBodyMass.value = weight * (1 - bodyFat);

    // FFMI = Lean Body Mass / (Height * Height)
    double rawFfmi = leanBodyMass.value / (heightMeters * heightMeters);

    // Adjusted FFMI for height (common formula: FFMI + 6.1 * (1.8 - height))
    ffmi.value = rawFfmi + 6.1 * (1.8 - heightMeters);

    bodyFatPercentage.value = user.bodyFatPercentage;

    _updateMuscleCategory(ffmi.value);

    // Nutrition goals from profile
    dailyCaloriesGoal.value = user.dailyCalories;
    dailyProteinGoal.value = user.dailyProtein;
    dailyWaterGoal.value = user.dailyWaterGoal;
  }

  void _updateBmiStatus(double bmiValue) {
    if (bmiValue < 18.5) {
      bmiStatus.value = 'Underweight';
    } else if (bmiValue < 25) {
      bmiStatus.value = 'Normal';
    } else if (bmiValue < 30) {
      bmiStatus.value = 'Overweight';
    } else {
      bmiStatus.value = 'Obese';
    }
  }

  void _updateMuscleCategory(double value) {
    if (value < 18) {
      muscleCategory.value = 'Below Average';
    } else if (value < 20) {
      muscleCategory.value = 'Average';
    } else if (value < 22) {
      muscleCategory.value = 'Above Average';
    } else if (value < 25) {
      muscleCategory.value = 'Excellent';
    } else {
      muscleCategory.value = 'Superior/Pro';
    }
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      final date = DateTime.now().toIso8601String().substring(0, 10);
      
      // Parallel fetching with timeout
      final results = await Future.wait([
        _healthService.fetchTodayStats(),
        _fitnessRepo.getWorkouts(),
        _fitnessRepo.getDietPlan(date),
        _fitnessRepo.getWaterLogs(date),
      ]).timeout(const Duration(seconds: 15));

      final healthData = results[0] as Map<String, double>;
      if (healthData.isNotEmpty) {
        dailyActivity.value = DailyActivityModel(
          steps: healthData['steps']?.toInt() ?? 0,
          caloriesBurned: healthData['calories']?.toInt() ?? 0,
          activeMinutes: healthData['activeMinutes']?.toInt() ?? 0,
          distanceKm: healthData['distance'] ?? 0.0,
        );
        isHealthAvailable.value = true;
      } else {
        // Fallback to repo if health fails or permissions denied
        final activity = await _fitnessRepo.getDailyActivity();
        dailyActivity.value = activity;
        isHealthAvailable.value = false;
      }
      
      if (results[1] is List<WorkoutModel>) {
        final allWorkouts = results[1] as List<WorkoutModel>;
        final profile = Get.find<ProfileController>().userProfile.value;
        final goal = profile?.fitnessGoal ?? '';
        final level = profile?.experienceLevel ?? '';

        List<WorkoutModel> candidates = [];

        if (goal.contains('Loss') || goal.contains('Fat')) {
          candidates = allWorkouts.where((w) =>
            w.title.toLowerCase().contains('full body') ||
            w.category == 'BEGINNER' ||
            w.bodyPart == 'Full Body'
          ).toList();
        } else if (goal.contains('Gain') || goal == 'Hypertrophy') {
          candidates = allWorkouts.where((w) =>
            w.isAiRecommended ||
            w.bodyPart == 'Push' ||
            w.bodyPart == 'Pull'
          ).toList();
        } else {
          candidates = allWorkouts.where((w) => w.isAiRecommended).toList();
        }

        if (level == 'Beginner' && candidates.isNotEmpty) {
          candidates.sort((a, b) {
            final aOrder = a.category == 'BEGINNER' ? 0 : 1;
            final bOrder = b.category == 'BEGINNER' ? 0 : 1;
            return aOrder.compareTo(bOrder);
          });
        }

        if (candidates.isEmpty) {
          candidates = allWorkouts.where((w) => w.isAiRecommended).toList();
        }

        if (candidates.isEmpty && allWorkouts.isNotEmpty) {
          candidates = [allWorkouts.first];
        }

        recommendedWorkouts.value = candidates;
      }

      if (results[2] != null && results[2] is DietPlanModel) {
        todayDietPlan.value = results[2] as DietPlanModel;
      }
      
      if (results[3] != null && results[3] is List<WaterLogModel>) {
        final waterLogs = results[3] as List<WaterLogModel>;
        waterIntake.value = waterLogs.fold(0, (sum, log) => sum + log.amountMl);
      }

    } catch (e) {
      print('Error loading dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addWater(int amountMl) async {
    final date = DateTime.now().toIso8601String().substring(0, 10);
    try {
      await _fitnessRepo.logWater(date, amountMl);
      waterIntake.value += amountMl;
    } catch (e) {
      Get.snackbar('Error', 'Failed to log water');
    }
  }
}
