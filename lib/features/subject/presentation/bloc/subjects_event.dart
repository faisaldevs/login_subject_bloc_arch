part of 'subjects_bloc.dart';

sealed class SubjectsEvent extends Equatable {
  const SubjectsEvent();

  @override
  List<Object> get props => [];
}

class GetSubjectEvent extends SubjectsEvent {
  const GetSubjectEvent();
}
