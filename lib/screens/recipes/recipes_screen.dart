import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/theme/app_theme.dart';
import 'package:nutricraft/models/recipe.dart';
import 'package:nutricraft/providers/recipe_provider.dart';
import 'package:nutricraft/widgets/recipe_card.dart';
import 'package:nutricraft/screens/recipes/recipe_detail_screen.dart';

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  // Scroll controller for infinite scrolling
  final ScrollController _scrollController = ScrollController();
  
  // Pagination state
  bool _isLoading = false;
  bool _hasMoreRecipes = true;
  int _currentPage = 1;
  final int _recipesPerPage = 10;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Add scroll listener for infinite scrolling
    _scrollController.addListener(_scrollListener);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
  
  // Scroll listener for infinite scrolling
  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoading &&
        _hasMoreRecipes) {
      _loadMoreRecipes();
    }
  }
  
  // Load more recipes
  Future<void> _loadMoreRecipes() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Load more recipes
    final success = await ref.read(allRecipesProvider.notifier).loadMoreRecipes(_currentPage, _recipesPerPage);
    
    setState(() {
      _isLoading = false;
      if (success) {
        _currentPage++;
      } else {
        _hasMoreRecipes = false;
      }
    });
  }
  
  // Reset pagination when filter changes
  void _resetPagination() {
    setState(() {
      _currentPage = 1;
      _hasMoreRecipes = true;
    });
    ref.read(allRecipesProvider.notifier).resetRecipes();
    _loadMoreRecipes();
  }
  
  void _searchRecipes(String query) {
    // Reset pagination when search query changes
    _resetPagination();
    ref.read(allRecipesProvider.notifier).searchRecipes(query);
  }
  
  @override
  Widget build(BuildContext context) {
    final allRecipes = ref.watch(allRecipesProvider);
    final recommendedRecipes = ref.watch(recommendedRecipesProvider);
    final quickRecipes = allRecipes.where((recipe) => recipe.cookingTime <= 15).toList();
    final favoriteRecipes = allRecipes.where((recipe) => recipe.isFavorite).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'For You'),
            Tab(text: 'Quick'),
            Tab(text: 'All'),
            Tab(text: 'Favorites'),
          ],
          labelColor: AppColors.pastelPeach,
          unselectedLabelColor: AppColors.charcoalGray.withOpacity(0.7),
          indicatorColor: AppColors.pastelPeach,
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
              onChanged: _searchRecipes,
            ),
          ),
          
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Vegetarian'),
                _buildFilterChip('Vegan'),
                _buildFilterChip('Gluten-Free'),
                _buildFilterChip('Low-Carb'),
                _buildFilterChip('High-Protein'),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRecipeGrid(recommendedRecipes),
                _buildRecipeGrid(quickRecipes),
                _buildRecipeGrid(allRecipes),
                _buildRecipeGrid(favoriteRecipes),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: label == 'All',
        onSelected: (selected) {
          // Apply filter and reset pagination
          _resetPagination();
          ref.read(allRecipesProvider.notifier).filterRecipesByTag(label == 'All' ? null : label);
        },
        backgroundColor: AppColors.white,
        selectedColor: AppColors.pastelPeach,
        checkmarkColor: AppColors.charcoalGray,
      ),
    );
  }
  
  Widget _buildRecipeGrid(List<Recipe> recipes) {
    if (recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: AppColors.charcoalGray.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No recipes found',
              style: TextStyle(
                color: AppColors.charcoalGray.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    return GridView.builder(
      controller: _scrollController, // Add scroll controller for infinite scrolling
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: recipes.length + (_isLoading && _tabController.index == 2 ? 1 : 0), // Add loading indicator if loading more
      itemBuilder: (context, index) {
        // Show loading indicator at the end
        if (index == recipes.length && _isLoading && _tabController.index == 2) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        // Show recipe card
        return RecipeCard(
          recipe: recipes[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(recipe: recipes[index]),
              ),
            );
          },
        );
      },
    );
  }
}
