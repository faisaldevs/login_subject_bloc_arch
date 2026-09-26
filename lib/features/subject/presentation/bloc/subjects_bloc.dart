import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_subject_demo_bloc_arch/core/usecases/usecase.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/entities/subject_progress.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/usecase/get_subjects.dart';

part 'subjects_event.dart';
part 'subjects_state.dart';

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  SubjectsBloc(this._getSubjects)
    : super(const SubjectsState(status: SubjectsStatus.initial)) {

    on<GetSubjectEvent>(_onGetSubjects, transformer: droppable());
  
  }

  final GetSubjects _getSubjects;

  Future<void> _onGetSubjects(
    GetSubjectEvent event,
    Emitter<SubjectsState> emit,
  ) async {
   
    emit(state.copyWith(status: SubjectsStatus.loading));

    final result = await _getSubjects(const NoParams());

    result.match(
      (failure) => emit(
        state.copyWith(
          status: SubjectsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (subjectProgress) => emit(
        state.copyWith(
          status: SubjectsStatus.success,
          subjectProgress: subjectProgress,
        ),
      ),
    );
  }
}
