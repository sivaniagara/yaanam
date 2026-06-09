import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/trip_entity.dart';
import '../repositories/trip_repository.dart';

class GetTripDetailUseCase {
  final TripRepository repository;

  GetTripDetailUseCase(this.repository);

  Future<Either<Failure, TripEntity>> call(int tripId) async {
    return await repository.getTripDetail(tripId);
  }
}
