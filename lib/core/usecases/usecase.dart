import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base abstract class for all use cases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case with no parameters
class NoParams {
  const NoParams();
}