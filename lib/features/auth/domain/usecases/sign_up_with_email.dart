import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import 'sign_in_with_email.dart';

class SignUpWithEmail implements UseCase<UserEntity, SignInParams> {
  final AuthRepository repository;

  SignUpWithEmail(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) async {
    return await repository.signUpWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}
