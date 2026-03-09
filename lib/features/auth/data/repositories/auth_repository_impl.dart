import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/entities/resend_otp_request_entity.dart';
import '../../domain/entities/resend_otp_response_entity.dart';
import '../../domain/entities/signup_entity.dart';
import '../../domain/entities/signup_response_entity.dart';
import '../../domain/entities/verify_otp_request_entity.dart';
import '../../domain/entities/verify_otp_response_entity.dart';
import '../../domain/entities/forgot_password_request_entity.dart';
import '../../domain/entities/forgot_password_response_entity.dart';
import '../../domain/entities/update_password_request_entity.dart';
import '../../domain/entities/update_password_response_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/resend_otp_request_model.dart';
import '../models/signup_model.dart';
import '../models/verify_otp_request_model.dart';
import '../models/forgot_password_request_model.dart';
import '../models/update_password_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SignupResponseEntity>> signup(SignupEntity signupEntity) async {
    try {
      final signupModel = SignupModel(
        name: signupEntity.name,
        dob: signupEntity.dob,
        mobile: signupEntity.mobile,
        email: signupEntity.email,
        interest: signupEntity.interest,
        type: signupEntity.type,
        deviceToken: signupEntity.deviceToken,
        deviceType: signupEntity.deviceType,
        deviceMacAddress: signupEntity.deviceMacAddress,
        profilePhoto: signupEntity.profilePhoto,
        location: LocationModel(
          latitude: signupEntity.location.latitude,
          longitude: signupEntity.location.longitude,
          state: signupEntity.location.state,
          city: signupEntity.location.city,
        ),
        password: signupEntity.password,
      );
      
      final result = await remoteDataSource.signup(signupModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Signup failed. Please try again later.'));
    }
  }

  @override
  Future<Either<Failure, LoginResponseEntity>> login(LoginRequestEntity loginEntity) async {
    try {
      final loginModel = LoginRequestModel(
        mobile: loginEntity.mobile,
        password: loginEntity.password,
      );
      
      final result = await remoteDataSource.login(loginModel);
      
      // Persist token and user details locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', result.token);
      await prefs.setInt('userId', result.user.id);
      await prefs.setString('userName', result.user.name);
      
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Login failed. Please try again later.'));
    }
  }

  @override
  Future<Either<Failure, VerifyOtpResponseEntity>> verifyOtp(VerifyOtpRequestEntity verifyOtpEntity) async {
    try {
      final verifyOtpModel = VerifyOtpRequestModel(
        userId: verifyOtpEntity.userId,
        otp: verifyOtpEntity.otp,
      );
      
      final result = await remoteDataSource.verifyOtp(verifyOtpModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('OTP verification failed. Please try again later.'));
    }
  }

  @override
  Future<Either<Failure, ResendOtpResponseEntity>> resendOtp(ResendOtpRequestEntity resendOtpEntity) async {
    try {
      final resendOtpModel = ResendOtpRequestModel(
        mobile: resendOtpEntity.mobile,
      );
      
      final result = await remoteDataSource.resendOtp(resendOtpModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('OTP resend failed. Please try again later.'));
    }
  }

  @override
  Future<Either<Failure, ForgotPasswordResponseEntity>> forgotPassword(ForgotPasswordRequestEntity forgotPasswordEntity) async {
    try {
      final forgotPasswordModel = ForgotPasswordRequestModel(
        mobile: forgotPasswordEntity.mobile,
        email: forgotPasswordEntity.email,
      );
      
      final result = await remoteDataSource.forgotPassword(forgotPasswordModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Forgot password request failed. Please try again later.'));
    }
  }

  @override
  Future<Either<Failure, UpdatePasswordResponseEntity>> updatePassword(UpdatePasswordRequestEntity updatePasswordEntity) async {
    try {
      final updatePasswordModel = UpdatePasswordRequestModel(
        mobile: updatePasswordEntity.mobile,
        otp: updatePasswordEntity.otp,
        password: updatePasswordEntity.password,
      );
      
      final result = await remoteDataSource.updatePassword(updatePasswordModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Password update failed. Please try again later.'));
    }
  }
}
