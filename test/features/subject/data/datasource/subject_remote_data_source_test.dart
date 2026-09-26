import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_subject_demo_bloc_arch/core/error/exceptions.dart';
import 'package:login_subject_demo_bloc_arch/core/network/base_model/base_response_model.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/datasource/subject_api_service.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/datasource/subject_remote_data_source.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/model/subject_response_model.dart';
import 'package:mocktail/mocktail.dart';

class MockSubjectApiService extends Mock implements SubjectApiService {}

void main() {
  late MockSubjectApiService apiService;
  late SubjectRemoteDataSourceImpl dataSource;

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
    apiService = MockSubjectApiService();
    dataSource = SubjectRemoteDataSourceImpl(apiService: apiService);
  });

  group('getSubjects', () {
    test('returns the model when the API responds with code 200 and data', () async {
      when(() => apiService.getTasks()).thenAnswer(
        (_) async => BaseResponseModel(code: 200, message: 'ok', data: tModel),
      );

      final result = await dataSource.getSubjects();

      expect(result, tModel);
    });

    test('throws ServerException when code is not 200', () async {
      when(() => apiService.getTasks()).thenAnswer(
        (_) async => BaseResponseModel(
          code: 400,
          message: 'Bad request',
          data: null,
        ),
      );

      expect(
        () => dataSource.getSubjects(),
        throwsA(
          isA<ServerException>()
              .having((e) => e.message, 'message', 'Bad request')
              .having((e) => e.statusCode, 'statusCode', 400),
        ),
      );
    });

    test('throws ServerException with a fallback message when data is null', () async {
      when(() => apiService.getTasks()).thenAnswer(
        (_) async => BaseResponseModel(code: 200, message: null, data: null),
      );

      expect(
        () => dataSource.getSubjects(),
        throwsA(
          isA<ServerException>()
              .having((e) => e.message, 'message', 'Failed to load subjects'),
        ),
      );
    });

    test('maps a DioException to ServerException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/v2/subjects/list'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/v2/subjects/list'),
          statusCode: 500,
          data: {'message': 'Internal error'},
        ),
      );
      when(() => apiService.getTasks()).thenThrow(dioException);

      expect(
        () => dataSource.getSubjects(),
        throwsA(
          isA<ServerException>()
              .having((e) => e.message, 'message', 'Internal error')
              .having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });
  });
}
