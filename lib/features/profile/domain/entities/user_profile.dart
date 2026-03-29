import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String fullName;
  final String email;
  final String country;
  final String profession;
  final String bio;
  final String photoUrl;

  const UserProfile({
    required this.fullName,
    required this.email,
    required this.country,
    required this.profession,
    required this.bio,
    this.photoUrl = '',
  });

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? country,
    String? profession,
    String? bio,
    String? photoUrl,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      country: country ?? this.country,
      profession: profession ?? this.profession,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props =>
      [fullName, email, country, profession, bio, photoUrl];
}
