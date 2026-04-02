import '../../domain/entities/signup_response_entity.dart';

class SignupResponseModel extends SignupResponseEntity {
  const SignupResponseModel({
    required super.message,
    required super.userId,
    required super.otpSent,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      message: json['message'] ?? '',
      userId: json['data']['userId'] ?? 0,
      otpSent: json['data']['otpSent'] ?? false,
    );
  }
}
