import '../../domain/entities/forgot_password_response_entity.dart';

class ForgotPasswordResponseModel extends ForgotPasswordResponseEntity {
  const ForgotPasswordResponseModel({
    required super.message,
    required super.resetInitiated,
  });

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      message: json['message'] ?? '',
      resetInitiated: json['resetInitiated'] ?? false,
    );
  }
}
