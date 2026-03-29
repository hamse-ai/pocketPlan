import 'package:equatable/equatable.dart';


/// Base class for all application failures
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Thrown when a remote server request fails
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

/// Thrown when an authentication operation fails
class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

/// Thrown when a local cache operation fails
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}
