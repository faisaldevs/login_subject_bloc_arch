import 'package:fpdart/fpdart.dart';
import 'package:login_subject_demo_bloc_arch/core/error/failure.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> login({
    required String mobile,
    required String password,
  });
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, Unit>> logout();
}
