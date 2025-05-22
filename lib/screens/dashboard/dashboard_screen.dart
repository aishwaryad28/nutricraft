import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/theme/app_theme.dart';
import 'package:nutricraft/widgets/nutrition_ring.dart';
import 'package:nutricraft/widgets/recipe_card.dart';
import 'package:nutricraft/models/recipe.dart';
import 'package:nutricraft/providers/recipe_provider.dart';
import 'package:nutricraft/providers/nutrition_provider.dart';
import 'package:nutricraft/widgets/achievement_card.dart';
import 'package:nutricraft/providers/theme_provider.dart';
import 'package:nutricraft/providers/user_provider.dart';
import 'package:nutricraft/screens/recipes/recipe_detail_screen.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendedRecipes = ref.watch(recommendedRecipesProvider);
    final nutritionData = ref.watch(nutritionProvider);
    final themeMode = ref.watch(themeProvider);
    final user = ref.watch(userProvider); // Watch the user provider directly
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriCraft'),
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.light 
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
            tooltip: themeMode == ThemeMode.light 
                ? 'Switch to dark mode' 
                : 'Switch to light mode',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting section - Now using user.name directly
              Text(
                'Hello, ${user.name}!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Today is ${DateFormat('EEEE, MMMM d').format(DateTime.now())}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              
              // Nutrition rings
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Nutrition',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          NutritionRing(
                            title: 'Protein',
                            value: nutritionData.proteinPercentage,
                            color: themeMode == ThemeMode.light 
                                ? AppColors.pastelPeach 
                                : AppColors.darkPastelPeach,
                            subtitle: '${nutritionData.protein}g / ${nutritionData.proteinGoal}g',
                          ),
                          NutritionRing(
                            title: 'Carbs',
                            value: nutritionData.carbsPercentage,
                            color: themeMode == ThemeMode.light 
                                ? AppColors.lightLavender 
                                : AppColors.darkLavender,
                            subtitle: '${nutritionData.carbs}g / ${nutritionData.carbsGoal}g',
                          ),
                          NutritionRing(
                            title: 'Fats',
                            value: nutritionData.fatsPercentage,
                            color: themeMode == ThemeMode.light 
                                ? AppColors.skyBlue 
                                : AppColors.darkSkyBlue,
                            subtitle: '${nutritionData.fats}g / ${nutritionData.fatsGoal}g',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Recommended recipes
              Text(
                'Recommended for You',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedRecipes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: RecipeCard(
                        recipe: recommendedRecipes[index],
                        onTap: () {
                          // Navigate to recipe details when tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(
                                recipe: recommendedRecipes[index],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // Achievements
              Text(
                'Your Achievements',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              AchievementCard(
                title: '3-Day Balanced Streak',
                description: 'You\'ve maintained balanced nutrition for 3 days!',
                icon: Icons.emoji_events,
                color: themeMode == ThemeMode.light 
                    ? AppColors.lightApricot 
                    : AppColors.darkApricot,
              ),
              const SizedBox(height: 8),
              AchievementCard(
                title: 'First Vegan Dish',
                description: 'You\'ve tried your first vegan recipe!',
                icon: Icons.eco,
                color: themeMode == ThemeMode.light 
                    ? AppColors.pastelGreen 
                    : AppColors.darkPastelGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
