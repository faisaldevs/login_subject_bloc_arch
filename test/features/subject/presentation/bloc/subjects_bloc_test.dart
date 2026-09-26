import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_subject_demo_bloc_arch/core/error/failure.dart';
import 'package:login_subject_demo_bloc_arch/core/usecases/usecase.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/subject.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/subject_progress.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/weekly_progress.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/usecase/get_subjects.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/presentation/bloc/subjects_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSubjects extends Mock implements GetSubjects {}

void main() {
  late MockGetSubjects getSubjects;

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
    getSubjects = MockGetSubjects();
  });

  test('initial state is SubjectsStatus.initial', () {
    expect(
      SubjectsBloc(getSubjects).state,
      const SubjectsState(status: SubjectsStatus.initial),
    );
  });

  group('GetSubjectEvent', () {
    blocTest<SubjectsBloc, SubjectsState>(
      'emits [loading, success] when the usecase succeeds',
      setUp: () {
        when(() => getSubjects(const NoParams()))
            .thenAnswer((_) async => const Right(tSubjectProgress));
      },
      build: () => SubjectsBloc(getSubjects),
      act: (bloc) => bloc.add(const GetSubjectEvent()),
      expect: () => [
        const SubjectsState(status: SubjectsStatus.loading),
        const SubjectsState(
          status: SubjectsStatus.success,
          subjectProgress: tSubjectProgress,
        ),
      ],
    );

    blocTest<SubjectsBloc, SubjectsState>(
      'emits [loading, failure] when the usecase fails',
      setUp: () {
        when(() => getSubjects(const NoParams())).thenAnswer(
          (_) async => const Left(ServerFailure('Failed to load subjects')),
        );
      },
      build: () => SubjectsBloc(getSubjects),
      act: (bloc) => bloc.add(const GetSubjectEvent()),
      expect: () => [
        const SubjectsState(status: SubjectsStatus.loading),
        const SubjectsState(
          status: SubjectsStatus.failure,
          errorMessage: 'Failed to load subjects',
        ),
      ],
    );

    blocTest<SubjectsBloc, SubjectsState>(
      'drops a second event fired while the first is still in flight',
      setUp: () {
        when(() => getSubjects(const NoParams())).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return const Right(tSubjectProgress);
        });
      },
      build: () => SubjectsBloc(getSubjects),
      act: (bloc) {
        bloc.add(const GetSubjectEvent());
        bloc.add(const GetSubjectEvent());
      },
      wait: const Duration(milliseconds: 100),
      verify: (_) {
        verify(() => getSubjects(const NoParams())).called(1);
      },
    );
  });
}
