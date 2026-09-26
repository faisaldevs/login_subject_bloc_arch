import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);
  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "No internet connection"]);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error']);
}

final class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([
    super.message = 'Wrong username or password',
  ]);
}

/// No valid session: never logged in, logged out, or the session expired.
final class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure([super.message = 'Not logged in']);
}

final class InvalidInputFailure extends Failure {
  const InvalidInputFailure(super.message);
}
