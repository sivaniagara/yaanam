part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSignInRequested extends AuthEvent {
  final String mobileNumber;
  final String password;

  const AuthSignInRequested({
    required this.mobileNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [mobileNumber, password];
}

class AuthSignupRequested extends AuthEvent {
  final SignupEntity signupEntity;

  const AuthSignupRequested(this.signupEntity);

  @override
  List<Object?> get props => [signupEntity];
}

class AuthVerifyOtpRequested extends AuthEvent {
  final int userId;
  final String otp;

  const AuthVerifyOtpRequested({
    required this.userId,
    required this.otp,
  });

  @override
  List<Object?> get props => [userId, otp];
}

class AuthResendOtpRequested extends AuthEvent {
  final String mobile;

  const AuthResendOtpRequested({required this.mobile});

  @override
  List<Object?> get props => [mobile];
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String mobile;
  final String email;

  const AuthForgotPasswordRequested({
    required this.mobile,
    required this.email,
  });

  @override
  List<Object?> get props => [mobile, email];
}

class AuthUpdatePasswordRequested extends AuthEvent {
  final String mobile;
  final String otp;
  final String password;

  const AuthUpdatePasswordRequested({
    required this.mobile,
    required this.otp,
    required this.password,
  });

  @override
  List<Object?> get props => [mobile, otp, password];
}

class AuthSignOutRequested extends AuthEvent {}

class AuthCheckStatusRequested extends AuthEvent {}
