import 'package:equatable/equatable.dart';

class SignupResponseEntity extends Equatable {
  final String message;
  final int userId;
  final bool otpSent;

  const SignupResponseEntity({
    required this.message,
    required this.userId,
    required this.otpSent,
  });

  @override
  List<Object?> get props => [message, userId, otpSent];
}
