import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/presentation/main_navigation.dart';
import 'core/theme/appTheme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'injection_container.dart' as di;

void main() async {
  // Ensure Flutter bindings are initialized before calling Firebase or GetIt
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
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
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Pocket Plan',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is Authenticated) {
              return const MainNavigation();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
