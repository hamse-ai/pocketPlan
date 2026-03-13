import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_plan/core/presentation/main_navigation.dart';
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
    return MultiBlocProvider(
      providers: [
        // TODO: Register Feature BLoCs here
        // BlocProvider(create: (_) => di.sl<AuthBloc>()),
      ],
      child: MaterialApp(
        title: 'Pocket Plan',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigation(), // Placeholder for initial routing logic
      ),
    );
  }
}

