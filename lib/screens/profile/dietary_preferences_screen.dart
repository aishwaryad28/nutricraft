import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/theme/app_theme.dart';
import 'package:nutricraft/providers/user_provider.dart';
import 'package:nutricraft/models/user.dart';

class DietaryPreferencesScreen extends ConsumerStatefulWidget {
  const DietaryPreferencesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DietaryPreferencesScreen> createState() => _DietaryPreferencesScreenState();
}

class _DietaryPreferencesScreenState extends ConsumerState<DietaryPreferencesScreen> {
  late List<String> _selectedDietaryPreferences;
  late List<String> _selectedAllergies;
  late String _selectedFitnessGoal;
  late String _selectedActivityLevel;
  
  final List<String> _dietaryOptions = [
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Gluten-Free',
    'Dairy-Free',
    'Keto',
    'Paleo',
    'Low-Carb',
    'Mediterranean',
    'Whole30',
  ];
  
  final List<String> _allergyOptions = [
    'Peanuts',
    'Tree Nuts',
    'Milk',
    'Eggs',
    'Fish',
    'Shellfish',
    'Soy',
    'Wheat',
    'Sesame',
  ];
  
  final List<String> _fitnessGoalOptions = [
    'Weight Loss',
    'Muscle Gain',
    'Maintain Weight',
    'Improve Health',
    'Increase Energy',
  ];
  
  final List<String> _activityLevelOptions = [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
    'Extremely Active',
  ];
  
  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _selectedDietaryPreferences = List.from(user.dietaryPreferences);
    _selectedAllergies = List.from(user.allergies);
    _selectedFitnessGoal = user.fitnessGoal;
    _selectedActivityLevel = user.activityLevel;
  }
  
  void _savePreferences() {
    final currentUser = ref.read(userProvider);
    final updatedUser = User(
      id: currentUser.id,
      name: currentUser.name,
      email: currentUser.email,
      height: currentUser.height,
      weight: currentUser.weight,
      gender: currentUser.gender,
      birthDate: currentUser.birthDate,
      dietaryPreferences: _selectedDietaryPreferences,
      allergies: _selectedAllergies,
      fitnessGoal: _selectedFitnessGoal,
      activityLevel: _selectedActivityLevel,
      daysActive: currentUser.daysActive,
      recipesCooked: currentUser.recipesCooked,
      achievements: currentUser.achievements,
    );
    
    ref.read(userProvider.notifier).updateUser(updatedUser);
    
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dietary preferences updated successfully'),
        backgroundColor: AppColors.pastelGreen,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dietary Preferences'),
        actions: [
          TextButton(
            onPressed: _savePreferences,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dietary Preferences
            Text(
              'Dietary Preferences',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select all that apply to you',
              style: TextStyle(
                color: AppColors.charcoalGray.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _dietaryOptions.map((option) {
                final isSelected = _selectedDietaryPreferences.contains(option);
                return FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedDietaryPreferences.add(option);
                      } else {
                        _selectedDietaryPreferences.remove(option);
                      }
                    });
                  },
                  backgroundColor: AppColors.white,
                  selectedColor: AppColors.pastelPeach,
                  checkmarkColor: AppColors.charcoalGray,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            // Allergies
            Text(
              'Allergies & Intolerances',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select all that apply to you',
              style: TextStyle(
                color: AppColors.charcoalGray.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allergyOptions.map((option) {
                final isSelected = _selectedAllergies.contains(option);
                return FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedAllergies.add(option);
                      } else {
                        _selectedAllergies.remove(option);
                      }
                    });
                  },
                  backgroundColor: AppColors.white,
                  selectedColor: AppColors.lightApricot,
                  checkmarkColor: AppColors.charcoalGray,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            // Fitness Goal
            Text(
              'Fitness Goal',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(_fitnessGoalOptions.length, (index) {
              final option = _fitnessGoalOptions[index];
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _selectedFitnessGoal,
                onChanged: (value) {
                  setState(() {
                    _selectedFitnessGoal = value!;
                  });
                },
                activeColor: AppColors.pastelPeach,
              );
            }),
            const SizedBox(height: 24),
            
            // Activity Level
            Text(
              'Activity Level',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(_activityLevelOptions.length, (index) {
              final option = _activityLevelOptions[index];
              return RadioListTile<String>(
                title: Text(option),
                subtitle: Text(_getActivityLevelDescription(option)),
                value: option,
                groupValue: _selectedActivityLevel,
                onChanged: (value) {
                  setState(() {
                    _selectedActivityLevel = value!;
                  });
                },
                activeColor: AppColors.pastelPeach,
              );
            }),
            const SizedBox(height: 32),
            
            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePreferences,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Preferences'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getActivityLevelDescription(String activityLevel) {
    switch (activityLevel) {
      case 'Sedentary':
        return 'Little to no exercise';
      case 'Lightly Active':
        return 'Light exercise 1-3 days/week';
      case 'Moderately Active':
        return 'Moderate exercise 3-5 days/week';
      case 'Very Active':
        return 'Hard exercise 6-7 days/week';
      case 'Extremely Active':
        return 'Very hard exercise & physical job';
      default:
        return '';
    }
  }
}
