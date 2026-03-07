import '../../domain/entities/verify_otp_response_entity.dart';

class VerifyOtpResponseModel extends VerifyOtpResponseEntity {
  const VerifyOtpResponseModel({
    required super.message,
    required super.userId,
    required super.verified,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      message: json['message'] ?? '',
      userId: json['userId'] ?? 0,
      verified: json['verified'] ?? false,
    );
  }
}
