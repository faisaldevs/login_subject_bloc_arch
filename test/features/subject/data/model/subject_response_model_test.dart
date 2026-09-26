import 'package:flutter_test/flutter_test.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/model/subject_response_model.dart';

void main() {
  final subjectJson = {
    'id': 1,
    'name': 'Math',
    'image': 'https://example.com/math.png',
    'total_questions': 100,
    'practiced_questions': 40,
    'remaining_questions': 60,
    'completion_percent': 40.0,
    'accuracy_percent': 85.5,
    'correct_count': 34,
    'wrong_count': 6,
    'skip_count': 0,
    'answered_count': 40,
    'is_started': true,
  };

  final weeklyProgressJson = {
    'questions_practiced': 42,
    'previous_week': 30,
    'change_percent': 40.0,
    'trend': 'up',
    'week_start': '2026-09-14T00:00:00.000Z',
    'week_end': '2026-09-20T00:00:00.000Z',
  };

  group('SubjectModel', () {
    test('fromJson parses snake_case fields', () {
      final model = SubjectModel.fromJson(subjectJson);

      expect(model.id, 1);
      expect(model.name, 'Math');
      expect(model.image, 'https://example.com/math.png');
      expect(model.totalQuestions, 100);
      expect(model.practicedQuestions, 40);
      expect(model.remainingQuestions, 60);
      expect(model.completionPercent, 40.0);
      expect(model.accuracyPercent, 85.5);
      expect(model.correctCount, 34);
      expect(model.wrongCount, 6);
      expect(model.skipCount, 0);
      expect(model.answeredCount, 40);
      expect(model.isStarted, true);
    });

    test('fromJson tolerates a null image', () {
      final json = Map<String, dynamic>.from(subjectJson)..['image'] = null;

      final model = SubjectModel.fromJson(json);

      expect(model.image, isNull);
    });

    test('toEntity maps every field 1:1', () {
      final entity = SubjectModel.fromJson(subjectJson).toEntity();

      expect(entity.id, 1);
      expect(entity.name, 'Math');
      expect(entity.image, 'https://example.com/math.png');
      expect(entity.totalQuestions, 100);
      expect(entity.practicedQuestions, 40);
      expect(entity.remainingQuestions, 60);
      expect(entity.completionPercent, 40.0);
      expect(entity.accuracyPercent, 85.5);
      expect(entity.correctCount, 34);
      expect(entity.wrongCount, 6);
      expect(entity.skipCount, 0);
      expect(entity.answeredCount, 40);
      expect(entity.isStarted, true);
    });
  });

  group('WeeklyProgressModel', () {
    test('fromJson parses snake_case fields', () {
      final model = WeeklyProgressModel.fromJson(weeklyProgressJson);

      expect(model.questionsPracticed, 42);
      expect(model.previousWeek, 30);
      expect(model.changePercent, 40.0);
      expect(model.trend, 'up');
      expect(model.weekStart, DateTime.parse('2026-09-14T00:00:00.000Z'));
      expect(model.weekEnd, DateTime.parse('2026-09-20T00:00:00.000Z'));
    });

    test('toEntity carries changePercent over as changePersent', () {
      final entity = WeeklyProgressModel.fromJson(weeklyProgressJson).toEntity();

      expect(entity.questionsPracticed, 42);
      expect(entity.previousWeek, 30);
      expect(entity.trend, 'up');
      expect(entity.changePersent, 40.0);
    });

    test('toEntity defaults changePersent to 0 when changePercent is null', () {
      final json = Map<String, dynamic>.from(weeklyProgressJson)
        ..remove('change_percent');

      final entity = WeeklyProgressModel.fromJson(json).toEntity();

      expect(entity.changePersent, 0);
    });
  });

  group('SubjectProgressModel', () {
    test('fromJson + toEntity composes weeklyProgress and subjects', () {
      final json = {
        'weekly_progress': weeklyProgressJson,
        'subjects': [subjectJson],
      };

      final entity = SubjectProgressModel.fromJson(json).toEntity();

      expect(entity.weeklyProgress.questionsPracticed, 42);
      expect(entity.subjects, hasLength(1));
      expect(entity.subjects.single.name, 'Math');
    });

    test('fromJson handles an empty subjects list', () {
      final json = {
        'weekly_progress': weeklyProgressJson,
        'subjects': <Map<String, dynamic>>[],
      };

      final entity = SubjectProgressModel.fromJson(json).toEntity();

      expect(entity.subjects, isEmpty);
    });
  });
}
