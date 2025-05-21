import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/models/user.dart';
import 'package:nutricraft/services/storage_service.dart';

class UserNotifier extends StateNotifier<User> {
  final StorageService _storageService;
  
  UserNotifier(this._storageService) : super(
    User(
      id: '1',
      name: 'Alex Johnson',
      email: 'alex@example.com',
      height: 175,
      weight: 70,
      gender: 'Male',
      birthDate: DateTime(1990, 1, 1),
      dietaryPreferences: ['Vegetarian'],
      allergies: ['Peanuts'],
      fitnessGoal: 'Weight Loss',
      activityLevel: 'Moderately Active',
      daysActive: 15,
      recipesCooked: 8,
      achievements: 3,
    ),
  ) {
    _loadUser();
  }
  
  Future<void> _loadUser() async {
    final user = await _storageService.getUser();
    if (user != null) {
      state = user;
    }
  }
  
  Future<void> updateUser(User user) async {
    state = user;
    await _storageService.saveUser(user);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return UserNotifier(storageService);
});
