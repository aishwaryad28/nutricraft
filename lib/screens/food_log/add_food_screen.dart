import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/theme/app_theme.dart';
import 'package:nutricraft/models/food_log.dart';
import 'package:nutricraft/providers/food_log_provider.dart';
import 'package:nutricraft/services/food_database_service.dart';

class AddFoodScreen extends ConsumerStatefulWidget {
  const AddFoodScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends ConsumerState<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _foodNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _servingSizeController = TextEditingController();
  
  MealType _selectedMealType = MealType.breakfast;
  String _selectedServingUnit = 'g';
  
  final List<String> _servingUnits = ['g', 'ml', 'oz', 'cup', 'tbsp', 'tsp', 'piece'];
  
  bool _isManualEntry = true;
  bool _isVoiceInputActive = false;
  
  @override
  void dispose() {
    _foodNameController.dispose();
    _caloriesController.dispose();
    _servingSizeController.dispose();
    super.dispose();
  }
  
  void _toggleInputMethod() {
    setState(() {
      _isManualEntry = !_isManualEntry;
    });
  }
  
  void _toggleVoiceInput() {
    setState(() {
      _isVoiceInputActive = !_isVoiceInputActive;
    });
    
    if (_isVoiceInputActive) {
      // TODO: Implement voice recognition
      // For now, just simulate voice input after a delay
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _foodNameController.text = 'Boiled eggs and toast';
          _isVoiceInputActive = false;
        });
      });
    }
  }
  
  void _searchFood(String query) {
    // TODO: Implement food search
  }
  
  void _addFoodLog() {
    if (_formKey.currentState!.validate()) {
      final foodLog = FoodLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        foodName: _foodNameController.text,
        calories: int.parse(_caloriesController.text),
        servingSize: double.parse(_servingSizeController.text),
        servingUnit: _selectedServingUnit,
        mealType: _selectedMealType,
        dateTime: DateTime.now(),
        protein: 0, // TODO: Add these fields to the form
        carbs: 0,
        fats: 0,
      );
      
      ref.read(foodLogProvider.notifier).addFoodLog(foodLog);
      Navigator.pop(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: AppColors.softMint,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.charcoalGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Food',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Input method toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                  value: true,
                  label: Text('Manual Entry'),
                  icon: Icon(Icons.edit),
                ),
                ButtonSegment<bool>(
                  value: false,
                  label: Text('Search Food'),
                  icon: Icon(Icons.search),
                ),
              ],
              selected: {_isManualEntry},
              onSelectionChanged: (Set<bool> selection) {
                setState(() {
                  _isManualEntry = selection.first;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return AppColors.pastelPeach;
                    }
                    return AppColors.white;
                  },
                ),
              ),
            ),
          ),
          
          Expanded(
            child: _isManualEntry ? _buildManualEntryForm() : _buildFoodSearch(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildManualEntryForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Voice input button
            Center(
              child: GestureDetector(
                onTap: _toggleVoiceInput,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _isVoiceInputActive ? AppColors.pastelPeach : AppColors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pastelPeach.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isVoiceInputActive ? Icons.mic : Icons.mic_none,
                    size: 40,
                    color: _isVoiceInputActive ? AppColors.white : AppColors.pastelPeach,
                  ),
                ),
              ),
            ),
            if (_isVoiceInputActive)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Listening...',
                    style: TextStyle(
                      color: AppColors.pastelPeach,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            
            // Food name
            TextFormField(
              controller: _foodNameController,
              decoration: const InputDecoration(
                labelText: 'Food Name',
                hintText: 'e.g., Grilled Chicken Salad',
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a food name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Meal type
            DropdownButtonFormField<MealType>(
              value: _selectedMealType,
              decoration: const InputDecoration(
                labelText: 'Meal Type',
                prefixIcon: Icon(Icons.category),
              ),
              items: MealType.values.map((mealType) {
                return DropdownMenuItem<MealType>(
                  value: mealType,
                  child: Text(mealType.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMealType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Calories
            TextFormField(
              controller: _caloriesController,
              decoration: const InputDecoration(
                labelText: 'Calories',
                hintText: 'e.g., 250',
                prefixIcon: Icon(Icons.local_fire_department),
                suffixText: 'kcal',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter calories';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Serving size and unit
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _servingSizeController,
                    decoration: const InputDecoration(
                      labelText: 'Serving Size',
                      hintText: 'e.g., 100',
                      prefixIcon: Icon(Icons.scale),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter serving size';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: _selectedServingUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                    ),
                    items: _servingUnits.map((unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedServingUnit = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addFoodLog,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Add to Food Log'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFoodSearch() {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for a food...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.mic),
                onPressed: _toggleVoiceInput,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.white,
            ),
            onChanged: _searchFood,
          ),
        ),
        
        // Recent searches
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                'Recent Searches',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Clear recent searches
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
        
        // Recent search chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildRecentSearchChip('Oatmeal'),
              _buildRecentSearchChip('Grilled Chicken'),
              _buildRecentSearchChip('Greek Yogurt'),
              _buildRecentSearchChip('Banana'),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Quick add section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                'Quick Add',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        // Quick add items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildQuickAddItem(
                'Breakfast',
                'Oatmeal with Berries',
                '320 kcal',
                Icons.breakfast_dining,
              ),
              _buildQuickAddItem(
                'Lunch',
                'Grilled Chicken Salad',
                '450 kcal',
                Icons.lunch_dining,
              ),
              _buildQuickAddItem(
                'Snack',
                'Greek Yogurt with Honey',
                '180 kcal',
                Icons.icecream,
              ),
              _buildQuickAddItem(
                'Dinner',
                'Salmon with Vegetables',
                '520 kcal',
                Icons.dinner_dining,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildRecentSearchChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: AppColors.white,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
  
  Widget _buildQuickAddItem(String mealType, String foodName, String calories, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.blushPink,
          child: Icon(
            icon,
            color: AppColors.charcoalGray,
          ),
        ),
        title: Text(foodName),
        subtitle: Text(mealType),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              calories,
              style: TextStyle(
                color: AppColors.charcoalGray.withOpacity(0.7),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                // TODO: Quick add this food
              },
            ),
          ],
        ),
      ),
    );
  }
}
