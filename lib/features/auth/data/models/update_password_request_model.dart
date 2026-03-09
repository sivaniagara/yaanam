import '../../domain/entities/update_password_request_entity.dart';

class UpdatePasswordRequestModel extends UpdatePasswordRequestEntity {
  const UpdatePasswordRequestModel({
    required super.mobile,
    required super.otp,
    required super.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'otp': otp,
      'password': password,
    };
  }
}
