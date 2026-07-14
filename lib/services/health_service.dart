import 'package:health/health.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService extends GetxService {
  final Health _health = Health();

  static const List<HealthDataType> types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.WORKOUT,
  ];

  final permissions = types.map((e) => HealthDataAccess.READ).toList();

  Future<bool> requestPermissions() async {
    // Request permission_handler permissions first for Android
    await [
      Permission.activityRecognition,
      Permission.location,
    ].request();

    bool? hasPermissions = await _health.hasPermissions(types, permissions: permissions);
    
    if (hasPermissions != true) {
      hasPermissions = await _health.requestAuthorization(types, permissions: permissions);
    }
    
    return hasPermissions ?? false;
  }

  Future<Map<String, double>> fetchTodayStats() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      bool authorized = await requestPermissions();
      if (!authorized) return {};

      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: types,
      );

      double steps = 0;
      double calories = 0;
      double distance = 0;
      double activeMinutes = 0;

      for (var point in healthData) {
        final value = double.tryParse(point.value.toString()) ?? 0;
        switch (point.type) {
          case HealthDataType.STEPS:
            steps += value;
            break;
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            calories += value;
            break;
          case HealthDataType.DISTANCE_DELTA:
            distance += value;
            break;
          case HealthDataType.WORKOUT:
            // Calculate duration from dateTo and dateFrom
            activeMinutes += point.dateTo.difference(point.dateFrom).inMinutes;
            break;
          default:
            break;
        }
      }

      // Sometimes steps are also recorded in intervals, but Health package usually handles aggregation if using getHealthDataFromTypes
      // For more accurate daily steps:
      int? dailySteps = await _health.getTotalStepsInInterval(midnight, now);
      if (dailySteps != null) steps = dailySteps.toDouble();

      return {
        'steps': steps,
        'calories': calories,
        'distance': distance / 1000, // convert to km
        'activeMinutes': activeMinutes,
      };
    } catch (e) {
      print('HealthService error: $e');
      return {};
    }
  }
}
