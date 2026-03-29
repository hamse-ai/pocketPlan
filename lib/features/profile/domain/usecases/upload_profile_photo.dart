import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class UploadProfilePhoto implements UseCase<String, XFile> {
  final ProfileRepository repository;

  UploadProfilePhoto(this.repository);

  @override
  Future<Either<Failure, String>> call(XFile params) {
    return repository.uploadProfilePhoto(params);
  }
}
