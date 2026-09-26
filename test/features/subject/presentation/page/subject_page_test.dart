import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_subject_demo_bloc_arch/di.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/subject.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/subject_progress.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/weekly_progress.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/presentation/bloc/subjects_bloc.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/presentation/page/subject_page.dart';
import 'package:mocktail/mocktail.dart';

class MockSubjectsBloc extends MockBloc<SubjectsEvent, SubjectsState>
    implements SubjectsBloc {}

void main() {
  late MockSubjectsBloc bloc;

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
    bloc = MockSubjectsBloc();
  });

  Widget wrap(Widget child) => MaterialApp(home: child);

  group('SubjectPageView', () {
    testWidgets('shows a spinner while loading', (tester) async {
      when(() => bloc.state)
          .thenReturn(const SubjectsState(status: SubjectsStatus.loading));

      await tester.pumpWidget(
        wrap(
          BlocProvider<SubjectsBloc>.value(
            value: bloc,
            child: const SubjectPageView(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders the subject list on success', (tester) async {
      when(() => bloc.state).thenReturn(
        const SubjectsState(
          status: SubjectsStatus.success,
          subjectProgress: tSubjectProgress,
        ),
      );

      await tester.pumpWidget(
        wrap(
          BlocProvider<SubjectsBloc>.value(
            value: bloc,
            child: const SubjectPageView(),
          ),
        ),
      );

      expect(find.text('Math'), findsOneWidget);
      expect(find.text('40/100 practiced'), findsOneWidget);
      expect(find.text('40%'), findsOneWidget);
    });

    testWidgets('renders the error message on failure', (tester) async {
      when(() => bloc.state).thenReturn(
        const SubjectsState(
          status: SubjectsStatus.failure,
          errorMessage: 'Failed to load subjects',
        ),
      );

      await tester.pumpWidget(
        wrap(
          BlocProvider<SubjectsBloc>.value(
            value: bloc,
            child: const SubjectPageView(),
          ),
        ),
      );

      expect(find.text('Failed to load subjects'), findsOneWidget);
    });

    testWidgets('falls back to a generic message when errorMessage is null', (
      tester,
    ) async {
      when(() => bloc.state)
          .thenReturn(const SubjectsState(status: SubjectsStatus.failure));

      await tester.pumpWidget(
        wrap(
          BlocProvider<SubjectsBloc>.value(
            value: bloc,
            child: const SubjectPageView(),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
    });
  });

  group('SubjectPage', () {
    tearDown(() async {
      await sl.reset();
    });

    testWidgets('resolves its bloc from the service locator and requests subjects', (
      tester,
    ) async {
      when(() => bloc.state)
          .thenReturn(const SubjectsState(status: SubjectsStatus.loading));
      sl.registerFactory<SubjectsBloc>(() => bloc);

      await tester.pumpWidget(wrap(const SubjectPage()));

      verify(() => bloc.add(const GetSubjectEvent())).called(1);
    });
  });
}
