import '../../domain/entities/verify_otp_request_entity.dart';

class VerifyOtpRequestModel extends VerifyOtpRequestEntity {
  const VerifyOtpRequestModel({
    required super.userId,
    required super.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'otp': otp,
    };
  }
}
