import 'package:flutter/material.dart';
import 'widgets/base_layout.dart';
import 'package:pocket_plan/features/profile/presentation/pages/profile_page.dart';
import 'package:pocket_plan/features/settings/presentation/settings_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Remove 'const' from these lists
  final List<Widget> _screens = [
    const PlaceholderScreen(screenName: 'Home'),
    const PlaceholderScreen(screenName: 'Income'),
    const PlaceholderScreen(screenName: 'Expense'),
    const ProfilePage(),
    const SettingsPage(),
  ];

  final List<String?> _titles = [
    null, // Home has no AppBar
    'Income',
    'Expense',
    'Profile',
    'Settings',
  ];

  // Track which screens should show AppBar
  final List<bool> _showAppBar = [
    false, // Home - no AppBar
    true,  // Income - has AppBar
    true,  // Expense - has AppBar
    true,  // Profile - has AppBar
    true,  // Settings - has AppBar
  ];

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: _titles[_currentIndex],
      body: _screens[_currentIndex],
      currentIndex: _currentIndex,
      onNavigationTap: _onNavigationTap,
      showAppBar: _showAppBar[_currentIndex],
    );
  }
}


// TEMPORARY SCREEN (will be replaced by team screens)

class PlaceholderScreen extends StatelessWidget {
  final String screenName;

  const PlaceholderScreen({
    super.key,
    required this.screenName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$screenName Screen\n(To be implemented)',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}