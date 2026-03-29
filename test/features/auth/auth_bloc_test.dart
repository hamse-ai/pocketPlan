import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:pocket_plan/core/error/failures.dart';
import 'package:pocket_plan/core/usecases/usecase.dart';
import 'package:pocket_plan/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:pocket_plan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_plan/features/auth/presentation/bloc/auth_event.dart';
import 'package:pocket_plan/features/auth/presentation/bloc/auth_state.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/fake_data.dart';

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

  AuthBloc buildBloc() => AuthBloc(
        signInWithEmail: mockSignIn,
        signUpWithEmail: mockSignUp,
        signInWithGoogle: mockSignInWithGoogle,
        signOut: mockSignOut,
        getCurrentUser: mockGetCurrentUser,
      );

  // ── Initial state ──────────────────────────────────────────────────────────
  test('initial state is AuthInitial', () {
    expect(buildBloc().state, isA<AuthInitial>());
  });

  // ── CheckAuthStatus ────────────────────────────────────────────────────────
  group('CheckAuthStatusEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when user is logged in',
      build: buildBloc,
      setUp: () {
        when(() => mockGetCurrentUser(any()))
            .thenAnswer((_) async => const Right(tUser));
      },
      act: (bloc) => bloc.add(CheckAuthStatusEvent()),
      expect: () => [isA<AuthLoading>(), isA<Authenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when no user is logged in',
      build: buildBloc,
      setUp: () {
        when(() => mockGetCurrentUser(any())).thenAnswer(
            (_) async => const Left(AuthFailure('No user logged in')));
      },
      act: (bloc) => bloc.add(CheckAuthStatusEvent()),
      expect: () => [isA<AuthLoading>(), isA<Unauthenticated>()],
    );
  });

  // ── SignInWithEmail ────────────────────────────────────────────────────────
  group('SignInWithEmailEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] on successful email sign-in',
      build: buildBloc,
      setUp: () {
        when(() => mockSignIn(any()))
            .thenAnswer((_) async => const Right(tUser));
      },
      act: (bloc) => bloc.add(const SignInWithEmailEvent(
          email: 'test@pocketplan.com', password: 'pass123')),
      expect: () => [isA<AuthLoading>(), isA<Authenticated>()],
      verify: (_) {
        verify(() => mockSignIn(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on failed email sign-in',
      build: buildBloc,
      setUp: () {
        when(() => mockSignIn(any())).thenAnswer(
            (_) async => const Left(AuthFailure('Wrong password')));
      },
      act: (bloc) => bloc.add(const SignInWithEmailEvent(
          email: 'test@pocketplan.com', password: 'wrongpass')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>().having((e) => e.message, 'message', 'Wrong password'),
      ],
    );
  });

  // ── SignUpWithEmail ────────────────────────────────────────────────────────
  group('SignUpWithEmailEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] on successful registration',
      build: buildBloc,
      setUp: () {
        when(() => mockSignUp(any()))
            .thenAnswer((_) async => const Right(tUser));
      },
      act: (bloc) => bloc.add(const SignUpWithEmailEvent(
          email: 'new@pocketplan.com', password: 'newpass')),
      expect: () => [isA<AuthLoading>(), isA<Authenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when email is already taken',
      build: buildBloc,
      setUp: () {
        when(() => mockSignUp(any())).thenAnswer(
            (_) async => const Left(AuthFailure('Email already in use')));
      },
      act: (bloc) => bloc.add(const SignUpWithEmailEvent(
          email: 'taken@pocketplan.com', password: 'pass')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>()
            .having((e) => e.message, 'message', 'Email already in use'),
      ],
    );
  });

  // ── SignInWithGoogle ───────────────────────────────────────────────────────
  group('SignInWithGoogleEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] on successful Google sign-in',
      build: buildBloc,
      setUp: () {
        when(() => mockSignInWithGoogle(any()))
            .thenAnswer((_) async => const Right(tUser));
      },
      act: (bloc) => bloc.add(SignInWithGoogleEvent()),
      expect: () => [isA<AuthLoading>(), isA<Authenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when Google sign-in is cancelled',
      build: buildBloc,
      setUp: () {
        when(() => mockSignInWithGoogle(any())).thenAnswer((_) async =>
            const Left(AuthFailure('Google sign-in cancelled')));
      },
      act: (bloc) => bloc.add(SignInWithGoogleEvent()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>().having(
            (e) => e.message, 'message', 'Google sign-in cancelled'),
      ],
    );
  });

  // ── SignOut ────────────────────────────────────────────────────────────────
  group('SignOutEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] on successful sign-out',
      build: buildBloc,
      setUp: () {
        when(() => mockSignOut(any()))
            .thenAnswer((_) async => const Right(null));
      },
      act: (bloc) => bloc.add(SignOutEvent()),
      expect: () => [isA<AuthLoading>(), isA<Unauthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when sign-out fails',
      build: buildBloc,
      setUp: () {
        when(() => mockSignOut(any())).thenAnswer(
            (_) async => const Left(ServerFailure('Sign-out failed')));
      },
      act: (bloc) => bloc.add(SignOutEvent()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>()
            .having((e) => e.message, 'message', 'Sign-out failed'),
      ],
    );
  });

  // ── Authenticated state data ───────────────────────────────────────────────
  group('Authenticated state', () {
    test('holds the correct user entity', () {
      const state = Authenticated(tUser);
      expect(state.user.uid, 'uid-001');
      expect(state.user.email, 'test@pocketplan.com');
      expect(state.user.displayName, 'Test User');
    });
  });
}
