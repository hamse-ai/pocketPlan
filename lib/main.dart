import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_plan/core/presentation/auth_wrapper.dart';
import 'injection_container.dart' as di;
import 'core/theme/appTheme.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling Firebase or GetIt
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();

  runApp(const PocketPlanApp());
}

class PocketPlanApp extends StatelessWidget {
  const PocketPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Plan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // AuthWrapper handles routing between SignIn and MainNavigation
      home: const AuthWrapper(),
    );
  }
}