import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/theme/app_theme.dart';
import 'package:nutricraft/providers/user_provider.dart';
import 'package:nutricraft/screens/profile/edit_profile_screen.dart';
import 'package:nutricraft/screens/profile/dietary_preferences_screen.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(24.0),
              color: AppColors.white,
              child: Column(
                children: [
                  // Profile picture
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.pastelPeach,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // User name
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // User email
                  Text(
                    user.email,
                    style: TextStyle(
                      color: AppColors.charcoalGray.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Edit profile button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Stats section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Stats',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(context, '${user.daysActive}', 'Days Active'),
                      _buildStatItem(context, '${user.recipesCooked}', 'Recipes Cooked'),
                      _buildStatItem(context, '${user.achievements}', 'Achievements'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Settings section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSettingsItem(
                    context,
                    Icons.restaurant,
                    'Dietary Preferences',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DietaryPreferencesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    Icons.notifications,
                    'Notification Settings',
                    () {
                    
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    Icons.sync,
                    'Sync Data',
                    () {
                      // TODO: Sync data
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data synced successfully'),
                          backgroundColor: AppColors.pastelGreen,
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    Icons.help_outline,
                    'Help & Support',
                    () {
                      // TODO: Navigate to help & support
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    Icons.info_outline,
                    'About NutriCraft',
                    () {
                      // TODO: Show about dialog
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Logout button
            Container(
              padding: const EdgeInsets.all(16.0),
              color: AppColors.white,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    foregroundColor: Colors.red.shade800,
                  ),
                  child: const Text('Logout'),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.pastelPeach,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.charcoalGray.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSettingsItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.pastelPeach,
      ),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
