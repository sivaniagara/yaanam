import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/forgot_password_request_entity.dart';
import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/entities/signup_entity.dart';
import '../../domain/entities/signup_response_entity.dart';
import '../../domain/entities/verify_otp_request_entity.dart';
import '../../domain/entities/resend_otp_request_entity.dart';
import '../../domain/entities/update_password_request_entity.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUseCase signupUseCase;
  final LoginUseCase loginUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;

  AuthBloc({
    required this.signupUseCase,
    required this.loginUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
    required this.forgotPasswordUseCase,
    required this.updatePasswordUseCase,
  }) : super(AuthState.initial()) {
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthVerifyOtpRequested>(_onVerifyOtpRequested);
    on<AuthResendOtpRequested>(_onResendOtpRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthUpdatePasswordRequested>(_onUpdatePasswordRequested);
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

    await result.fold(
      (failure) async {
        print("failure sign in => ${failure.message}");
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ));
      },
      (response) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.token);
        await prefs.setInt('userId', response.user.id);
        await prefs.setString('userName', response.user.name);
        
        emit(state.copyWith(
          status: AuthStatus.authenticated,
        ));
      },
    );
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await signupUseCase(event.signupEntity);
    
    await result.fold(
      (failure) async {
        print('failure');
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ));
      },
      (response) async {
        print('success');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', response.userId);
        await prefs.setString('mobile', event.signupEntity.mobile);
        
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

    await result.fold(
      (failure) async => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (response) async {
        final prefs = await SharedPreferences.getInstance();
        // Assuming verifyOtp also returns a token if it logs the user in immediately
        // If it doesn't, you might need to handle this differently
        emit(state.copyWith(
          status: AuthStatus.authenticated,
        ));
      },
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

  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await forgotPasswordUseCase(ForgotPasswordRequestEntity(
      mobile: event.mobile,
      email: event.email,
    ));

    await result.fold(
      (failure) async => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (response) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('mobile', event.mobile);
        emit(state.copyWith(
          status: AuthStatus.forgotPasswordSent,
        ));
      },
    );
  }

  Future<void> _onUpdatePasswordRequested(
    AuthUpdatePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await updatePasswordUseCase(UpdatePasswordRequestEntity(
      mobile: event.mobile,
      otp: event.otp,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (response) => emit(state.copyWith(
        status: AuthStatus.passwordUpdated,
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
