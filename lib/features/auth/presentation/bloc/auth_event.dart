part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmitted extends AuthEvent {
  const LoginSubmitted({required this.mobile, required this.password});

  final String mobile;
  final String password;

  @override
  List<Object> get props => [mobile, password];
}
