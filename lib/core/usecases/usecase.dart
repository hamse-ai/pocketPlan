import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Base abstract class for all use cases
```
```

/// Base abstract class for all use cases in the application.
/// Each use case takes [Params] and returns either a [Failure] or [Type].
abstract class UseCase<Type, Params> {
```
```
  Future<Either<Failure, Type>> call(Params params);
}

/// Used when a use case requires no input parameters
class NoParams extends Equatable {
```
```
  const NoParams();

  @override
  List<Object> get props => [];
}
