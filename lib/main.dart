import 'package:flutter/material.dart';
import 'package:pocket_plan/features/home/presentation/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_plan/core/presentation/main_navigation.dart';
import 'injection_container.dart' as di;
import 'core/theme/appTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
    );
  }
}

