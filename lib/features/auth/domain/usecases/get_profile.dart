import 'package:fpdart/fpdart.dart';
import 'package:login_subject_demo_bloc_arch/core/error/failure.dart';
import 'package:login_subject_demo_bloc_arch/core/usecases/usecase.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/entities/user.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/repositories/auth_repository.dart';

class GetProfile implements Usecase<User, NoParams> {
  const GetProfile(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(NoParams params) => _repository.getUser();
}
