import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getProfile();

  Future<Either<Failure, void>> updateProfile(UserProfile profile);

  Future<Either<Failure, String>> uploadProfilePhoto(XFile file);
}
