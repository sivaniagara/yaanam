import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_service.dart';
import '../../../../core/error/exceptions.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/resend_otp_request_model.dart';
import '../models/resend_otp_response_model.dart';
import '../models/signup_model.dart';
import '../models/signup_response_model.dart';
import '../models/verify_otp_request_model.dart';
import '../models/verify_otp_response_model.dart';
import '../models/forgot_password_request_model.dart';
import '../models/forgot_password_response_model.dart';
import '../models/update_password_request_model.dart';
import '../models/update_password_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<SignupResponseModel> signup(SignupModel signupModel);
  Future<LoginResponseModel> login(LoginRequestModel loginModel);
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel verifyOtpModel);
  Future<ResendOtpResponseModel> resendOtp(ResendOtpRequestModel resendOtpModel);
  Future<ForgotPasswordResponseModel> forgotPassword(ForgotPasswordRequestModel forgotPasswordModel);
  Future<UpdatePasswordResponseModel> updatePassword(UpdatePasswordRequestModel updatePasswordModel);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpService httpService;

  AuthRemoteDataSourceImpl({required this.httpService});

  @override
  Future<SignupResponseModel> signup(SignupModel signupModel) async {
    try {
      final response = await httpService.post(
        ApiEndpoints.signup,
        data: signupModel.toJson(),
      );
      print("response signup => ${response.data}");
      return SignupResponseModel.fromJson(response.data);
      // return SignupResponseModel.fromJson({"success": true, "message": "User registered successfully", "data": {"userId": 31, "otpSent": true}});
    } on DioException catch (e) {
      final String message = e.response?.data['error']['message'] ?? 'Signup failed';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error occurred');
    }
  }

  @override
  Future<LoginResponseModel> login(LoginRequestModel loginModel) async {
    print("loginModel.toJson() => ${loginModel.toJson()}");
    try {
      final response = await httpService.post(
        ApiEndpoints.login,
        data: loginModel.toJson(),
      );
      
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final String message = e.response?.data['message'] ?? 'Login failed';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error occurred');
    }
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel verifyOtpModel) async {
    try {
      final response = await httpService.post(
        ApiEndpoints.verifyOtp,
        data: verifyOtpModel.toJson(),
      );
      
      return VerifyOtpResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final String message = e.response?.data['message'] ?? 'OTP verification failed';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error occurred');
    }
  }

  @override
  Future<ResendOtpResponseModel> resendOtp(ResendOtpRequestModel resendOtpModel) async {
    try {
      final response = await httpService.post(
        ApiEndpoints.resendOtp,
        data: resendOtpModel.toJson(),
      );
      
      return ResendOtpResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final String message = e.response?.data['message'] ?? 'OTP resend failed';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error occurred');
    }
  }

  @override
  Future<ForgotPasswordResponseModel> forgotPassword(ForgotPasswordRequestModel forgotPasswordModel) async {
    try {
      final response = await httpService.post(
        ApiEndpoints.forgetPassword,
        data: forgotPasswordModel.toJson(),
      );
      
      return ForgotPasswordResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final String message = e.response?.data['message'] ?? 'Forgot password request failed';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error occurred');
    }
  }

  @override
  Future<UpdatePasswordResponseModel> updatePassword(UpdatePasswordRequestModel updatePasswordModel) async {
    try {
      final response = await httpService.post(
        ApiEndpoints.updatePassword,
        data: updatePasswordModel.toJson(),
      );
      
      return UpdatePasswordResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final String message = e.response?.data['message'] ?? 'Password update failed';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error occurred');
    }
  }
}
