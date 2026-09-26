import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  SubjectBloc() : super(const SubjectState()) {
    on<SubjectEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
