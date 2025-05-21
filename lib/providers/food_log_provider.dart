import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/models/food_log.dart';
import 'package:nutricraft/services/storage_service.dart';

class FoodLogNotifier extends StateNotifier<List<FoodLog>> {
  final StorageService _storageService;
  
  FoodLogNotifier(this._storageService) : super([]) {
    _loadFoodLogs();
  }
  
  Future<void> _loadFoodLogs() async {
    final logs = await _storageService.getFoodLogs();
    state = logs;
  }
  
  Future<void> addFoodLog(FoodLog foodLog) async {
    state = [...state, foodLog];
    await _storageService.saveFoodLogs(state);
  }
  
  Future<void> updateFoodLog(FoodLog updatedLog) async {
    state = state.map((log) {
      if (log.id == updatedLog.id) {
        return updatedLog;
      }
      return log;
    }).toList();
    await _storageService.saveFoodLogs(state);
  }
  
  Future<void> deleteFoodLog(String id) async {
    state = state.where((log) => log.id != id).toList();
    await _storageService.saveFoodLogs(state);
  }
}

final foodLogProvider = StateNotifierProvider<FoodLogNotifier, List<FoodLog>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return FoodLogNotifier(storageService);
});
