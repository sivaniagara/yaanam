import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/trip_entity.dart';
import '../repositories/trip_repository.dart';

class GetTripsUseCase {
  final TripRepository repository;

  GetTripsUseCase(this.repository);

  Future<Either<Failure, List<TripEntity>>> call(String endpoint) async {
    return await repository.getTrips(endpoint);
  }
}
