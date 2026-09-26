part of 'subject_bloc.dart';

enum SubjectStatus { initial, loading, success, failure }

final class SubjectState extends Equatable {
  const SubjectState({this.status = SubjectStatus.initial, this.errorMessage});

  final SubjectStatus status;
  final String? errorMessage;

  SubjectState copyWith({SubjectStatus? status, String? errorMessage}) {
    return SubjectState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
