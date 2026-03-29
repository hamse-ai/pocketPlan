import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:pocket_plan/core/error/failures.dart';
import 'package:pocket_plan/core/usecases/usecase.dart';
import 'package:pocket_plan/features/profile/domain/entities/user_profile.dart';
import 'package:pocket_plan/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pocket_plan/features/profile/presentation/bloc/profile_event.dart';
import 'package:pocket_plan/features/profile/presentation/bloc/profile_state.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/fake_data.dart';

void main() {
  late MockGetProfile mockGetProfile;
  late MockUpdateProfile mockUpdateProfile;
  late MockUploadProfilePhoto mockUploadPhoto;

  setUp(() {
    mockGetProfile = MockGetProfile();
    mockUpdateProfile = MockUpdateProfile();
    mockUploadPhoto = MockUploadProfilePhoto();
    registerFallbackValue(const NoParams());
    registerFallbackValue(tProfile);
  });

  ProfileBloc buildBloc() => ProfileBloc(
        getProfile: mockGetProfile,
        updateProfile: mockUpdateProfile,
        uploadProfilePhoto: mockUploadPhoto,
      );

  // ── Initial state ──────────────────────────────────────────────────────────
  test('initial state is ProfileInitial', () {
    expect(buildBloc().state, isA<ProfileInitial>());
  });

  // ── LoadProfile ────────────────────────────────────────────────────────────
  group('LoadProfile', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when profile is fetched successfully',
      build: buildBloc,
      setUp: () {
        when(() => mockGetProfile(any()))
            .thenAnswer((_) async => const Right(tProfile));
      },
      act: (bloc) => bloc.add(LoadProfile()),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileLoaded>().having((s) => s.profile, 'profile', tProfile),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when profile fetch fails',
      build: buildBloc,
      setUp: () {
        when(() => mockGetProfile(any())).thenAnswer(
            (_) async => const Left(ServerFailure('Profile not found')));
      },
      act: (bloc) => bloc.add(LoadProfile()),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileError>()
            .having((s) => s.message, 'message', 'Profile not found'),
      ],
    );
  });

  // ── SaveProfile ────────────────────────────────────────────────────────────
  group('SaveProfile', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileActionInProgress, ProfileSaved, ProfileLoaded] on success',
      build: buildBloc,
      seed: () => ProfileLoaded(tProfile),
      setUp: () {
        when(() => mockUpdateProfile(any()))
            .thenAnswer((_) async => const Right(null));
      },
      act: (bloc) => bloc.add(const SaveProfile(
        fullName: 'John Updated',
        country: 'Uganda',
        profession: 'Designer',
        bio: 'Updated bio',
      )),
      expect: () => [
        isA<ProfileActionInProgress>(),
        isA<ProfileSaved>(),
        isA<ProfileLoaded>(),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits ProfileError when no profile is loaded before saving',
      build: buildBloc,
      // No seed → ProfileInitial
      act: (bloc) => bloc.add(const SaveProfile(
        fullName: 'John',
        country: 'UK',
        profession: 'Dev',
        bio: 'bio',
      )),
      expect: () => [
        isA<ProfileError>()
            .having((s) => s.message, 'message', 'Load your profile first.'),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits ProfileLoaded with lastError when update fails',
      build: buildBloc,
      seed: () => ProfileLoaded(tProfile),
      setUp: () {
        when(() => mockUpdateProfile(any())).thenAnswer(
            (_) async => const Left(ServerFailure('Update failed')));
      },
      act: (bloc) => bloc.add(const SaveProfile(
        fullName: 'John',
        country: 'UK',
        profession: 'Dev',
        bio: 'bio',
      )),
      expect: () => [
        isA<ProfileActionInProgress>(),
        isA<ProfileLoaded>()
            .having((s) => s.lastError, 'lastError', 'Update failed'),
      ],
    );
  });

  // ── ClearProfileFeedback ───────────────────────────────────────────────────
  group('ClearProfileFeedback', () {
    blocTest<ProfileBloc, ProfileState>(
      're-emits ProfileLoaded without lastError when cleared',
      build: buildBloc,
      seed: () => ProfileLoaded(tProfile, lastError: 'Some error'),
      act: (bloc) => bloc.add(ClearProfileFeedback()),
      expect: () => [
        isA<ProfileLoaded>()
            .having((s) => s.lastError, 'lastError', isNull),
      ],
    );
  });

  // ── UserProfile entity ─────────────────────────────────────────────────────
  group('UserProfile entity', () {
    test('copyWith correctly updates a single field', () {
      final updated = tProfile.copyWith(country: 'Nigeria');
      expect(updated.country, 'Nigeria');
      expect(updated.fullName, tProfile.fullName);
    });

    test('supports value equality', () {
      const duplicate = UserProfile(
        fullName: 'John Doe',
        email: 'john@pocketplan.com',
        country: 'Kenya',
        profession: 'Engineer',
        bio: 'Flutter developer',
        photoUrl: 'https://example.com/photo.jpg',
      );
      expect(tProfile, equals(duplicate));
    });

    test('photoUrl defaults to empty string', () {
      const noPhoto = UserProfile(
        fullName: 'A',
        email: 'a@a.com',
        country: 'B',
        profession: 'C',
        bio: 'D',
      );
      expect(noPhoto.photoUrl, '');
    });
  });
}
