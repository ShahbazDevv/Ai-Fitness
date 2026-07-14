import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../repositories/ai_repository.dart';
import '../routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class AiScanController extends GetxController {
  final AiRepository _aiRepo = AiRepository();
  final ImagePicker _picker = ImagePicker();

  final Rxn<File> frontImage = Rxn<File>();
  final Rxn<File> sideImage = Rxn<File>();
  final Rxn<File> backImage = Rxn<File>();

  final RxBool isAnalyzing = false.obs;
  final Rxn<Map<String, dynamic>> analysisResult = Rxn<Map<String, dynamic>>();

  // Computed metrics
  final RxDouble computedBmi = 0.0.obs;
  final RxDouble computedFfmi = 0.0.obs;
  final RxDouble computedLeanBodyMass = 0.0.obs;
  final RxDouble computedBodyFat = 0.0.obs;

  Future<void> pickImage(String position) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (image != null) {
      final file = File(image.path);
      switch (position) {
        case 'front':
          frontImage.value = file;
          break;
        case 'side':
          sideImage.value = file;
          break;
        case 'back':
          backImage.value = file;
          break;
      }
    }
  }

  bool get canAnalyze => frontImage.value != null && sideImage.value != null && backImage.value != null;

  void _calculateMetrics() {
    final profile = Get.find<ProfileController>().userProfile.value;
    if (profile == null) return;

    final heightMeters = profile.height / 100;
    final weight = profile.weight;

    // BMI
    computedBmi.value = weight / (heightMeters * heightMeters);

    // Body Fat (from analysis result or profile)
    final rawBodyFat = analysisResult.value?['bodyFat']?.toString() ?? '';
    final numericBodyFat = double.tryParse(rawBodyFat.replaceAll('%', '')) ?? profile.bodyFatPercentage;
    computedBodyFat.value = numericBodyFat;

    // Lean Body Mass
    final lbm = weight * (1 - numericBodyFat / 100);
    computedLeanBodyMass.value = lbm;

    // Adjusted FFMI
    final rawFfmi = lbm / (heightMeters * heightMeters);
    computedFfmi.value = rawFfmi + 6.1 * (1.8 - heightMeters);
  }

  Future<void> startAnalysis() async {
    if (!canAnalyze) return;

    isAnalyzing.value = true;
    try {
      final result = await _aiRepo.submitBodyScan(
        front: frontImage.value!,
        side: sideImage.value!,
        back: backImage.value!,
      );

      // Parse and clean numeric values
      final cleanedResult = <String, dynamic>{};
      result.forEach((key, value) {
        if (value is String) {
          cleanedResult[key] = value.replaceAll('%', '').replaceAll('kg', '').trim();
        } else {
          cleanedResult[key] = value;
        }
      });
      cleanedResult['bmi'] = computedBmi.value.toStringAsFixed(1);
      cleanedResult['ffmi'] = computedFfmi.value.toStringAsFixed(1);
      cleanedResult['leanBodyMass'] = computedLeanBodyMass.value.toStringAsFixed(1);

      analysisResult.value = cleanedResult;
      _calculateMetrics();

      Get.toNamed(AppRoutes.aiAnalysisResult);
    } catch (e) {
      Get.snackbar('Error', 'Failed to analyze body scan');
    } finally {
      isAnalyzing.value = false;
    }
  }

  void reset() {
    frontImage.value = null;
    sideImage.value = null;
    backImage.value = null;
    analysisResult.value = null;
    computedBmi.value = 0.0;
    computedFfmi.value = 0.0;
    computedLeanBodyMass.value = 0.0;
    computedBodyFat.value = 0.0;
  }
}
