import '../../domain/entities/login_request_entity.dart';

class LoginRequestModel extends LoginRequestEntity {
  const LoginRequestModel({
    required super.mobile,
    required super.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'password': password,
    };
  }
}
