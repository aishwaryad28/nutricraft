import 'package:nutricraft/models/food_log.dart';
import 'package:nutricraft/models/recipe.dart';
import 'dart:math';

class MockDataService {
  final Random _random = Random();
  
  List<FoodLog> getMockFoodLogs() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    
    return [
      FoodLog(
        id: '1',
        foodName: 'Oatmeal with Berries',
        calories: 320,
        servingSize: 1,
        servingUnit: 'bowl',
        mealType: MealType.breakfast,
        dateTime: DateTime(now.year, now.month, now.day, 8, 0),
        protein: 10,
        carbs: 50,
        fats: 8,
      ),
      FoodLog(
        id: '2',
        foodName: 'Grilled Chicken Salad',
        calories: 450,
        servingSize: 1,
        servingUnit: 'plate',
        mealType: MealType.lunch,
        dateTime: DateTime(now.year, now.month, now.day, 12, 30),
        protein: 35,
        carbs: 20,
        fats: 15,
      ),
      FoodLog(
        id: '3',
        foodName: 'Greek Yogurt with Honey',
        calories: 180,
        servingSize: 1,
        servingUnit: 'cup',
        mealType: MealType.snack,
        dateTime: DateTime(now.year, now.month, now.day, 15, 0),
        protein: 15,
        carbs: 25,
        fats: 2,
      ),
      FoodLog(
        id: '4',
        foodName: 'Salmon with Vegetables',
        calories: 520,
        servingSize: 1,
        servingUnit: 'plate',
        mealType: MealType.dinner,
        dateTime: DateTime(now.year, now.month, now.day, 19, 0),
        protein: 40,
        carbs: 30,
        fats: 25,
      ),
      FoodLog(
        id: '5',
        foodName: 'Avocado Toast',
        calories: 280,
        servingSize: 1,
        servingUnit: 'slice',
        mealType: MealType.breakfast,
        dateTime: DateTime(yesterday.year, yesterday.month, yesterday.day, 8, 0),
        protein: 8,
        carbs: 30,
        fats: 15,
      ),
      FoodLog(
        id: '6',
        foodName: 'Quinoa Bowl',
        calories: 420,
        servingSize: 1,
        servingUnit: 'bowl',
        mealType: MealType.lunch,
        dateTime: DateTime(yesterday.year, yesterday.month, yesterday.day, 12, 30),
        protein: 15,
        carbs: 60,
        fats: 12,
      ),
    ];
  }
  
  List<Recipe> getMockRecipes() {
    final baseRecipes = [
      Recipe(
        id: '1',
        name: 'Avocado Toast with Poached Egg',
        description: 'A nutritious breakfast that combines creamy avocado with a perfectly poached egg on whole grain toast.',
        imageUrl: 'assets/images/avocado_toast.jpg',
        ingredients: [
          '2 slices whole grain bread',
          '1 ripe avocado',
          '2 eggs',
          '1 tbsp lemon juice',
          'Salt and pepper to taste',
          'Red pepper flakes (optional)',
        ],
        instructions: [
          'Toast the bread until golden and firm.',
          'While the bread is toasting, halve the avocado and remove the pit. Scoop the flesh into a bowl and mash with a fork. Add lemon juice, salt, and pepper to taste.',
          'Bring a pot of water to a simmer. Create a gentle whirlpool and crack an egg into the center. Cook for 3 minutes, then remove with a slotted spoon. Repeat with the second egg.',
          'Spread the mashed avocado on the toast and top each with a poached egg.',
          'Sprinkle with additional salt, pepper, and red pepper flakes if desired.',
        ],
        cookingTime: 15,
        servings: 2,
        calories: 320,
        protein: 15,
        carbs: 30,
        fats: 18,
        fiber: 8,
        tags: ['Vegetarian', 'Breakfast', 'High-Protein'],
        isFavorite: true,
      ),
      Recipe(
        id: '2',
        name: 'Greek Yogurt Parfait',
        description: 'A quick and easy breakfast or snack that layers creamy Greek yogurt with fresh berries and crunchy granola.',
        imageUrl: 'assets/images/yogurt_parfait.jpg',
        ingredients: [
          '2 cups Greek yogurt',
          '1 cup mixed berries (strawberries, blueberries, raspberries)',
          '1/2 cup granola',
          '2 tbsp honey',
          '1 tbsp chia seeds',
        ],
        instructions: [
          'In two glasses or bowls, layer 1/4 cup of Greek yogurt at the bottom.',
          'Add a layer of mixed berries.',
          'Sprinkle a layer of granola.',
          'Repeat the layers, ending with granola on top.',
          'Drizzle with honey and sprinkle with chia seeds before serving.',
        ],
        cookingTime: 10,
        servings: 2,
        calories: 280,
        protein: 20,
        carbs: 35,
        fats: 8,
        fiber: 6,
        tags: ['Vegetarian', 'Breakfast', 'Snack', 'Quick'],
        isFavorite: false,
      ),
      Recipe(
        id: '3',
        name: 'Quinoa Salad with Roasted Vegetables',
        description: 'A hearty and nutritious salad that combines fluffy quinoa with a colorful mix of roasted vegetables.',
        imageUrl: 'assets/images/quinoa_salad.jpg',
        ingredients: [
          '1 cup quinoa, rinsed',
          '2 cups vegetable broth',
          '1 red bell pepper, diced',
          '1 zucchini, diced',
          '1 small eggplant, diced',
          '1 red onion, diced',
          '2 tbsp olive oil',
          '2 tbsp balsamic vinegar',
          '1/4 cup fresh parsley, chopped',
          'Salt and pepper to taste',
        ],
        instructions: [
          'Preheat oven to 425°F (220°C).',
          'In a medium saucepan, combine quinoa and vegetable broth. Bring to a boil, then reduce heat to low, cover, and simmer for 15 minutes until quinoa is tender and liquid is absorbed.',
          'While quinoa is cooking, toss diced vegetables with 1 tbsp olive oil, salt, and pepper. Spread on a baking sheet and roast for 20 minutes, stirring halfway through.',
          'In a small bowl, whisk together remaining olive oil and balsamic vinegar.',
          'In a large bowl, combine cooked quinoa, roasted vegetables, and dressing. Toss to combine.',
          'Stir in chopped parsley and season with additional salt and pepper if needed.',
          'Serve warm or chilled.',
        ],
        cookingTime: 35,
        servings: 4,
        calories: 320,
        protein: 10,
        carbs: 45,
        fats: 12,
        fiber: 8,
        tags: ['Vegan', 'Gluten-Free', 'Lunch', 'Dinner'],
        isFavorite: false,
      ),
      Recipe(
        id: '4',
        name: 'Grilled Chicken with Roasted Sweet Potatoes',
        description: 'A simple and satisfying meal featuring juicy grilled chicken and caramelized sweet potatoes.',
        imageUrl: 'assets/images/grilled_chicken.jpg',
        ingredients: [
          '4 boneless, skinless chicken breasts',
          '2 tbsp olive oil',
          '2 cloves garlic, minced',
          '1 tbsp dried herbs (rosemary, thyme, oregano)',
          '2 large sweet potatoes, cubed',
          '1 tbsp maple syrup',
          'Salt and pepper to taste',
        ],
        instructions: [
          'Preheat oven to 400°F (200°C).',
          'In a bowl, toss sweet potato cubes with 1 tbsp olive oil, maple syrup, salt, and pepper. Spread on a baking sheet and roast for 25-30 minutes until tender and caramelized.',
          'While sweet potatoes are roasting, prepare the chicken. In a small bowl, combine remaining olive oil, garlic, herbs, salt, and pepper.',
          'Rub the mixture over the chicken breasts.',
          'Preheat grill or grill pan over medium-high heat. Grill chicken for 6-7 minutes per side, or until internal temperature reaches 165°F (74°C).',
          'Let chicken rest for 5 minutes before slicing.',
          'Serve chicken with roasted sweet potatoes.',
        ],
        cookingTime: 40,
        servings: 4,
        calories: 380,
        protein: 35,
        carbs: 30,
        fats: 12,
        fiber: 5,
        tags: ['High-Protein', 'Gluten-Free', 'Dinner'],
        isFavorite: true,
      ),
      Recipe(
        id: '5',
        name: 'Berry Smoothie Bowl',
        description: 'A refreshing and nutritious smoothie bowl topped with fresh fruits and crunchy toppings.',
        imageUrl: 'assets/images/smoothie_bowl.jpg',
        ingredients: [
          '1 frozen banana',
          '1 cup frozen mixed berries',
          '1/2 cup Greek yogurt',
          '1/4 cup almond milk',
          'Toppings: sliced banana, fresh berries, granola, chia seeds, honey',
        ],
        instructions: [
          'In a blender, combine frozen banana, frozen berries, Greek yogurt, and almond milk.',
          'Blend until smooth and creamy. The mixture should be thick enough to eat with a spoon.',
          'Pour the smoothie into a bowl.',
          'Arrange toppings on the surface of the smoothie bowl.',
          'Drizzle with honey if desired.',
          'Serve immediately.',
        ],
        cookingTime: 10,
        servings: 1,
        calories: 320,
        protein: 15,
        carbs: 60,
        fats: 5,
        fiber: 10,
        tags: ['Vegetarian', 'Breakfast', 'Snack', 'Quick'],
        isFavorite: false,
      ),
      Recipe(
        id: '6',
        name: 'Lentil Soup',
        description: 'A hearty and nutritious soup packed with lentils, vegetables, and aromatic spices.',
        imageUrl: 'assets/images/lentil_soup.jpg',
        ingredients: [
          '1 cup dried lentils, rinsed',
          '1 onion, diced',
          '2 carrots, diced',
          '2 celery stalks, diced',
          '3 cloves garlic, minced',
          '1 can (14 oz) diced tomatoes',
          '4 cups vegetable broth',
          '1 tsp cumin',
          '1 tsp paprika',
          '1/2 tsp turmeric',
          '2 tbsp olive oil',
          'Salt and pepper to taste',
          'Fresh parsley for garnish',
        ],
        instructions: [
          'In a large pot, heat olive oil over medium heat. Add onion, carrots, and celery. Cook for 5 minutes until vegetables begin to soften.',
          'Add garlic and cook for another minute until fragrant.',
          'Add lentils, diced tomatoes, vegetable broth, cumin, paprika, turmeric, salt, and pepper. Stir to combine.',
          'Bring to a boil, then reduce heat to low. Cover and simmer for 25-30 minutes, until lentils are tender.',
          'Taste and adjust seasoning if needed.',
          'Serve hot, garnished with fresh parsley.',
        ],
        cookingTime: 40,
        servings: 4,
        calories: 280,
        protein: 15,
        carbs: 40,
        fats: 8,
        fiber: 15,
        tags: ['Vegan', 'Gluten-Free', 'Soup', 'Dinner'],
        isFavorite: false,
      ),
    ];
    
    // Generate more recipes for testing
    return [...baseRecipes, ...generateMoreMockRecipes(30)];
  }
  
  // Generate additional mock recipes for infinite scrolling
  List<Recipe> generateMoreMockRecipes(int count) {
    final List<Recipe> recipes = [];
    
    final List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack', 'Dessert'];
    final List<String> dietTypes = ['Vegetarian', 'Vegan', 'Gluten-Free', 'Low-Carb', 'High-Protein', 'Keto', 'Paleo'];
    final List<String> cuisines = ['Italian', 'Mexican', 'Asian', 'Mediterranean', 'Indian', 'American', 'French'];
    
    final List<String> breakfastNames = [
      'Fluffy Pancakes', 'Breakfast Burrito', 'Veggie Omelette', 'Chia Pudding', 
      'Breakfast Smoothie', 'Protein Waffles', 'Overnight Oats', 'Breakfast Sandwich',
      'Acai Bowl', 'Breakfast Hash', 'French Toast', 'Breakfast Quesadilla'
    ];
    
    final List<String> lunchNames = [
      'Chicken Wrap', 'Tuna Salad', 'Veggie Burger', 'Falafel Bowl', 
      'Pasta Salad', 'Grain Bowl', 'Stuffed Peppers', 'Chicken Caesar Salad',
      'Mediterranean Plate', 'Sushi Bowl', 'Burrito Bowl', 'Poke Bowl'
    ];
    
    final List<String> dinnerNames = [
      'Baked Salmon', 'Vegetable Stir Fry', 'Chicken Curry', 'Beef Stew', 
      'Mushroom Risotto', 'Eggplant Parmesan', 'Shrimp Scampi', 'Lentil Dahl',
      'Roast Chicken', 'Beef Tacos', 'Vegetable Lasagna', 'Tofu Stir Fry'
    ];
    
    for (int i = 0; i < count; i++) {
      final mealType = mealTypes[_random.nextInt(mealTypes.length)];
      final dietType = dietTypes[_random.nextInt(dietTypes.length)];
      final cuisine = cuisines[_random.nextInt(cuisines.length)];
      
      String name;
      if (mealType == 'Breakfast') {
        name = breakfastNames[_random.nextInt(breakfastNames.length)];
      } else if (mealType == 'Lunch') {
        name = lunchNames[_random.nextInt(lunchNames.length)];
      } else {
        name = dinnerNames[_random.nextInt(dinnerNames.length)];
      }
      
      // Add some variety to the names
      name = '$cuisine $name';
      if (_random.nextBool()) {
        name = '$dietType $name';
      }
      
      final cookingTime = 10 + _random.nextInt(50); // 10-60 minutes
      final calories = 200 + _random.nextInt(400); // 200-600 calories
      final protein = 5 + _random.nextInt(35); // 5-40g protein
      final carbs = 10 + _random.nextInt(60); // 10-70g carbs
      final fats = 5 + _random.nextInt(25); // 5-30g fats
      
      recipes.add(Recipe(
        id: (7 + i).toString(), // Start IDs after the base recipes
        name: name,
        description: 'A delicious $dietType $cuisine $mealType recipe that is perfect for any day of the week.',
        imageUrl: 'assets/images/recipe_placeholder.jpg', // Use placeholder image
        ingredients: [
          'Ingredient 1',
          'Ingredient 2',
          'Ingredient 3',
          'Ingredient 4',
          'Ingredient 5',
        ],
        instructions: [
          'Step 1: Prepare the ingredients.',
          'Step 2: Cook the main components.',
          'Step 3: Combine everything together.',
          'Step 4: Serve and enjoy!',
        ],
        cookingTime: cookingTime,
        servings: 1 + _random.nextInt(3), // 1-4 servings
        calories: calories,
        protein: protein,
        carbs: carbs,
        fats: fats,
        fiber: 2 + _random.nextInt(13), // 2-15g fiber
        tags: [mealType, dietType, cuisine],
        isFavorite: _random.nextInt(10) == 0, // 10% chance of being favorite
      ));
    }
    
    return recipes;
  }
}
