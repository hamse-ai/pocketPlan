import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_profile.dart' as domain;

class UserProfileModel extends domain.UserProfile {
  const UserProfileModel({
    required super.fullName,
    required super.email,
    required super.country,
    required super.profession,
    required super.bio,
    super.photoUrl = '',
  });

  factory UserProfileModel.fromFirestore(
    Map<String, dynamic> data,
    User authUser,
  ) {
    final fullName = data['fullName'] as String? ??
        data['userName'] as String? ??
        authUser.displayName ??
        '';

    return UserProfileModel(
      fullName: fullName,
      email: authUser.email ?? '',
      country: data['country'] as String? ?? '',
      profession: data['profession'] as String? ?? '',
      bio: data['bio'] as String? ?? '',
      photoUrl: data['photoUrl'] as String? ?? '',
    );
  }

  factory UserProfileModel.fromEntity(domain.UserProfile p) {
    return UserProfileModel(
      fullName: p.fullName,
      email: p.email,
      country: p.country,
      profession: p.profession,
      bio: p.bio,
      photoUrl: p.photoUrl,
    );
  }

  /// Fields written to the user document (email is not stored here; it lives on Auth).
  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'userName': fullName,
      'country': country,
      'profession': profession,
      'bio': bio,
      'photoUrl': photoUrl,
    };
  }
}
