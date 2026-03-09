import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/forgot_password_request_entity.dart';
import '../entities/forgot_password_response_entity.dart';
import '../entities/login_request_entity.dart';
import '../entities/login_response_entity.dart';
import '../entities/signup_entity.dart';
import '../entities/signup_response_entity.dart';
import '../entities/verify_otp_request_entity.dart';
import '../entities/verify_otp_response_entity.dart';
import '../entities/resend_otp_request_entity.dart';
import '../entities/resend_otp_response_entity.dart';
import '../entities/update_password_request_entity.dart';
import '../entities/update_password_response_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, SignupResponseEntity>> signup(SignupEntity signupEntity);
  Future<Either<Failure, LoginResponseEntity>> login(LoginRequestEntity loginEntity);
  Future<Either<Failure, VerifyOtpResponseEntity>> verifyOtp(VerifyOtpRequestEntity verifyOtpEntity);
  Future<Either<Failure, ResendOtpResponseEntity>> resendOtp(ResendOtpRequestEntity resendOtpEntity);
  Future<Either<Failure, ForgotPasswordResponseEntity>> forgotPassword(ForgotPasswordRequestEntity forgotPasswordEntity);
  Future<Either<Failure, UpdatePasswordResponseEntity>> updatePassword(UpdatePasswordRequestEntity updatePasswordEntity);
}
