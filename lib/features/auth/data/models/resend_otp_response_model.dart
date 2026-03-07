import '../../domain/entities/resend_otp_response_entity.dart';

class ResendOtpResponseModel extends ResendOtpResponseEntity {
  const ResendOtpResponseModel({
    required super.message,
    required super.mobile,
    required super.resent,
  });

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponseModel(
      message: json['message'] ?? '',
      mobile: json['mobile'] ?? '',
      resent: json['resent'] ?? false,
    );
  }
}
