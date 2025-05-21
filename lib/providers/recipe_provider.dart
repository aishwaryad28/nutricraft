import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/models/recipe.dart';
import 'package:nutricraft/services/storage_service.dart';

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  final StorageService _storageService;
  
  RecipeNotifier(this._storageService) : super([]) {
    _loadRecipes();
  }
  
  Future<void> _loadRecipes() async {
    final recipes = await _storageService.getRecipes();
    state = recipes;
  }
  
  void toggleFavorite(String id) {
    state = state.map((recipe) {
      if (recipe.id == id) {
        return recipe.copyWith(isFavorite: !recipe.isFavorite);
      }
      return recipe;
    }).toList();
    _storageService.saveRecipes(state);
  }
}

final allRecipesProvider = StateNotifierProvider<RecipeNotifier, List<Recipe>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return RecipeNotifier(storageService);
});

final recommendedRecipesProvider = Provider<List<Recipe>>((ref) {
  final allRecipes = ref.watch(allRecipesProvider);
  // In a real app, this would use the user's preferences to filter recipes
  return allRecipes.take(5).toList();
});

// Mock data for user name
final userNameProvider = Provider<String>((ref) {
  return 'Alex';
});
