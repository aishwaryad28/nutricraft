import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/theme/app_theme.dart';
import 'package:nutricraft/models/recipe.dart';
import 'package:nutricraft/providers/recipe_provider.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final Recipe recipe;
  
  const RecipeDetailScreen({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'recipe-image-${recipe.id}',
                child: Image.asset(
                  recipe.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: AppColors.white.withOpacity(0.7),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.charcoalGray),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              CircleAvatar(
                backgroundColor: AppColors.white.withOpacity(0.7),
                child: IconButton(
                  icon: Icon(
                    recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: recipe.isFavorite ? Colors.red : AppColors.charcoalGray,
                  ),
                  onPressed: () {
                    ref.read(allRecipesProvider.notifier).toggleFavorite(recipe.id);
                  },
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppColors.white.withOpacity(0.7),
                child: IconButton(
                  icon: const Icon(Icons.share, color: AppColors.charcoalGray),
                  onPressed: () {
                    // TODO: Share recipe
                  },
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          
          // Recipe content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and tags
                  Text(
                    recipe.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recipe.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: AppColors.lightLavender,
                        padding: EdgeInsets.zero,
                        labelStyle: const TextStyle(fontSize: 12),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Recipe info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(
                        context,
                        Icons.timer,
                        '${recipe.cookingTime} min',
                        'Cooking Time',
                      ),
                      _buildInfoItem(
                        context,
                        Icons.restaurant,
                        '${recipe.servings}',
                        'Servings',
                      ),
                      _buildInfoItem(
                        context,
                        Icons.local_fire_department,
                        '${recipe.calories} kcal',
                        'Per Serving',
                      ),
                      _buildInfoItem(
                        context,
                        Icons.fitness_center,
                        '${recipe.protein}g',
                        'Protein',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Nutritional info
                  Text(
                    'Nutritional Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNutrientInfo('Protein', '${recipe.protein}g', AppColors.pastelPeach),
                          _buildNutrientInfo('Carbs', '${recipe.carbs}g', AppColors.lightLavender),
                          _buildNutrientInfo('Fats', '${recipe.fats}g', AppColors.skyBlue),
                          _buildNutrientInfo('Fiber', '${recipe.fiber}g', AppColors.pastelGreen),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Ingredients
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...recipe.ingredients.map((ingredient) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.fiber_manual_record,
                            size: 12,
                            color: AppColors.pastelPeach,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(ingredient),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 24),
                  
                  // Instructions
                  Text(
                    'Instructions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(recipe.instructions.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.pastelPeach,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              recipe.instructions[index],
                              style: const TextStyle(height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                  
                  // Cook now button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Start cooking mode
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Start Cooking'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Add to meal plan button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Add to meal plan
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Add to Meal Plan'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoItem(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.pastelPeach,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.charcoalGray.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
  
  Widget _buildNutrientInfo(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.charcoalGray.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
