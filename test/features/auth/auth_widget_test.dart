import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:pocket_plan/core/error/failures.dart';
import 'package:pocket_plan/core/usecases/usecase.dart';
import 'package:pocket_plan/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:pocket_plan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_plan/features/auth/presentation/bloc/auth_event.dart';
import 'package:pocket_plan/features/auth/presentation/bloc/auth_state.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/fake_data.dart';

// A minimal login form widget for widget-testing purposes
class _TestLoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const CircularProgressIndicator(key: Key('loading_indicator'));
        }
        if (state is AuthError) {
          return Text(state.message, key: const Key('error_text'));
        }
        if (state is Authenticated) {
          return Text('Welcome ${state.user.email}',
              key: const Key('welcome_text'));
        }
        return Column(
          children: [
            ElevatedButton(
              key: const Key('sign_in_btn'),
              onPressed: () {
                context.read<AuthBloc>().add(const SignInWithEmailEvent(
                      email: 'test@pocketplan.com',
                      password: 'pass123',
                    ));
              },
              child: const Text('Sign In'),
            ),
            ElevatedButton(
              key: const Key('sign_out_btn'),
              onPressed: () {
                context.read<AuthBloc>().add(SignOutEvent());
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  late MockSignInWithEmail mockSignIn;
  late MockSignUpWithEmail mockSignUp;
  late MockSignInWithGoogle mockSignInWithGoogle;
  late MockSignOut mockSignOut;
  late MockGetCurrentUser mockGetCurrentUser;

  setUp(() {
    mockSignIn = MockSignInWithEmail();
    mockSignUp = MockSignUpWithEmail();
    mockSignInWithGoogle = MockSignInWithGoogle();
    mockSignOut = MockSignOut();
    mockGetCurrentUser = MockGetCurrentUser();

    registerFallbackValue(const NoParams());
    registerFallbackValue(
        const SignInParams(email: 'a@b.com', password: '123'));
  });

  Widget buildTestApp() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider(
          create: (_) => AuthBloc(
            signInWithEmail: mockSignIn,
            signUpWithEmail: mockSignUp,
            signInWithGoogle: mockSignInWithGoogle,
            signOut: mockSignOut,
            getCurrentUser: mockGetCurrentUser,
          ),
          child: _TestLoginForm(),
        ),
      ),
    );
  }

  group('Auth Widget Tests', () {
    testWidgets('shows Sign In button in initial state',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.byKey(const Key('sign_in_btn')), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator while loading',
        (WidgetTester tester) async {
      when(() => mockSignIn(any())).thenAnswer(
          (_) async => Future.delayed(const Duration(seconds: 1), () => const Right(tUser)));

      await tester.pumpWidget(buildTestApp());
      await tester.tap(find.byKey(const Key('sign_in_btn')));
      await tester.pump(); // Start the action
      await tester.pump(); // Wait for BLoC to emit AuthLoading

      expect(find.byKey(const Key('loading_indicator')), findsOneWidget);
    });

    testWidgets('shows welcome text after successful sign-in',
        (WidgetTester tester) async {
      when(() => mockSignIn(any()))
          .thenAnswer((_) async => const Right(tUser));

      await tester.pumpWidget(buildTestApp());
      await tester.tap(find.byKey(const Key('sign_in_btn')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('welcome_text')), findsOneWidget);
      expect(find.text('Welcome test@pocketplan.com'), findsOneWidget);
    });

    testWidgets('shows error message after failed sign-in',
        (WidgetTester tester) async {
      when(() => mockSignIn(any())).thenAnswer((_) async =>
          const Left(AuthFailure('Invalid credentials')));

      await tester.pumpWidget(buildTestApp());
      await tester.tap(find.byKey(const Key('sign_in_btn')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('error_text')), findsOneWidget);
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
