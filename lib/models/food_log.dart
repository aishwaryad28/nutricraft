enum MealType {
  breakfast,
  lunch,
  dinner,
  snack,
}

class FoodLog {
  final String id;
  final String foodName;
  final int calories;
  final double servingSize;
  final String servingUnit;
  final MealType mealType;
  final DateTime dateTime;
  final int protein;
  final int carbs;
  final int fats;
  
  FoodLog({
    required this.id,
    required this.foodName,
    required this.calories,
    required this.servingSize,
    required this.servingUnit,
    required this.mealType,
    required this.dateTime,
    required this.protein,
    required this.carbs,
    required this.fats,
  });
  
  FoodLog copyWith({
    String? id,
    String? foodName,
    int? calories,
    double? servingSize,
    String? servingUnit,
    MealType? mealType,
    DateTime? dateTime,
    int? protein,
    int? carbs,
    int? fats,
  }) {
    return FoodLog(
      id: id ?? this.id,
      foodName: foodName ?? this.foodName,
      calories: calories ?? this.calories,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      mealType: mealType ?? this.mealType,
      dateTime: dateTime ?? this.dateTime,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodName': foodName,
      'calories': calories,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
      'mealType': mealType.toString(),
      'dateTime': dateTime.toIso8601String(),
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    };
  }
  
  factory FoodLog.fromJson(Map<String, dynamic> json) {
    return FoodLog(
      id: json['id'],
      foodName: json['foodName'],
      calories: json['calories'],
      servingSize: json['servingSize'],
      servingUnit: json['servingUnit'],
      mealType: MealType.values.firstWhere(
        (e) => e.toString() == json['mealType'],
        orElse: () => MealType.snack,
      ),
      dateTime: DateTime.parse(json['dateTime']),
      protein: json['protein'],
      carbs: json['carbs'],
      fats: json['fats'],
    );
  }
}
