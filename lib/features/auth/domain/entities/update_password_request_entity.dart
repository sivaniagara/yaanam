import 'package:equatable/equatable.dart';

class UpdatePasswordRequestEntity extends Equatable {
  final String mobile;
  final String otp;
  final String password;

  const UpdatePasswordRequestEntity({
    required this.mobile,
    required this.otp,
    required this.password,
  });

  @override
  List<Object?> get props => [mobile, otp, password];
}
