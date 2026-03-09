import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/update_password_request_entity.dart';
import '../entities/update_password_response_entity.dart';
import '../repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  final AuthRepository repository;

  UpdatePasswordUseCase(this.repository);

  Future<Either<Failure, UpdatePasswordResponseEntity>> call(UpdatePasswordRequestEntity params) async {
    return await repository.updatePassword(params);
  }
}
