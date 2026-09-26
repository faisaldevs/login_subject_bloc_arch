import 'package:fpdart/fpdart.dart';
import 'package:login_subject_demo_bloc_arch/core/error/failure.dart';
import 'package:login_subject_demo_bloc_arch/core/usecases/usecase.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/subject_progress.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/repositories/subject_repository.dart';

class GetSubjects implements Usecase<SubjectProgress, NoParams> {
  const GetSubjects(this._repository);

  final SubjectRepository _repository;

  @override
  Future<Either<Failure, SubjectProgress>> call(NoParams params) {
    return _repository.getSubjects();
  }
}
