import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutricraft/models/food_log.dart';
import 'package:nutricraft/models/recipe.dart';
import 'package:nutricraft/models/user.dart';

import 'package:nutricraft/services/mock_data_service.dart';

class StorageService {
  static const String _foodLogsKey = 'food_logs';
  static const String _recipesKey = 'recipes';
  static const String _userKey = 'user';
  static const String _notificationSettingsKey = 'notification_settings';
  
  final MockDataService _mockDataService = MockDataService();
  
  // Food Logs
  Future<List<FoodLog>> getFoodLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? foodLogsJson = prefs.getString(_foodLogsKey);
    
    if (foodLogsJson == null) {
      // Return mock data for initial setup
      return _mockDataService.getMockFoodLogs();
    }
    
    final List<dynamic> decodedJson = jsonDecode(foodLogsJson);
    return decodedJson.map((json) => FoodLog.fromJson(json)).toList();
  }
  
  Future<void> saveFoodLogs(List<FoodLog> foodLogs) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = foodLogs.map((log) => log.toJson()).toList();
    await prefs.setString(_foodLogsKey, jsonEncode(jsonList));
  }
  
  // Recipes
  Future<List<Recipe>> getRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? recipesJson = prefs.getString(_recipesKey);
    
    if (recipesJson == null) {
      // Return mock data for initial setup
      return _mockDataService.getMockRecipes();
    }
    
    final List<dynamic> decodedJson = jsonDecode(recipesJson);
    return decodedJson.map((json) => Recipe.fromJson(json)).toList();
  }
  
  Future<void> saveRecipes(List<Recipe> recipes) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = recipes.map((recipe) => recipe.toJson()).toList();
    await prefs.setString(_recipesKey, jsonEncode(jsonList));
  }
  
  // User
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(_userKey);
    
    if (userJson == null) {
      return null;
    }
    
    return User.fromJson(jsonDecode(userJson));
  }
  
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
  
  // Notification Settings
  
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});
