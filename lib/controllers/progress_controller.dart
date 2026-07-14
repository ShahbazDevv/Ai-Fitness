import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/fitness_repository.dart';
import '../models/progress_model.dart';

class ProgressController extends GetxController {
  final FitnessRepository _fitnessRepo = FitnessRepository();

  final RxBool isLoading = true.obs;
  final RxList<WeightLogModel> weightLogs = <WeightLogModel>[].obs;
  final RxList<WaterLogModel> waterLogs = <WaterLogModel>[].obs;
  final Rxn<DailyActivityModel> activity = Rxn<DailyActivityModel>();

  // BMI Calculator State
  final heightController = TextEditingController(text: '175');
  final weightController = TextEditingController(text: '70');
  final RxDouble calculatedBmi = 0.0.obs;
  final RxString bmiStatus = ''.obs;

  // Computed metrics
  final RxList<double> ffmiHistory = <double>[].obs;
  final RxDouble estimatedBodyFat = 0.0.obs;
  final RxString bodyFatStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProgressData();
  }

  Future<void> fetchProgressData() async {
    isLoading.value = true;
    try {
      final date = DateTime.now().toIso8601String().substring(0, 10);
      final results = await Future.wait([
        _fitnessRepo.getWeightLogs(),
        _fitnessRepo.getWaterLogs(date),
        _fitnessRepo.getDailyActivity(),
      ]);

      weightLogs.value = results[0] as List<WeightLogModel>;
      waterLogs.value = results[1] as List<WaterLogModel>;
      activity.value = results[2] as DailyActivityModel;
      
      if (weightLogs.isNotEmpty) {
        calculatedBmi.value = weightLogs.last.bmi;
        _updateBmiStatus(calculatedBmi.value);
        _computeBodyFat();
        _computeFfmiHistory();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch progress data');
    } finally {
      isLoading.value = false;
    }
  }

  void calculateBmi() {
    final h = double.tryParse(heightController.text) ?? 0;
    final w = double.tryParse(weightController.text) ?? 0;

    if (h > 0 && w > 0) {
      final heightInMeters = h / 100;
      calculatedBmi.value = w / (heightInMeters * heightInMeters);
      _updateBmiStatus(calculatedBmi.value);
    }
  }

  void _updateBmiStatus(double bmi) {
    if (bmi < 18.5) {
      bmiStatus.value = 'Underweight';
    } else if (bmi < 25) {
      bmiStatus.value = 'Normal';
    } else if (bmi < 30) {
      bmiStatus.value = 'Overweight';
    } else {
      bmiStatus.value = 'Obese';
    }
  }

  void _computeBodyFat() {
    if (weightLogs.isEmpty) return;
    final bmi = weightLogs.last.bmi;
    estimatedBodyFat.value = (1.20 * bmi) + (0.23 * 30) - (10.8 * 1) - 5.4;
    if (estimatedBodyFat.value < 6) {
      bodyFatStatus.value = 'Essential Fat';
    } else if (estimatedBodyFat.value < 14) {
      bodyFatStatus.value = 'Athletic';
    } else if (estimatedBodyFat.value < 18) {
      bodyFatStatus.value = 'Fit';
    } else if (estimatedBodyFat.value < 25) {
      bodyFatStatus.value = 'Average';
    } else {
      bodyFatStatus.value = 'Above Average';
    }
  }

  void _computeFfmiHistory() {
    final height = double.tryParse(heightController.text) ?? 175;
    final heightInMeters = height / 100;
    ffmiHistory.value = weightLogs.map((log) {
      final bf = (1.20 * log.bmi) + (0.23 * 30) - (10.8 * 1) - 5.4;
      final fatMass = log.weight * bf / 100;
      final leanMass = log.weight - fatMass;
      return leanMass / (heightInMeters * heightInMeters);
    }).toList();
  }

  Future<void> saveWeightLog() async {
    final w = double.tryParse(weightController.text) ?? 0;
    if (w > 0) {
      await _fitnessRepo.logWeight(w, calculatedBmi.value);
      fetchProgressData();
      Get.back();
      Get.snackbar('Success', 'Weight logged successfully');
    }
  }

  @override
  void onClose() {
    heightController.dispose();
    weightController.dispose();
    super.onClose();
  }
}
