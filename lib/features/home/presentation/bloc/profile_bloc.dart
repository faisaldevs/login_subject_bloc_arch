import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_subject_demo_bloc_arch/core/error/failure.dart';
import 'package:login_subject_demo_bloc_arch/core/usecases/usecase.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/entities/user.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/usecases/get_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  
  ProfileBloc({required this._getProfile}) : super(const ProfileState()) {
    on<ProfileRequested>(_onRequested, transformer: droppable());
  }

  final GetProfile _getProfile;

  Future<void> _onRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _getProfile(const NoParams());

    result.match(
      (failure) => emit(
        failure is UnauthenticatedFailure
            ? state.copyWith(status: ProfileStatus.unauthenticated)
            : state.copyWith(
                status: ProfileStatus.failure,
                errorMessage: failure.message,
              ),
      ),
      (user) => emit(state.copyWith(status: ProfileStatus.success, user: user)),
    );
  }
}
