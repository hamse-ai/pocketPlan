import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/presentation/main_navigation.dart';
import 'core/theme/appTheme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/presentation/bloc/profile_event.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const PocketPlanApp());
}

class PocketPlanApp extends StatelessWidget {
  const PocketPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (_) => di.sl<SettingsBloc>()..add(LoadSettingsEvent()),
        ),
        BlocProvider(
          create: (_) => di.sl<ProfileBloc>()..add(LoadProfile()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          ThemeMode themeMode = ThemeMode.light;
          if (settingsState is SettingsLoaded) {
            themeMode = AppTheme.getThemeMode(settingsState.settings.theme);
          }

          return MaterialApp(
            title: 'Pocket Plan',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: BlocListener<AuthBloc, AuthState>(
              listenWhen: (prev, curr) => curr is Authenticated,
              listener: (context, state) {
                context.read<SettingsBloc>().add(LoadSettingsEvent());
                context.read<ProfileBloc>().add(LoadProfile());
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is AuthLoading) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (authState is Authenticated) {
                    return const MainNavigation();
                  }
                  return const LoginPage();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
