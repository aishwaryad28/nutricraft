import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/models/recipe.dart';
import 'package:nutricraft/services/storage_service.dart';
import 'package:nutricraft/services/mock_data_service.dart';

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  final StorageService _storageService;
  final MockDataService _mockDataService = MockDataService();
  
  // Keep track of all available recipes
  List<Recipe> _allAvailableRecipes = [];
  
  // Current filter and search query
  String? _currentFilter;
  String _searchQuery = '';
  
  RecipeNotifier(this._storageService) : super([]) {
    _loadInitialRecipes();
  }
  
  Future<void> _loadInitialRecipes() async {
    final recipes = await _storageService.getRecipes();
    _allAvailableRecipes = recipes;
    state = recipes.take(10).toList(); // Initially load only first 10 recipes
  }
  
  // Load more recipes with pagination
  Future<bool> loadMoreRecipes(int page, int perPage) async {
    // Apply current filters and search
    List<Recipe> filteredRecipes = _getFilteredRecipes();
    
    // Calculate start and end indices for pagination
    final startIndex = (page - 1) * perPage;
    if (startIndex >= filteredRecipes.length) {
      return false; // No more recipes to load
    }
    
    final endIndex = startIndex + perPage;
    final recipesToAdd = filteredRecipes.sublist(
      startIndex, 
      endIndex > filteredRecipes.length ? filteredRecipes.length : endIndex
    );
    
    // If we're on page 1, replace state, otherwise add to it
    if (page == 1) {
      state = recipesToAdd;
    } else {
      state = [...state, ...recipesToAdd];
    }
    
    return recipesToAdd.isNotEmpty;
  }
  
  // Reset recipes (used when changing filters)
  void resetRecipes() {
    state = [];
  }
  
  // Filter recipes by tag
  void filterRecipesByTag(String? tag) {
    _currentFilter = tag;
    resetRecipes();
  }
  
  // Search recipes
  void searchRecipes(String query) {
    _searchQuery = query.toLowerCase();
    resetRecipes();
  }
  
  // Get filtered recipes based on current filter and search
  List<Recipe> _getFilteredRecipes() {
    return _allAvailableRecipes.where((recipe) {
      // Apply tag filter if set
      if (_currentFilter != null && _currentFilter != 'All') {
        if (!recipe.tags.contains(_currentFilter)) {
          return false;
        }
      }
      
      // Apply search filter if set
      if (_searchQuery.isNotEmpty) {
        return recipe.name.toLowerCase().contains(_searchQuery) ||
               recipe.description.toLowerCase().contains(_searchQuery) ||
               recipe.tags.any((tag) => tag.toLowerCase().contains(_searchQuery));
      }
      
      return true;
    }).toList();
  }
  
  // Generate more mock recipes for testing infinite scrolling
  Future<void> generateMoreMockRecipes() async {
    final newRecipes = _mockDataService.generateMoreMockRecipes(20); // Generate 20 more recipes
    _allAvailableRecipes = [..._allAvailableRecipes, ...newRecipes];
    await _storageService.saveRecipes(_allAvailableRecipes);
  }
  
  void toggleFavorite(String id) {
    // Update state
    state = state.map((recipe) {
      if (recipe.id == id) {
        return recipe.copyWith(isFavorite: !recipe.isFavorite);
      }
      return recipe;
    }).toList();
    
    // Also update _allAvailableRecipes
    _allAvailableRecipes = _allAvailableRecipes.map((recipe) {
      if (recipe.id == id) {
        return recipe.copyWith(isFavorite: !recipe.isFavorite);
      }
      return recipe;
    }).toList();
    
    _storageService.saveRecipes(_allAvailableRecipes);
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
