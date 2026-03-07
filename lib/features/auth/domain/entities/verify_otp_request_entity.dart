import 'package:equatable/equatable.dart';

class VerifyOtpRequestEntity extends Equatable {
  final int userId;
  final String otp;

  const VerifyOtpRequestEntity({
    required this.userId,
    required this.otp,
  });

  @override
  List<Object?> get props => [userId, otp];
}
