import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/resend_otp_request_entity.dart';
import '../entities/resend_otp_response_entity.dart';
import '../repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  Future<Either<Failure, ResendOtpResponseEntity>> call(ResendOtpRequestEntity params) async {
    return await repository.resendOtp(params);
  }
}
