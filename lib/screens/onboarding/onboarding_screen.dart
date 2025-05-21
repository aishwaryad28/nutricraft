import 'package:flutter/material.dart';
import 'package:nutricraft/screens/onboarding/onboarding_page.dart';
import 'package:nutricraft/screens/home/home_screen.dart';
import 'package:nutricraft/theme/app_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Track Your Meals',
      description: 'Easily log what you eat through text, voice, or quick-add options.',
      image: 'assets/images/onboarding_1.png',
      icon: Icons.restaurant,
    ),
    OnboardingPageData(
      title: 'Smart Recommendations',
      description: 'Get personalized recipe suggestions based on your preferences and nutritional needs.',
      image: 'assets/images/onboarding_2.png',
      icon: Icons.lightbulb,
    ),
    OnboardingPageData(
      title: 'Monitor Your Progress',
      description: 'View your nutritional balance and track improvements over time.',
      image: 'assets/images/onboarding_3.png',
      icon: Icons.insert_chart,
    ),
    OnboardingPageData(
      title: 'Join the Community',
      description: 'Share recipes and discover creations from other users that match your profile.',
      image: 'assets/images/onboarding_4.png',
      icon: Icons.people,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softMint,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.charcoalGray.withOpacity(0.7),
                      ),
                    ),
                  ),
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.pastelPeach,
                      dotColor: AppColors.lightLavender,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 4,
                      expansionFactor: 3,
                    ),
                  ),
                  // Next button
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: Icon(
                      _currentPage < _pages.length - 1 
                          ? Icons.arrow_forward
                          : Icons.check,
                      color: AppColors.charcoalGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPageData {
  final String title;
  final String description;
  final String image;
  final IconData icon;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
  });
}
