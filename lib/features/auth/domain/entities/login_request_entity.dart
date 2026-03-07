import 'package:equatable/equatable.dart';

class LoginRequestEntity extends Equatable {
  final String mobile;
  final String password;

  const LoginRequestEntity({
    required this.mobile,
    required this.password,
  });

  @override
  List<Object?> get props => [mobile, password];
}
