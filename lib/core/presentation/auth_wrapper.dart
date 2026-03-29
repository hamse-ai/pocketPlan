import 'package:flutter/material.dart';
import '../presentation/main_navigation.dart';
import '../../features/auth/presentation/pages/signin_page.dart';

/// AuthWrapper checks if user is logged in and routes accordingly
/// 
/// Flow:
/// - Not logged in → SignInPage
/// - Logged in → MainNavigation (app home)
/// - On logout → Navigate back to SignInPage
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
   // TODO: Replace with actual authentication state from AuthBloc
  // For now, using a simple boolean to be replaced with Firebase Auth integration
  bool _isLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with BlocBuilder<AuthBloc, AuthState>
    // Example future implementation:
    // return BlocBuilder<AuthBloc, AuthState>(
    //   builder: (context, state) {
    //     if (state is Authenticated) {
    //       return const MainNavigation();
    //     }
    //     return const SignInPage();
    //   },
    // );

    // Current placeholder implementation:
    if (_isLoggedIn) {
      return const MainNavigation();
    }
    
    return const SignInPage();
  }
}