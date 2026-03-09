import 'package:equatable/equatable.dart';

class ForgotPasswordRequestEntity extends Equatable {
  final String mobile;
  final String email;

  const ForgotPasswordRequestEntity({
    required this.mobile,
    required this.email,
  });

  @override
  List<Object?> get props => [mobile, email];
}
