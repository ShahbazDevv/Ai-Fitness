class UserModel {
  final String id;
  final String email;
  final String fullName;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final double goalWeight;
  final String activityLevel;
  final String fitnessGoal;
  final String experienceLevel;
  final String medicalNotes;
  final String profilePictureUrl;
  final bool isPremium;
  final double bodyFatPercentage;
  final int dailyCalories;
  final int dailyProtein;
  final int dailyWaterGoal;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.age = 25,
    this.gender = 'Male',
    this.height = 175.0,
    this.weight = 70.0,
    this.goalWeight = 75.0,
    this.activityLevel = 'Moderate',
    this.fitnessGoal = 'Muscle Gain',
    this.experienceLevel = 'Intermediate',
    this.medicalNotes = 'None',
    this.profilePictureUrl = '',
    this.isPremium = false,
    this.bodyFatPercentage = 15.0,
    this.dailyCalories = 2400,
    this.dailyProtein = 180,
    this.dailyWaterGoal = 3000,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      age: json['age'] ?? 25,
      gender: json['gender'] ?? 'Male',
      height: (json['height'] ?? 175.0).toDouble(),
      weight: (json['weight'] ?? 70.0).toDouble(),
      goalWeight: (json['goal_weight'] ?? 75.0).toDouble(),
      activityLevel: json['activity_level'] ?? 'Moderate',
      fitnessGoal: json['fitness_goal'] ?? 'Muscle Gain',
      experienceLevel: json['experience_level'] ?? 'Intermediate',
      medicalNotes: json['medical_notes'] ?? 'None',
      profilePictureUrl: json['profile_picture_url'] ?? '',
      isPremium: json['is_premium'] ?? false,
      bodyFatPercentage: (json['body_fat_percentage'] ?? 15.0).toDouble(),
      dailyCalories: json['daily_calories'] ?? 2400,
      dailyProtein: json['daily_protein'] ?? 180,
      dailyWaterGoal: json['daily_water_goal'] ?? 3000,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'goal_weight': goalWeight,
      'activity_level': activityLevel,
      'fitness_goal': fitnessGoal,
      'experience_level': experienceLevel,
      'medical_notes': medicalNotes,
      'profile_picture_url': profilePictureUrl,
      'is_premium': isPremium,
      'body_fat_percentage': bodyFatPercentage,
      'daily_calories': dailyCalories,
      'daily_protein': dailyProtein,
      'daily_water_goal': dailyWaterGoal,
    };
  }

  UserModel copyWith({
    String? fullName,
    int? age,
    String? gender,
    double? height,
    double? weight,
    double? goalWeight,
    String? activityLevel,
    String? fitnessGoal,
    String? experienceLevel,
    String? medicalNotes,
    String? profilePictureUrl,
    bool? isPremium,
    double? bodyFatPercentage,
    int? dailyCalories,
    int? dailyProtein,
    int? dailyWaterGoal,
  }) {
    return UserModel(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      goalWeight: goalWeight ?? this.goalWeight,
      activityLevel: activityLevel ?? this.activityLevel,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      isPremium: isPremium ?? this.isPremium,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      dailyProtein: dailyProtein ?? this.dailyProtein,
      dailyWaterGoal: dailyWaterGoal ?? this.dailyWaterGoal,
    );
  }
}
