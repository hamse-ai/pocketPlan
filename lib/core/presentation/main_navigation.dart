import 'package:flutter/material.dart';
import 'widgets/base_layout.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Temporary placeholders
  final List<Widget> _screens = const [
    PlaceholderScreen(screenName: 'Home'),
    PlaceholderScreen(screenName: 'Income'),
    PlaceholderScreen(screenName: 'Expense'),
    PlaceholderScreen(screenName: 'Profile'),
    PlaceholderScreen(screenName: 'Settings'),
  ];

  final List<String?> _titles = const [
    null, // Home has no AppBar
    'Income',
    'Expense',
    'Profile',
    'Settings',
  ];

  // Track which screens should show AppBar
  final List<bool> _showAppBar = const [
    false, 
    true,  
    true,  
    true,  
    true,  
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