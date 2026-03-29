import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class ClearProfileFeedback extends ProfileEvent {}

class SaveProfile extends ProfileEvent {
  final String fullName;
  final String country;
  final String profession;
  final String bio;

  const SaveProfile({
    required this.fullName,
    required this.country,
    required this.profession,
    required this.bio,
  });

  @override
  List<Object?> get props => [fullName, country, profession, bio];
}

class ProfilePhotoSelected extends ProfileEvent {
  final XFile file;

  const ProfilePhotoSelected(this.file);

  @override
  List<Object?> get props => [file];
}
