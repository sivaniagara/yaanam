import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState.initial()) {
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    // TODO: Implement actual sign in logic with repository
    await Future.delayed(const Duration(seconds: 2));
    
    if (event.loginId == 'admin' && event.password == 'password') {
      emit(state.copyWith(status: AuthStatus.authenticated));
    } else {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Invalid credentials',
      ));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    // TODO: Implement sign out logic
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }

  Future<void> _onCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    // TODO: Check if user is already logged in
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }
}
