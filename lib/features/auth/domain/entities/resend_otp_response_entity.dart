import 'package:equatable/equatable.dart';

class ResendOtpResponseEntity extends Equatable {
  final String message;
  final String mobile;
  final bool resent;

  const ResendOtpResponseEntity({
    required this.message,
    required this.mobile,
    required this.resent,
  });

  @override
  List<Object?> get props => [message, mobile, resent];
}
