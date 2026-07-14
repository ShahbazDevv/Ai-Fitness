class MealModel {
  final String name;
  final String description;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final String imageUrl;

  MealModel({
    required this.name,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.imageUrl,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      calories: json['calories'] ?? 0,
      protein: json['protein'] ?? 0,
      carbs: json['carbs'] ?? 0,
      fats: json['fats'] ?? 0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'image_url': imageUrl,
    };
  }
}

class DietPlanModel {
  final String id;
  final String userId;
  final String date;
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFats;
  final int totalFiber;
  final MealModel breakfast;
  final MealModel morningSnack;
  final MealModel lunch;
  final MealModel eveningSnack;
  final MealModel dinner;
  final MealModel postWorkoutMeal;
  final bool isAiGenerated;

  DietPlanModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
    this.totalFiber = 25,
    required this.breakfast,
    required this.morningSnack,
    required this.lunch,
    required this.eveningSnack,
    required this.dinner,
    required this.postWorkoutMeal,
    this.isAiGenerated = true,
  });

  factory DietPlanModel.fromJson(Map<String, dynamic> json) {
    return DietPlanModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      date: json['date'] ?? '',
      totalCalories: json['total_calories'] ?? 0,
      totalProtein: json['total_protein'] ?? 0,
      totalCarbs: json['total_carbs'] ?? 0,
      totalFats: json['total_fats'] ?? 0,
      totalFiber: json['total_fiber'] ?? 25,
      breakfast: MealModel.fromJson(json['breakfast'] ?? {}),
      morningSnack: MealModel.fromJson(json['morning_snack'] ?? {}),
      lunch: MealModel.fromJson(json['lunch'] ?? {}),
      eveningSnack: MealModel.fromJson(json['evening_snack'] ?? {}),
      dinner: MealModel.fromJson(json['dinner'] ?? {}),
      postWorkoutMeal: MealModel.fromJson(json['post_workout_meal'] ?? {}),
      isAiGenerated: json['is_ai_generated'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'total_calories': totalCalories,
      'total_protein': totalProtein,
      'total_carbs': totalCarbs,
      'total_fats': totalFats,
      'total_fiber': totalFiber,
      'breakfast': breakfast.toJson(),
      'morning_snack': morningSnack.toJson(),
      'lunch': lunch.toJson(),
      'evening_snack': eveningSnack.toJson(),
      'dinner': dinner.toJson(),
      'post_workout_meal': postWorkoutMeal.toJson(),
      'is_ai_generated': isAiGenerated,
    };
  }
}
