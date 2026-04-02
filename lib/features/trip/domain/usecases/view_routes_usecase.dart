import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/view_routes_entity.dart';
import '../repositories/trip_repository.dart';

class ViewRoutesUseCase implements UseCase<ViewRoutesResponseEntity, ViewRoutesRequestEntity> {
  final TripRepository repository;

  ViewRoutesUseCase(this.repository);

  @override
  Future<Either<Failure, ViewRoutesResponseEntity>> call(ViewRoutesRequestEntity params) async {
    return await repository.viewRoutes(params);
  }
}
