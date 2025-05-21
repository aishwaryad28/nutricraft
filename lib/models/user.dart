class User {
  final String id;
  final String name;
  final String email;
  final double height;
  final double weight;
  final String gender;
  final DateTime birthDate;
  final List<String> dietaryPreferences;
  final List<String> allergies;
  final String fitnessGoal;
  final String activityLevel;
  final int daysActive;
  final int recipesCooked;
  final int achievements;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.height,
    required this.weight,
    required this.gender,
    required this.birthDate,
    required this.dietaryPreferences,
    required this.allergies,
    required this.fitnessGoal,
    required this.activityLevel,
    required this.daysActive,
    required this.recipesCooked,
    required this.achievements,
  });
  
  User copyWith({
    String? id,
    String? name,
    String? email,
    double? height,
    double? weight,
    String? gender,
    DateTime? birthDate,
    List<String>? dietaryPreferences,
    List<String>? allergies,
    String? fitnessGoal,
    String? activityLevel,
    int? daysActive,
    int? recipesCooked,
    int? achievements,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      allergies: allergies ?? this.allergies,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      activityLevel: activityLevel ?? this.activityLevel,
      daysActive: daysActive ?? this.daysActive,
      recipesCooked: recipesCooked ?? this.recipesCooked,
      achievements: achievements ?? this.achievements,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'height': height,
      'weight': weight,
      'gender': gender,
      'birthDate': birthDate.toIso8601String(),
      'dietaryPreferences': dietaryPreferences,
      'allergies': allergies,
      'fitnessGoal': fitnessGoal,
      'activityLevel': activityLevel,
      'daysActive': daysActive,
      'recipesCooked': recipesCooked,
      'achievements': achievements,
    };
  }
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      height: json['height'],
      weight: json['weight'],
      gender: json['gender'],
      birthDate: DateTime.parse(json['birthDate']),
      dietaryPreferences: List<String>.from(json['dietaryPreferences']),
      allergies: List<String>.from(json['allergies']),
      fitnessGoal: json['fitnessGoal'],
      activityLevel: json['activityLevel'],
      daysActive: json['daysActive'],
      recipesCooked: json['recipesCooked'],
      achievements: json['achievements'],
    );
  }
}
