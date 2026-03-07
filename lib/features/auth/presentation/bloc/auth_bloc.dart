import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/entities/signup_entity.dart';
import '../../domain/entities/signup_response_entity.dart';
import '../../domain/entities/verify_otp_request_entity.dart';
import '../../domain/entities/resend_otp_request_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUseCase signupUseCase;
  final LoginUseCase loginUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  AuthBloc({
    required this.signupUseCase,
    required this.loginUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
  }) : super(AuthState.initial()) {
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthVerifyOtpRequested>(_onVerifyOtpRequested);
    on<AuthResendOtpRequested>(_onResendOtpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await loginUseCase(LoginRequestEntity(
      mobile: event.mobileNumber,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (response) => emit(state.copyWith(
        status: AuthStatus.authenticated,
      )),
    );
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await signupUseCase(event.signupEntity);
    
    await result.fold(
      (failure) async => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (response) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', response.userId);
        
        emit(state.copyWith(
          status: AuthStatus.otpSent,
          signupResponse: response,
        ));
      },
    );
  }

  Future<void> _onVerifyOtpRequested(
    AuthVerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await verifyOtpUseCase(VerifyOtpRequestEntity(
      userId: event.userId,
      otp: event.otp,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (response) => emit(state.copyWith(
        status: AuthStatus.authenticated,
      )),
    );
  }

  Future<void> _onResendOtpRequested(
    AuthResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.resendLoading));

    final result = await resendOtpUseCase(ResendOtpRequestEntity(
      mobile: event.mobile,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (response) => emit(state.copyWith(
        status: AuthStatus.otpSent,
      )),
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('userId');
    await prefs.remove('userName');
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }

  Future<void> _onCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      emit(state.copyWith(status: AuthStatus.authenticated));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }
}
