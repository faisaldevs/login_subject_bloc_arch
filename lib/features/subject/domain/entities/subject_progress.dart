import 'package:equatable/equatable.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/subject.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/weekly_progress.dart';

class SubjectProgress extends Equatable {
  const SubjectProgress({required this.weeklyProgress, required this.subjects});

  final WeeklyProgress weeklyProgress;
  final List<Subject> subjects;

  @override
  List<Object?> get props => [weeklyProgress, subjects];
}
