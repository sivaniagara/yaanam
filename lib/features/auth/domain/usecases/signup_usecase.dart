import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/signup_entity.dart';
import '../entities/signup_response_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<Either<Failure, SignupResponseEntity>> call(SignupEntity signupEntity) async {
    return await repository.signup(signupEntity);
  }
}
