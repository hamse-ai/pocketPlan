import 'package:flutter/material.dart';

/// Placeholder SignIn Page
/// 
/// TODO: Auth team to implement:
/// - Email/password input fields
/// - Firebase authentication integration
/// - AuthBloc integration (LoginEvent)
/// - "Sign Up" navigation link
/// - Error handling and validation
/// - Remember me functionality
/// - Forgot password flow
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign In Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('(To be implemented by Auth team)'),
            const SizedBox(height: 32),
            
            // Placeholder "Go to Sign Up" button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpPage()),
                );
              },
              child: const Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder SignUp Page
/// 
/// TODO: Auth team to implement:
/// - Name, email, password input fields
/// - Password confirmation
/// - Firebase authentication integration
/// - AuthBloc integration (SignUpEvent)
/// - "Sign In" navigation link
/// - Terms and conditions checkbox
/// - Error handling and validation
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign Up Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('(To be implemented by Auth team)'),
            const SizedBox(height: 32),
            
            // Placeholder "Go to Sign In" button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Already have an account? Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}