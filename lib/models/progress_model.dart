class WaterLogModel {
  final String id;
  final String date;
  final int amountMl;

  WaterLogModel({
    required this.id,
    required this.date,
    required this.amountMl,
  });

  factory WaterLogModel.fromJson(Map<String, dynamic> json) {
    return WaterLogModel(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      amountMl: json['amount_ml'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'amount_ml': amountMl,
    };
  }
}

class WeightLogModel {
  final String id;
  final String date;
  final double weight;
  final double bmi;

  WeightLogModel({
    required this.id,
    required this.date,
    required this.weight,
    required this.bmi,
  });

  factory WeightLogModel.fromJson(Map<String, dynamic> json) {
    return WeightLogModel(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      weight: (json['weight'] ?? 70.0).toDouble(),
      bmi: (json['bmi'] ?? 22.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'weight': weight,
      'bmi': bmi,
    };
  }
}

class DailyActivityModel {
  final int steps;
  final int caloriesBurned;
  final int activeMinutes;
  final double distanceKm;

  DailyActivityModel({
    required this.steps,
    required this.caloriesBurned,
    required this.activeMinutes,
    required this.distanceKm,
  });

  factory DailyActivityModel.fromJson(Map<String, dynamic> json) {
    return DailyActivityModel(
      steps: json['steps'] ?? 0,
      caloriesBurned: json['calories_burned'] ?? 0,
      activeMinutes: json['active_minutes'] ?? 0,
      distanceKm: (json['distance_km'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'calories_burned': caloriesBurned,
      'active_minutes': activeMinutes,
      'distance_km': distanceKm,
    };
  }
}
