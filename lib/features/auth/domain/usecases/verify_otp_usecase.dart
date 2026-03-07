import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/verify_otp_request_entity.dart';
import '../entities/verify_otp_response_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, VerifyOtpResponseEntity>> call(VerifyOtpRequestEntity params) async {
    return await repository.verifyOtp(params);
  }
}
