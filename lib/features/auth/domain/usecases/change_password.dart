import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ChangePassword implements UseCase<void, String> {
  final AuthRepository repository;

  ChangePassword(this.repository);

  @override
  Future<Either<Failure, void>> call(String newPassword) async {
    return await repository.changePassword(newPassword);
  }
}
