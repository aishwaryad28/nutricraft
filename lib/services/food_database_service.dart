import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/models/food_log.dart';

class FoodDatabaseService {
  // This would normally connect to a food database API
  // For now, we'll just return some mock data
  
  Future<List<FoodItem>> searchFood(String query) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Return mock results based on query
    return [
      FoodItem(
        name: 'Apple',
        calories: 95,
        protein: 0,
        carbs: 25,
        fats: 0,
        servingSize: 1,
        servingUnit: 'medium',
      ),
      FoodItem(
        name: 'Banana',
        calories: 105,
        protein: 1,
        carbs: 27,
        fats: 0,
        servingSize: 1,
        servingUnit: 'medium',
      ),
      FoodItem(
        name: 'Chicken Breast',
        calories: 165,
        protein: 31,
        carbs: 0,
        fats: 3,
        servingSize: 100,
        servingUnit: 'g',
      ),
      FoodItem(
        name: 'Brown Rice',
        calories: 215,
        protein: 5,
        carbs: 45,
        fats: 2,
        servingSize: 1,
        servingUnit: 'cup',
      ),
      FoodItem(
        name: 'Salmon',
        calories: 206,
        protein: 22,
        carbs: 0,
        fats: 13,
        servingSize: 100,
        servingUnit: 'g',
      ),
    ].where((item) => item.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}

class FoodItem {
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final double servingSize;
  final String servingUnit;
  
  FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.servingSize,
    required this.servingUnit,
  });
  
  FoodLog toFoodLog({
    required String id,
    required MealType mealType,
    required DateTime dateTime,
  }) {
    return FoodLog(
      id: id,
      foodName: name,
      calories: calories,
      servingSize: servingSize,
      servingUnit: servingUnit,
      mealType: mealType,
      dateTime: dateTime,
      protein: protein,
      carbs: carbs,
      fats: fats,
    );
  }
}

final foodDatabaseServiceProvider = Provider<FoodDatabaseService>((ref) {
  return FoodDatabaseService();
});
