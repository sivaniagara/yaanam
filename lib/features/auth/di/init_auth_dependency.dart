import '../../../core/di/dependency_injection.dart';
import '../data/datasources/auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/signup_usecase.dart';
import '../domain/usecases/update_password_usecase.dart';
import '../domain/usecases/verify_otp_usecase.dart';
import '../domain/usecases/resend_otp_usecase.dart';
import '../domain/usecases/forgot_password_usecase.dart';
import '../presentation/bloc/auth_bloc.dart';

void initAuthDependency(){
  sl.registerFactory(() => AuthBloc(
    signupUseCase: sl(),
    loginUseCase: sl(),
    verifyOtpUseCase: sl(),
    resendOtpUseCase: sl(),
    forgotPasswordUseCase: sl(),
    updatePasswordUseCase: sl(),
  ));
  sl.registerLazySingleton(() => UpdatePasswordUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResendOtpUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(httpService: sl()));
}