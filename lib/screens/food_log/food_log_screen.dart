import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/theme/app_theme.dart';
import 'package:nutricraft/models/food_log.dart';
import 'package:nutricraft/providers/food_log_provider.dart';
import 'package:nutricraft/screens/food_log/add_food_screen.dart';
import 'package:intl/intl.dart';

class FoodLogScreen extends ConsumerStatefulWidget {
  final bool quickAdd;
  
  const FoodLogScreen({
    Key? key,
    this.quickAdd = false,
  }) : super(key: key);

  @override
  ConsumerState<FoodLogScreen> createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends ConsumerState<FoodLogScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // If quickAdd is true, show the add food dialog
    if (widget.quickAdd) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddFoodDialog();
      });
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _showAddFoodDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddFoodScreen(),
    );
  }
  
  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }
  
  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final foodLogs = ref.watch(foodLogProvider);
    
    // Filter logs for the selected date
    final filteredLogs = foodLogs.where((log) {
      return log.dateTime.year == _selectedDate.year &&
             log.dateTime.month == _selectedDate.month &&
             log.dateTime.day == _selectedDate.day;
    }).toList();
    
    // Group logs by meal type
    final breakfast = filteredLogs.where((log) => log.mealType == MealType.breakfast).toList();
    final lunch = filteredLogs.where((log) => log.mealType == MealType.lunch).toList();
    final dinner = filteredLogs.where((log) => log.mealType == MealType.dinner).toList();
    final snacks = filteredLogs.where((log) => log.mealType == MealType.snack).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Log'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Breakfast'),
            Tab(text: 'Lunch'),
            Tab(text: 'Dinner'),
            Tab(text: 'Snacks'),
          ],
          labelColor: AppColors.pastelPeach,
          unselectedLabelColor: AppColors.charcoalGray.withOpacity(0.7),
          indicatorColor: AppColors.pastelPeach,
        ),
      ),
      body: Column(
        children: [
          // Date selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousDay,
                ),
                Text(
                  DateFormat('EEEE, MMMM d').format(_selectedDate),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextDay,
                ),
              ],
            ),
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMealList(breakfast, MealType.breakfast),
                _buildMealList(lunch, MealType.lunch),
                _buildMealList(dinner, MealType.dinner),
                _buildMealList(snacks, MealType.snack),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFoodDialog,
        backgroundColor: AppColors.pastelPeach,
        child: const Icon(
          Icons.add,
          color: AppColors.charcoalGray,
        ),
      ),
    );
  }
  
  Widget _buildMealList(List<FoodLog> logs, MealType mealType) {
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 64,
              color: AppColors.charcoalGray.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No ${mealType.toString().split('.').last} logged yet',
              style: TextStyle(
                color: AppColors.charcoalGray.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _showAddFoodDialog,
              child: Text('Add ${mealType.toString().split('.').last}'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.blushPink,
              child: Icon(
                Icons.restaurant,
                color: AppColors.charcoalGray,
              ),
            ),
            title: Text(log.foodName),
            subtitle: Text('${log.calories} kcal'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${log.servingSize} ${log.servingUnit}',
                  style: TextStyle(
                    color: AppColors.charcoalGray.withOpacity(0.7),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // TODO: Show options (edit, delete)
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
