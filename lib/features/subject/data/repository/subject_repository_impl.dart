import 'package:fpdart/fpdart.dart';
import 'package:login_subject_demo_bloc_arch/core/error/exceptions.dart';
import 'package:login_subject_demo_bloc_arch/core/error/failure.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/datasource/subject_remote_data_source.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/subject_progress.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/repositories/subject_repository.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectRemoteDataSource remoteDataSource;

  SubjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SubjectProgress>> getSubjects() async {
    try {
      final subjectProgressModel = await remoteDataSource.getSubjects();
      return Right(subjectProgressModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }
}
