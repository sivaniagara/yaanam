import '../../domain/entities/resend_otp_request_entity.dart';

class ResendOtpRequestModel extends ResendOtpRequestEntity {
  const ResendOtpRequestModel({required super.mobile});

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
    };
  }
}
