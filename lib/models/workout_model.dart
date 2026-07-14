class ExerciseModel {
  final String name;
  final int sets;
  final int reps;
  final int restSeconds;
  final String duration;
  final int caloriesBurned;
  final String equipmentNeeded;
  final String targetMuscle;

  ExerciseModel({
    required this.name,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    this.duration = '',
    this.caloriesBurned = 0,
    this.equipmentNeeded = 'Bodyweight',
    this.targetMuscle = '',
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      name: json['name'] ?? '',
      sets: json['sets'] ?? 3,
      reps: json['reps'] ?? 10,
      restSeconds: json['rest_seconds'] ?? 60,
      duration: json['duration'] ?? '',
      caloriesBurned: json['calories_burned'] ?? 0,
      equipmentNeeded: json['equipment_needed'] ?? 'Bodyweight',
      targetMuscle: json['target_muscle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'rest_seconds': restSeconds,
      'duration': duration,
      'calories_burned': caloriesBurned,
      'equipment_needed': equipmentNeeded,
      'target_muscle': targetMuscle,
    };
  }
}

class WorkoutModel {
  final String id;
  final String title;
  final String category; // BEGINNER, INTERMEDIATE, ADVANCED
  final String bodyPart; // Push, Pull, Legs, Full Body, Cardio
  final String duration;
  final int caloriesBurned;
  final int exercisesCount;
  final String imageUrl;
  final bool isAiRecommended;
  final List<ExerciseModel> exercises;

  WorkoutModel({
    required this.id,
    required this.title,
    required this.category,
    this.bodyPart = 'Full Body',
    required this.duration,
    required this.caloriesBurned,
    required this.exercisesCount,
    required this.imageUrl,
    this.isAiRecommended = false,
    required this.exercises,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    var list = json['exercises'] as List? ?? [];
    List<ExerciseModel> exercisesList = list.map((e) => ExerciseModel.fromJson(e)).toList();

    return WorkoutModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'BEGINNER',
      bodyPart: json['body_part'] ?? 'Full Body',
      duration: json['duration'] ?? '30 mins',
      caloriesBurned: json['calories_burned'] ?? 0,
      exercisesCount: json['exercises_count'] ?? exercisesList.length,
      imageUrl: json['image_url'] ?? '',
      isAiRecommended: json['is_ai_recommended'] ?? false,
      exercises: exercisesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'body_part': bodyPart,
      'duration': duration,
      'calories_burned': caloriesBurned,
      'exercises_count': exercisesCount,
      'image_url': imageUrl,
      'is_ai_recommended': isAiRecommended,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}
