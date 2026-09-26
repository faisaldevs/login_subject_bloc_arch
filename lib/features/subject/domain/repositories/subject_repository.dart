import 'package:fpdart/fpdart.dart';
import 'package:login_subject_demo_bloc_arch/core/error/failure.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/subject_progress.dart';

abstract class SubjectRepository {
  Future<Either<Failure, SubjectProgress>> getSubjects();
}
