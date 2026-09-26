import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_subject_demo_bloc_arch/core/error/exceptions.dart';
import 'package:login_subject_demo_bloc_arch/core/error/failure.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/datasource/subject_remote_data_source.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/model/subject_response_model.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/repository/subject_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockSubjectRemoteDataSource extends Mock
    implements SubjectRemoteDataSource {}

void main() {
  late MockSubjectRemoteDataSource remoteDataSource;
  late SubjectRepositoryImpl repository;

  final tModel = SubjectProgressModel(
    weeklyProgress: WeeklyProgressModel(
      questionsPracticed: 42,
      previousWeek: 30,
      changePercent: 40,
      trend: 'up',
      weekStart: DateTime.utc(2026, 9, 14),
      weekEnd: DateTime.utc(2026, 9, 20),
    ),
    subjects: const [
      SubjectModel(
        id: 1,
        name: 'Math',
        totalQuestions: 100,
        practicedQuestions: 40,
        remainingQuestions: 60,
        completionPercent: 40,
        accuracyPercent: 85.5,
        correctCount: 34,
        wrongCount: 6,
        skipCount: 0,
        answeredCount: 40,
        isStarted: true,
      ),
    ],
  );

  setUp(() {
    remoteDataSource = MockSubjectRemoteDataSource();
    repository = SubjectRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  group('getSubjects', () {
    test('returns Right(entity) when the data source succeeds', () async {
      when(() => remoteDataSource.getSubjects()).thenAnswer((_) async => tModel);

      final result = await repository.getSubjects();

      expect(result, Right(tModel.toEntity()));
    });

    test('returns Left(ServerFailure) when the data source throws ServerException', () async {
      when(() => remoteDataSource.getSubjects()).thenThrow(
        const ServerException(message: 'Failed to load subjects', statusCode: 500),
      );

      final result = await repository.getSubjects();

      expect(
        result,
        const Left(ServerFailure('Failed to load subjects', statusCode: 500)),
      );
    });
  });
}
