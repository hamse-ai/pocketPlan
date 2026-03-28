import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/upload_profile_photo.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final UploadProfilePhoto uploadProfilePhoto;

  ProfileBloc({
    required this.getProfile,
    required this.updateProfile,
    required this.uploadProfilePhoto,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoad);
    on<ClearProfileFeedback>(_onClearFeedback);
    on<SaveProfile>(_onSave);
    on<ProfilePhotoSelected>(_onUpload);
  }

  void _onClearFeedback(
    ClearProfileFeedback event,
    Emitter<ProfileState> emit,
  ) {
    final s = state;
    if (s is ProfileLoaded) {
      emit(ProfileLoaded(s.profile));
    }
  }

  Future<void> _onLoad(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await getProfile(NoParams());
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> _onSave(SaveProfile event, Emitter<ProfileState> emit) async {
    final current = state;
    final base = current is ProfileLoaded
        ? current.profile
        : current is ProfileActionInProgress
            ? current.profile
            : null;

    if (base == null) {
      emit(const ProfileError('Load your profile first.'));
      return;
    }

    final updated = UserProfile(
      fullName: event.fullName.trim(),
      email: base.email,
      country: event.country.trim(),
      profession: event.profession.trim(),
      bio: event.bio.trim(),
      photoUrl: base.photoUrl,
    );

    emit(ProfileActionInProgress(updated));

    final result = await updateProfile(updated);
    result.fold(
      (failure) => emit(ProfileLoaded(base, lastError: failure.message)),
      (_) {
        emit(ProfileSaved(updated));
        emit(ProfileLoaded(updated));
      },
    );
  }

  Future<void> _onUpload(
    ProfilePhotoSelected event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state;
    final base = current is ProfileLoaded
        ? current.profile
        : current is ProfileActionInProgress
            ? current.profile
            : null;

    if (base == null) {
      emit(const ProfileError('Load your profile first.'));
      return;
    }

    emit(ProfileActionInProgress(base));

    final result = await uploadProfilePhoto(event.file);
    await result.fold(
      (failure) async => emit(ProfileLoaded(base, lastError: failure.message)),
      (url) async {
        final withPhoto = base.copyWith(photoUrl: url);
        emit(ProfileLoaded(withPhoto));
      },
    );
  }
}
