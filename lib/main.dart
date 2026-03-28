import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_plan/core/presentation/auth_wrapper.dart';
import 'package:pocket_plan/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:pocket_plan/features/settings/presentation/bloc/settings_event.dart';
import 'package:pocket_plan/features/settings/presentation/bloc/settings_state.dart';
import 'injection_container.dart' as di;
import 'core/theme/appTheme.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling Firebase or GetIt
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection (includes Firebase initialization)
  await di.init();

  runApp(const PocketPlanApp());
}

class PocketPlanApp extends StatelessWidget {
  const PocketPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide SettingsBloc at the app level to enable theme switching
    return BlocProvider(
      create: (_) => di.sl<SettingsBloc>()..add(LoadSettingsEvent()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          // Determine theme mode based on settings
          ThemeMode themeMode = ThemeMode.light;
          
          if (state is SettingsLoaded) {
            themeMode = AppTheme.getThemeMode(state.settings.theme);
          }

          return MaterialApp(
            title: 'Pocket Plan',
            debugShowCheckedModeBanner: false,
            
            // Apply both light and dark themes
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            
            // AuthWrapper handles routing between SignIn and MainNavigation
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}