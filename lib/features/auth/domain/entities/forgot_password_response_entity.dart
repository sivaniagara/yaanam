import 'package:equatable/equatable.dart';

class ForgotPasswordResponseEntity extends Equatable {
  final String message;
  final bool resetInitiated;

  const ForgotPasswordResponseEntity({
    required this.message,
    required this.resetInitiated,
  });

  @override
  List<Object?> get props => [message, resetInitiated];
}
