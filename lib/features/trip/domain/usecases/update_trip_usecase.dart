import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/trip_entity.dart';
import '../repositories/trip_repository.dart';

class UpdateTripUseCase {
  final TripRepository repository;

  UpdateTripUseCase(this.repository);

  Future<Either<Failure, TripEntity>> call(TripEntity trip) async {
    return await repository.updateTrip(trip);
  }
}
