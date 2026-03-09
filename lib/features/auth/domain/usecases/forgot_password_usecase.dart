import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/forgot_password_request_entity.dart';
import '../entities/forgot_password_response_entity.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, ForgotPasswordResponseEntity>> call(ForgotPasswordRequestEntity params) async {
    return await repository.forgotPassword(params);
  }
}
