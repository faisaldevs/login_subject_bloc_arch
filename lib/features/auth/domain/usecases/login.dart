import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:login_subject_demo_bloc_arch/core/error/failure.dart';
import 'package:login_subject_demo_bloc_arch/core/usecases/usecase.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/repositories/auth_repository.dart';

class Login implements Usecase<Unit, LoginParams> {
  const Login(this._repository);

  final AuthRepository _repository;
  static const minPasswordLength = 6;
  @override
  Future<Either<Failure, Unit>> call(LoginParams params) async {
    final mobile = params.mobile.trim();

    if (mobile.isEmpty) {
      return const Left(InvalidInputFailure("Mobile number cannot be empty"));
    }
    if (mobile.length > 11) {
      return const Left(
        InvalidInputFailure("Mobile number cannot be more then 11 digit"),
      );
    }

    if (params.password.length < minPasswordLength) {
      return const Left(
        InvalidInputFailure(
          'Password must be at least $minPasswordLength characters',
        ),
      );
    }

    return _repository.login(mobile: mobile, password: params.password);
  }
}

class LoginParams extends Equatable {
  const LoginParams(this.mobile, this.password);

  final String mobile;
  final String password;

  @override
  List<Object?> get props => [mobile, password];
}
