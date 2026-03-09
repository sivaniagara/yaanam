part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  otpSent,
  resendLoading,
  forgotPasswordSent,
  passwordUpdated
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final SignupResponseEntity? signupResponse;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.signupResponse,
  });

  factory AuthState.initial() => const AuthState();

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    SignupResponseEntity? signupResponse,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      signupResponse: signupResponse ?? this.signupResponse,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, signupResponse];
}
