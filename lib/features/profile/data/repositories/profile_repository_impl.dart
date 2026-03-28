import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_firebase_datasource.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileFirebaseDataSource remote;

  ProfileRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final model = await remote.getProfile();
      return Right(model);
    } on ServerException {
      return const Left(ServerFailure('Could not load profile. Sign in and try again.'));
    } catch (e) {
      return Left(ServerFailure('Could not load profile: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(UserProfile profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      await remote.saveProfile(model);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Could not save profile.'));
    } catch (e) {
      return Left(ServerFailure('Could not save profile: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto(XFile file) async {
    try {
      final url = await remote.uploadProfilePhoto(file);
      return Right(url);
    } on ServerException {
      return const Left(ServerFailure('Could not upload photo.'));
    } catch (e) {
      return Left(ServerFailure('Could not upload photo: $e'));
    }
  }
}
