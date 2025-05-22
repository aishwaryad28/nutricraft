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
  
  // Scroll controller for infinite scrolling
  final ScrollController _scrollController = ScrollController();
  
  // Pagination state
  bool _isLoading = false;
  bool _hasMoreLogs = true;
  int _currentPage = 1;
  final int _logsPerPage = 10;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Add scroll listener for infinite scrolling
    _scrollController.addListener(_scrollListener);
    
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
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
  
  // Scroll listener for infinite scrolling
  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoading &&
        _hasMoreLogs) {
      _loadMoreLogs();
    }
  }
  
  // Load more logs
  Future<void> _loadMoreLogs() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // In a real app, you would load more logs from a database or API
    // For now, we'll just simulate it by checking if we have more logs
    final foodLogs = ref.read(foodLogProvider);
    
    // Filter logs for the selected date and meal type
    final filteredLogs = foodLogs.where((log) {
      return log.dateTime.year == _selectedDate.year &&
             log.dateTime.month == _selectedDate.month &&
             log.dateTime.day == _selectedDate.day;
    }).toList();
    
    // Check if we have more logs to load
    final hasMore = filteredLogs.length > _currentPage * _logsPerPage;
    
    setState(() {
      _isLoading = false;
      _hasMoreLogs = hasMore;
      if (hasMore) {
        _currentPage++;
      }
    });
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
      // Reset pagination when date changes
      _currentPage = 1;
      _hasMoreLogs = true;
    });
  }
  
  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
      // Reset pagination when date changes
      _currentPage = 1;
      _hasMoreLogs = true;
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
    
    // Apply pagination to the logs
    final paginatedLogs = logs.take(_currentPage * _logsPerPage).toList();
    
    return ListView.builder(
      controller: _scrollController, // Add scroll controller for infinite scrolling
      padding: const EdgeInsets.all(16.0),
      itemCount: paginatedLogs.length + (_isLoading && _hasMoreLogs ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the end
        if (index == paginatedLogs.length && _isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final log = paginatedLogs[index];
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
                    // Show options (edit, delete)
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.edit),
                            title: const Text('Edit'),
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Implement edit functionality
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete, color: Colors.red),
                            title: const Text('Delete', style: TextStyle(color: Colors.red)),
                            onTap: () {
                              Navigator.pop(context);
                              ref.read(foodLogProvider.notifier).deleteFoodLog(log.id);
                            },
                          ),
                        ],
                      ),
                    );
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
