import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:pocket_plan/core/error/failures.dart';
import 'package:pocket_plan/core/usecases/usecase.dart';
import 'package:pocket_plan/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:pocket_plan/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:pocket_plan/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:pocket_plan/features/auth/domain/usecases/sign_out.dart';
import 'package:pocket_plan/features/auth/domain/usecases/get_current_user.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/fake_data.dart';

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    registerFallbackValue(const NoParams());
    registerFallbackValue(
        const SignInParams(email: 'a@b.com', password: '123456'));
  });

  // ── SignInWithEmail ────────────────────────────────────────────────────────
  group('SignInWithEmail UseCase', () {
    final usecase = () => SignInWithEmail(mockRepository);

    test('returns UserEntity on successful sign-in', () async {
      when(() => mockRepository.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Right(tUser));

      final result = await usecase()(
          const SignInParams(email: 'test@pocketplan.com', password: 'pass'));

      expect(result, const Right(tUser));
      verify(() => mockRepository.signInWithEmail(
          email: 'test@pocketplan.com', password: 'pass')).called(1);
    });

    test('returns AuthFailure when credentials are wrong', () async {
      when(() => mockRepository.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer(
              (_) async => const Left(AuthFailure('Invalid credentials')));

      final result = await usecase()(
          const SignInParams(email: 'bad@email.com', password: 'wrong'));

      expect(result, const Left(AuthFailure('Invalid credentials')));
    });
  });

  // ── SignUpWithEmail ────────────────────────────────────────────────────────
  group('SignUpWithEmail UseCase', () {
    final usecase = () => SignUpWithEmail(mockRepository);

    test('returns UserEntity on successful registration', () async {
      when(() => mockRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Right(tUser));

      final result = await usecase()(
          const SignInParams(email: 'new@pocketplan.com', password: 'pass'));

      expect(result, const Right(tUser));
    });

    test('returns ServerFailure when registration fails', () async {
      when(() => mockRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer(
              (_) async => const Left(ServerFailure('Email already in use')));

      final result = await usecase()(
          const SignInParams(email: 'existing@email.com', password: 'pass'));

      expect(result, const Left(ServerFailure('Email already in use')));
    });
  });

  // ── SignInWithGoogle ───────────────────────────────────────────────────────
  group('SignInWithGoogle UseCase', () {
    final usecase = () => SignInWithGoogle(mockRepository);

    test('returns UserEntity on successful Google sign-in', () async {
      when(() => mockRepository.signInWithGoogle())
          .thenAnswer((_) async => const Right(tUser));

      final result = await usecase()(const NoParams());

      expect(result, const Right(tUser));
      verify(() => mockRepository.signInWithGoogle()).called(1);
    });

    test('returns AuthFailure when Google sign-in is cancelled', () async {
      when(() => mockRepository.signInWithGoogle()).thenAnswer(
          (_) async => const Left(AuthFailure('Google sign-in cancelled')));

      final result = await usecase()(const NoParams());

      expect(result, const Left(AuthFailure('Google sign-in cancelled')));
    });
  });

  // ── SignOut ────────────────────────────────────────────────────────────────
  group('SignOut UseCase', () {
    final usecase = () => SignOut(mockRepository);

    test('returns Right(void) on successful sign-out', () async {
      when(() => mockRepository.signOut())
          .thenAnswer((_) async => const Right(null));

      final result = await usecase()(const NoParams());

      expect(result.isRight(), true);
      verify(() => mockRepository.signOut()).called(1);
    });

    test('returns ServerFailure when sign-out fails', () async {
      when(() => mockRepository.signOut()).thenAnswer(
          (_) async => const Left(ServerFailure('Sign-out failed')));

      final result = await usecase()(const NoParams());

      expect(result, const Left(ServerFailure('Sign-out failed')));
    });
  });

  // ── GetCurrentUser ─────────────────────────────────────────────────────────
  group('GetCurrentUser UseCase', () {
    final usecase = () => GetCurrentUser(mockRepository);

    test('returns UserEntity when a user is logged in', () async {
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Right(tUser));

      final result = await usecase()(const NoParams());

      expect(result, const Right(tUser));
    });

    test('returns AuthFailure when no user is logged in', () async {
      when(() => mockRepository.getCurrentUser()).thenAnswer(
          (_) async => const Left(AuthFailure('No user logged in')));

      final result = await usecase()(const NoParams());

      expect(result, const Left(AuthFailure('No user logged in')));
    });
  });
}
