part of 'subjects_bloc.dart';

enum SubjectsStatus { initial, loading, success, failure }

class SubjectsState extends Equatable {
  const SubjectsState({
    this.status = SubjectsStatus.initial,
    this.subjectProgress,
    this.errorMessage,
  });

  final SubjectsStatus status;
  final SubjectProgress? subjectProgress;
  final String? errorMessage;

  SubjectsState copyWith({
    SubjectsStatus? status,
    SubjectProgress? subjectProgress,
    String? errorMessage,
  }) {
    return SubjectsState(
      status: status ?? this.status,
      subjectProgress: subjectProgress ?? this.subjectProgress,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, subjectProgress, errorMessage];
}

