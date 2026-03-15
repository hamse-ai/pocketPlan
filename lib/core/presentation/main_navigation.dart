import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_plan/features/budget/presentation/bloc/expense_bloc.dart';
import 'package:pocket_plan/features/budget/presentation/pages/expense_screen.dart';
import 'package:pocket_plan/features/income/presentation/bloc/income_bloc.dart';
import 'package:pocket_plan/features/income/presentation/pages/income_screen.dart';
import 'widgets/base_layout.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PlaceholderScreen(screenName: 'Home'),
    const IncomeScreen(),
    const ExpenseScreen(),
    const PlaceholderScreen(screenName: 'Profile'),
    const PlaceholderScreen(screenName: 'Settings'),
  ];

  final List<String?> _titles = [
    null,       // Home has no AppBar
    'Income',
    'Expenses',
    'Profile',
    'Settings',
  ];

  final List<bool> _showAppBar = [
    false, // Home
    true,  // Income
    true,  // Expenses
    true,  // Profile
    true,  // Settings
  ];

  void _onNavigationTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // Provide both BLoCs at the navigation level so all screens can access them.
    return MultiBlocProvider(
      providers: [
        BlocProvider<IncomeBloc>(
          create: (_) => IncomeBloc()..add(const LoadIncomeTransactions()),
        ),
        BlocProvider<ExpenseBloc>(
          create: (_) => ExpenseBloc()..add(const LoadExpenseTransactions()),
        ),
      ],
      child: BaseLayout(
        title: _titles[_currentIndex],
        body: _screens[_currentIndex],
        currentIndex: _currentIndex,
        onNavigationTap: _onNavigationTap,
        showAppBar: _showAppBar[_currentIndex],
      ),
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