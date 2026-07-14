import 'package:get/get.dart';
import '../models/workout_model.dart';
import '../models/diet_model.dart';
import '../models/progress_model.dart';
import '../services/supabase_service.dart';
import '../constants/app_images.dart';

class FitnessRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  // Fetch Workout Plans
  Future<List<WorkoutModel>> getWorkouts() async {
    if (_supabase.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      return [
        WorkoutModel(
          id: '1',
          title: 'Push — Chest & Shoulders',
          bodyPart: 'Push',
          category: 'INTERMEDIATE',
          duration: '55 mins',
          caloriesBurned: 520,
          exercisesCount: 8,
          imageUrl: AppImages.workoutSquat,
          isAiRecommended: true,
          exercises: [
            ExerciseModel(name: 'Barbell Bench Press', sets: 4, reps: 8, restSeconds: 120, equipmentNeeded: 'Barbell & Bench', targetMuscle: 'Chest'),
            ExerciseModel(name: 'Incline Dumbbell Press', sets: 3, reps: 10, restSeconds: 90, equipmentNeeded: 'Dumbbells', targetMuscle: 'Chest'),
            ExerciseModel(name: 'Cable Flyes', sets: 3, reps: 15, restSeconds: 60, equipmentNeeded: 'Cables', targetMuscle: 'Chest'),
            ExerciseModel(name: 'Push Ups', sets: 3, reps: 20, restSeconds: 60, equipmentNeeded: 'Bodyweight', targetMuscle: 'Chest'),
            ExerciseModel(name: 'Military Press', sets: 4, reps: 8, restSeconds: 90, equipmentNeeded: 'Barbell', targetMuscle: 'Shoulders'),
            ExerciseModel(name: 'Lateral Raises', sets: 3, reps: 15, restSeconds: 60, equipmentNeeded: 'Dumbbells', targetMuscle: 'Shoulders'),
            ExerciseModel(name: 'Front Raises', sets: 3, reps: 12, restSeconds: 45, equipmentNeeded: 'Dumbbells', targetMuscle: 'Shoulders'),
            ExerciseModel(name: 'Tricep Pushdowns', sets: 3, reps: 12, restSeconds: 45, equipmentNeeded: 'Cables', targetMuscle: 'Triceps'),
          ],
        ),
        WorkoutModel(
          id: '2',
          title: 'Pull — Back & Biceps',
          bodyPart: 'Pull',
          category: 'INTERMEDIATE',
          duration: '50 mins',
          caloriesBurned: 440,
          exercisesCount: 8,
          imageUrl: AppImages.gymWorkout,
          isAiRecommended: true,
          exercises: [
            ExerciseModel(name: 'Deadlifts', sets: 4, reps: 6, restSeconds: 180, equipmentNeeded: 'Barbell', targetMuscle: 'Back'),
            ExerciseModel(name: 'Lat Pull Downs', sets: 3, reps: 10, restSeconds: 90, equipmentNeeded: 'Cables', targetMuscle: 'Back'),
            ExerciseModel(name: 'Seated Rows', sets: 3, reps: 12, restSeconds: 60, equipmentNeeded: 'Cables', targetMuscle: 'Back'),
            ExerciseModel(name: 'Face Pulls', sets: 3, reps: 15, restSeconds: 45, equipmentNeeded: 'Cables', targetMuscle: 'Rear Delts'),
            ExerciseModel(name: 'Barbell Curls', sets: 3, reps: 10, restSeconds: 60, equipmentNeeded: 'Barbell', targetMuscle: 'Biceps'),
            ExerciseModel(name: 'Dumbbell Hammer Curls', sets: 3, reps: 12, restSeconds: 45, equipmentNeeded: 'Dumbbells', targetMuscle: 'Biceps'),
            ExerciseModel(name: 'Concentration Curls', sets: 3, reps: 12, restSeconds: 45, equipmentNeeded: 'Dumbbells', targetMuscle: 'Biceps'),
            ExerciseModel(name: 'Reverse Flyes', sets: 3, reps: 15, restSeconds: 45, equipmentNeeded: 'Dumbbells', targetMuscle: 'Rear Delts'),
          ],
        ),
        WorkoutModel(
          id: '3',
          title: 'Legs — Quad Dominant',
          bodyPart: 'Legs',
          category: 'ADVANCED',
          duration: '65 mins',
          caloriesBurned: 620,
          exercisesCount: 8,
          imageUrl: AppImages.workoutSquat,
          isAiRecommended: true,
          exercises: [
            ExerciseModel(name: 'Barbell Squats', sets: 5, reps: 5, restSeconds: 180, equipmentNeeded: 'Barbell', targetMuscle: 'Quads'),
            ExerciseModel(name: 'Leg Press', sets: 4, reps: 10, restSeconds: 90, equipmentNeeded: 'Machine', targetMuscle: 'Quads'),
            ExerciseModel(name: 'Leg Extensions', sets: 3, reps: 15, restSeconds: 60, equipmentNeeded: 'Machine', targetMuscle: 'Quads'),
            ExerciseModel(name: 'Romanian Deadlifts', sets: 4, reps: 8, restSeconds: 120, equipmentNeeded: 'Barbell', targetMuscle: 'Hamstrings'),
            ExerciseModel(name: 'Leg Curls', sets: 3, reps: 12, restSeconds: 60, equipmentNeeded: 'Machine', targetMuscle: 'Hamstrings'),
            ExerciseModel(name: 'Walking Lunges', sets: 3, reps: 12, restSeconds: 45, equipmentNeeded: 'Dumbbells', targetMuscle: 'Glutes'),
            ExerciseModel(name: 'Calf Raises', sets: 4, reps: 15, restSeconds: 45, equipmentNeeded: 'Machine', targetMuscle: 'Calves'),
            ExerciseModel(name: 'Bulgarian Split Squats', sets: 3, reps: 10, restSeconds: 60, equipmentNeeded: 'Dumbbells', targetMuscle: 'Glutes'),
          ],
        ),
        WorkoutModel(
          id: '4',
          title: 'Push — Chest & Triceps',
          bodyPart: 'Push',
          category: 'BEGINNER',
          duration: '40 mins',
          caloriesBurned: 350,
          exercisesCount: 6,
          imageUrl: AppImages.dumbbell,
          exercises: [
            ExerciseModel(name: 'Dumbbell Bench Press', sets: 3, reps: 10, restSeconds: 90, equipmentNeeded: 'Dumbbells', targetMuscle: 'Chest'),
            ExerciseModel(name: 'Incline Dumbbell Press', sets: 3, reps: 10, restSeconds: 60, equipmentNeeded: 'Dumbbells', targetMuscle: 'Chest'),
            ExerciseModel(name: 'Dumbbell Flyes', sets: 3, reps: 12, restSeconds: 60, equipmentNeeded: 'Dumbbells', targetMuscle: 'Chest'),
            ExerciseModel(name: 'Overhead Tricep Extension', sets: 3, reps: 12, restSeconds: 45, equipmentNeeded: 'Dumbbell', targetMuscle: 'Triceps'),
            ExerciseModel(name: 'Skull Crushers', sets: 3, reps: 12, restSeconds: 45, equipmentNeeded: 'Barbell', targetMuscle: 'Triceps'),
            ExerciseModel(name: 'Tricep Dips', sets: 3, reps: 10, restSeconds: 60, equipmentNeeded: 'Bodyweight', targetMuscle: 'Triceps'),
          ],
        ),
        WorkoutModel(
          id: '5',
          title: 'Pull — Back Focus',
          bodyPart: 'Pull',
          category: 'BEGINNER',
          duration: '45 mins',
          caloriesBurned: 380,
          exercisesCount: 6,
          imageUrl: AppImages.gymWorkout,
          exercises: [
            ExerciseModel(name: 'Lat Pull Downs', sets: 3, reps: 10, restSeconds: 90, equipmentNeeded: 'Cables', targetMuscle: 'Back'),
            ExerciseModel(name: 'Seated Cable Rows', sets: 3, reps: 12, restSeconds: 60, equipmentNeeded: 'Cables', targetMuscle: 'Back'),
            ExerciseModel(name: 'Dumbbell Rows', sets: 3, reps: 10, restSeconds: 60, equipmentNeeded: 'Dumbbells', targetMuscle: 'Back'),
            ExerciseModel(name: 'Dumbbell Curls', sets: 3, reps: 12, restSeconds: 45, equipmentNeeded: 'Dumbbells', targetMuscle: 'Biceps'),
            ExerciseModel(name: 'Preacher Curls', sets: 3, reps: 10, restSeconds: 45, equipmentNeeded: 'Barbell', targetMuscle: 'Biceps'),
            ExerciseModel(name: 'Rear Delt Flyes', sets: 3, reps: 15, restSeconds: 45, equipmentNeeded: 'Dumbbells', targetMuscle: 'Rear Delts'),
          ],
        ),
        WorkoutModel(
          id: '6',
          title: 'Legs — Hamstring & Glute',
          bodyPart: 'Legs',
          category: 'INTERMEDIATE',
          duration: '50 mins',
          caloriesBurned: 480,
          exercisesCount: 6,
          imageUrl: AppImages.workoutSquat,
          exercises: [
            ExerciseModel(name: 'Romanian Deadlifts', sets: 4, reps: 8, restSeconds: 120, equipmentNeeded: 'Barbell', targetMuscle: 'Hamstrings'),
            ExerciseModel(name: 'Hip Thrusts', sets: 4, reps: 10, restSeconds: 90, equipmentNeeded: 'Barbell', targetMuscle: 'Glutes'),
            ExerciseModel(name: 'Leg Curls', sets: 3, reps: 12, restSeconds: 60, equipmentNeeded: 'Machine', targetMuscle: 'Hamstrings'),
            ExerciseModel(name: 'Goblet Squats', sets: 3, reps: 12, restSeconds: 60, equipmentNeeded: 'Dumbbell', targetMuscle: 'Quads'),
            ExerciseModel(name: 'Calf Raises', sets: 4, reps: 15, restSeconds: 45, equipmentNeeded: 'Machine', targetMuscle: 'Calves'),
            ExerciseModel(name: 'Step Ups', sets: 3, reps: 10, restSeconds: 45, equipmentNeeded: 'Bench', targetMuscle: 'Glutes'),
          ],
        ),
        WorkoutModel(
          id: '7',
          title: 'Full Body — Metabolic',
          bodyPart: 'Full Body',
          category: 'BEGINNER',
          duration: '35 mins',
          caloriesBurned: 400,
          exercisesCount: 5,
          imageUrl: AppImages.dashboard,
          exercises: [
            ExerciseModel(name: 'Kettlebell Swings', sets: 3, reps: 15, restSeconds: 45, equipmentNeeded: 'Kettlebell', targetMuscle: 'Full Body'),
            ExerciseModel(name: 'Burpees', sets: 3, reps: 10, restSeconds: 30, equipmentNeeded: 'Bodyweight', targetMuscle: 'Full Body'),
            ExerciseModel(name: 'Dumbbell Thrusters', sets: 3, reps: 12, restSeconds: 45, equipmentNeeded: 'Dumbbells', targetMuscle: 'Full Body'),
            ExerciseModel(name: 'Mountain Climbers', sets: 3, reps: 20, restSeconds: 30, equipmentNeeded: 'Bodyweight', targetMuscle: 'Core'),
            ExerciseModel(name: 'Plank', sets: 3, reps: 45, restSeconds: 30, equipmentNeeded: 'Bodyweight', targetMuscle: 'Core'),
          ],
        ),
      ];
    }
    // Real Supabase Fetch Implementation
    try {
      final response = await _supabase.client.from('workout_plans').select().timeout(const Duration(seconds: 10));
      return (response as List).map((x) => WorkoutModel.fromJson(x)).toList();
    } catch (e) {
      print('FitnessRepository: getWorkouts error: $e');
      return [];
    }
  }

  // Fetch Diet Plan for a specific date
  Future<DietPlanModel?> getDietPlan(String date) async {
    if (_supabase.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      return DietPlanModel(
        id: 'diet_1',
        userId: 'user_1',
        date: date,
        totalCalories: 2800,
        totalProtein: 210,
        totalCarbs: 320,
        totalFats: 80,
        totalFiber: 35,
        breakfast: MealModel(
          name: 'Protein Oat Bowl',
          description: 'Steel-cut oats, whey isolate, mixed berries, and chia seeds.',
          calories: 450,
          protein: 35,
          carbs: 55,
          fats: 12,
          imageUrl: AppImages.dietOatbowl,
        ),
        morningSnack: MealModel(
          name: 'Greek Yogurt & Almonds',
          description: 'Greek yogurt with raw almonds and honey.',
          calories: 300,
          protein: 25,
          carbs: 20,
          fats: 15,
          imageUrl: AppImages.dietOatbowl,
        ),
        lunch: MealModel(
          name: 'Grilled Chicken & Rice',
          description: 'Grilled chicken breast with basmati rice and steamed broccoli.',
          calories: 750,
          protein: 55,
          carbs: 80,
          fats: 15,
          imageUrl: AppImages.dietOatbowl,
        ),
        eveningSnack: MealModel(
          name: 'Protein Bar',
          description: 'Low sugar whey protein bar.',
          calories: 200,
          protein: 20,
          carbs: 25,
          fats: 8,
          imageUrl: AppImages.dietOatbowl,
        ),
        dinner: MealModel(
          name: 'Seared Salmon',
          description: 'Salmon fillet with sweet potato mash and asparagus.',
          calories: 850,
          protein: 60,
          carbs: 65,
          fats: 25,
          imageUrl: AppImages.dietOatbowl,
        ),
        postWorkoutMeal: MealModel(
          name: 'Whey Shake & Banana',
          description: 'Whey protein isolate and one large banana.',
          calories: 250,
          protein: 30,
          carbs: 30,
          fats: 2,
          imageUrl: AppImages.dietOatbowl,
        ),
      );
    }
    try {
      final response = await _supabase.client
          .from('diet_plans')
          .select()
          .eq('date', date)
          .maybeSingle()
          .timeout(const Duration(seconds: 10));
      if (response != null) {
        return DietPlanModel.fromJson(response);
      }
      return null;
    } catch (e) {
      print('FitnessRepository: getDietPlan error: $e');
      return null;
    }
  }

  // Hydration tracking
  Future<List<WaterLogModel>> getWaterLogs(String date) async {
    if (_supabase.isMockMode) {
      return [
        WaterLogModel(id: 'w1', date: date, amountMl: 250),
        WaterLogModel(id: 'w2', date: date, amountMl: 500),
      ];
    }
    try {
      final response = await _supabase.client
          .from('water_logs')
          .select()
          .eq('date', date)
          .timeout(const Duration(seconds: 10));
      return (response as List).map((x) => WaterLogModel.fromJson(x)).toList();
    } catch (e) {
      print('FitnessRepository: getWaterLogs error: $e');
      return [];
    }
  }

  Future<void> logWater(String date, int amountMl) async {
    if (_supabase.isMockMode) return;
    try {
      await _supabase.client.from('water_logs').insert({
        'date': date,
        'amount_ml': amountMl,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Weight logs
  Future<List<WeightLogModel>> getWeightLogs() async {
    if (_supabase.isMockMode) {
      return [
        WeightLogModel(id: 'we1', date: '2026-07-05', weight: 75.8, bmi: 22.6),
        WeightLogModel(id: 'we2', date: '2026-07-07', weight: 75.3, bmi: 22.4),
        WeightLogModel(id: 'we3', date: '2026-07-09', weight: 75.0, bmi: 22.4),
      ];
    }
    try {
      final response = await _supabase.client
          .from('weight_logs')
          .select()
          .order('date', ascending: true)
          .timeout(const Duration(seconds: 10));
      return (response as List).map((x) => WeightLogModel.fromJson(x)).toList();
    } catch (e) {
      print('FitnessRepository: getWeightLogs error: $e');
      return [];
    }
  }

  Future<void> logWeight(double weight, double bmi) async {
    if (_supabase.isMockMode) return;
    try {
      final userId = _supabase.currentUser.value?.id;
      if (userId == null) return;
      await _supabase.client.from('weight_logs').insert({
        'user_id': userId,
        'date': DateTime.now().toIso8601String().substring(0, 10),
        'weight': weight,
        'bmi': bmi,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Daily activity log
  Future<DailyActivityModel> getDailyActivity() async {
    if (_supabase.isMockMode) {
      return DailyActivityModel(
        steps: 8450,
        caloriesBurned: 520,
        activeMinutes: 45,
        distanceKm: 5.8,
      );
    }
    try {
      final dateStr = DateTime.now().toIso8601String().substring(0, 10);
      final response = await _supabase.client
          .from('daily_activity')
          .select()
          .eq('date', dateStr)
          .maybeSingle()
          .timeout(const Duration(seconds: 10));
      if (response != null) {
        return DailyActivityModel.fromJson(response);
      }
      return DailyActivityModel(steps: 0, caloriesBurned: 0, activeMinutes: 0, distanceKm: 0);
    } catch (e) {
      print('FitnessRepository: getDailyActivity error: $e');
      return DailyActivityModel(steps: 0, caloriesBurned: 0, activeMinutes: 0, distanceKm: 0);
    }
  }
}
