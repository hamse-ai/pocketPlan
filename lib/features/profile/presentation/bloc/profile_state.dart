import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  final String? lastError;

  const ProfileLoaded(this.profile, {this.lastError});

  @override
  List<Object?> get props => [profile, lastError];
}

class ProfileActionInProgress extends ProfileState {
  final UserProfile profile;

  const ProfileActionInProgress(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileSaved extends ProfileState {
  final UserProfile profile;

  const ProfileSaved(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
