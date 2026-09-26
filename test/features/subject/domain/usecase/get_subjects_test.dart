import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_subject_demo_bloc_arch/core/error/failure.dart';
import 'package:login_subject_demo_bloc_arch/core/usecases/usecase.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/subject.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/subject_progress.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/weekly_progress.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/repositories/subject_repository.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/usecase/get_subjects.dart';
import 'package:mocktail/mocktail.dart';

class MockSubjectRepository extends Mock implements SubjectRepository {}

void main() {
  late MockSubjectRepository repository;
  late GetSubjects usecase;

  const tSubjectProgress = SubjectProgress(
    weeklyProgress: WeeklyProgress(
      questionsPracticed: 42,
      previousWeek: 30,
      trend: 'up',
      changePersent: 40,
    ),
    subjects: [
      Subject(
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
    repository = MockSubjectRepository();
    usecase = GetSubjects(repository);
  });

  test('returns Right(SubjectProgress) when the repository succeeds', () async {
    when(() => repository.getSubjects())
        .thenAnswer((_) async => const Right(tSubjectProgress));

    final result = await usecase(const NoParams());

    expect(result, const Right(tSubjectProgress));
    verify(() => repository.getSubjects()).called(1);
  });

  test('returns Left(Failure) when the repository fails', () async {
    when(() => repository.getSubjects())
        .thenAnswer((_) async => const Left(ServerFailure('Failed to load subjects')));

    final result = await usecase(const NoParams());

    expect(result, const Left(ServerFailure('Failed to load subjects')));
  });
}
