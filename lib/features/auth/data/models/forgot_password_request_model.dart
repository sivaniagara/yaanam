import '../../domain/entities/forgot_password_request_entity.dart';

class ForgotPasswordRequestModel extends ForgotPasswordRequestEntity {
  const ForgotPasswordRequestModel({
    required super.mobile,
    required super.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'email': email,
    };
  }
}
