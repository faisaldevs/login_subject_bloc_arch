import 'package:equatable/equatable.dart';
import "package:fpdart/fpdart.dart";
import 'package:login_subject_demo_bloc_arch/core/error/failure.dart';

abstract class Usecase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
