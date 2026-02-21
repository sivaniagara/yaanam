part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSignInRequested extends AuthEvent {
  final String loginId;
  final String password;

  const AuthSignInRequested({
    required this.loginId,
    required this.password,
  });

  @override
  List<Object?> get props => [loginId, password];
}

class AuthSignOutRequested extends AuthEvent {}

class AuthCheckStatusRequested extends AuthEvent {}
