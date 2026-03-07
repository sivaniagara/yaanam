import 'package:equatable/equatable.dart';

class VerifyOtpResponseEntity extends Equatable {
  final String message;
  final int userId;
  final bool verified;

  const VerifyOtpResponseEntity({
    required this.message,
    required this.userId,
    required this.verified,
  });

  @override
  List<Object?> get props => [message, userId, verified];
}
