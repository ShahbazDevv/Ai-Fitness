import 'package:get/get.dart';
import '../repositories/fitness_repository.dart';
import '../models/workout_model.dart';
import '../models/diet_model.dart';

class FitnessController extends GetxController {
  final FitnessRepository _fitnessRepo = FitnessRepository();

  final RxBool isLoading = true.obs;
  final RxList<WorkoutModel> workouts = <WorkoutModel>[].obs;
  final RxString selectedBodyPart = 'All'.obs;
  final Rxn<DietPlanModel> dietPlan = Rxn<DietPlanModel>();

  @override
  void onInit() {
    super.onInit();
    fetchFitnessData();
  }

  Future<void> fetchFitnessData() async {
    isLoading.value = true;
    try {
      final date = DateTime.now().toIso8601String().substring(0, 10);
      final results = await Future.wait([
        _fitnessRepo.getWorkouts(),
        _fitnessRepo.getDietPlan(date),
      ]);

      workouts.value = results[0] as List<WorkoutModel>;
      dietPlan.value = results[1] as DietPlanModel;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch fitness data');
    } finally {
      isLoading.value = false;
    }
  }
}
