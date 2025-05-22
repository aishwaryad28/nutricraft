import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/models/food_log.dart';
import 'package:nutricraft/providers/food_log_provider.dart';

class NutritionData {
  final int protein;
  final int proteinGoal;
  final double proteinPercentage;
  
  final int carbs;
  final int carbsGoal;
  final double carbsPercentage;
  
  final int fats;
  final int fatsGoal;
  final double fatsPercentage;
  
  final int calories;
  final int caloriesGoal;
  final double caloriesPercentage;
  
  NutritionData({
    required this.protein,
    required this.proteinGoal,
    required this.proteinPercentage,
    required this.carbs,
    required this.carbsGoal,
    required this.carbsPercentage,
    required this.fats,
    required this.fatsGoal,
    required this.fatsPercentage,
    required this.calories,
    required this.caloriesGoal,
    required this.caloriesPercentage,
  });
}

// Using AutoDisposeFamilyProvider to ensure the provider is refreshed when the date changes
final nutritionProvider = Provider.autoDispose<NutritionData>((ref) {
  // Watch the food log provider to rebuild when logs change
  final foodLogs = ref.watch(foodLogProvider);
  
  // Filter logs for today
  final today = DateTime.now();
  final todayLogs = foodLogs.where((log) {
    return log.dateTime.year == today.year &&
           log.dateTime.month == today.month &&
           log.dateTime.day == today.day;
  }).toList();
  
  // Calculate totals
  int totalProtein = 0;
  int totalCarbs = 0;
  int totalFats = 0;
  int totalCalories = 0;
  
  for (final log in todayLogs) {
    totalProtein += log.protein;
    totalCarbs += log.carbs;
    totalFats += log.fats;
    totalCalories += log.calories;
  }
  
  // Goals (these would normally be calculated based on user profile)
  const proteinGoal = 120;
  const carbsGoal = 250;
  const fatsGoal = 65;
  const caloriesGoal = 2000;
  
  // Calculate percentages
  final proteinPercentage = totalProtein / proteinGoal;
  final carbsPercentage = totalCarbs / carbsGoal;
  final fatsPercentage = totalFats / fatsGoal;
  final caloriesPercentage = totalCalories / caloriesGoal;
  
  return NutritionData(
    protein: totalProtein,
    proteinGoal: proteinGoal,
    proteinPercentage: proteinPercentage.clamp(0.0, 1.0),
    carbs: totalCarbs,
    carbsGoal: carbsGoal,
    carbsPercentage: carbsPercentage.clamp(0.0, 1.0),
    fats: totalFats,
    fatsGoal: fatsGoal,
    fatsPercentage: fatsPercentage.clamp(0.0, 1.0),
    calories: totalCalories,
    caloriesGoal: caloriesGoal,
    caloriesPercentage: caloriesPercentage.clamp(0.0, 1.0),
  );
});
