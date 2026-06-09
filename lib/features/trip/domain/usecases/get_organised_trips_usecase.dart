import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/organiser_trip_entity.dart';
import '../repositories/trip_repository.dart';

class GetOrganisedTripsUseCase {
  final TripRepository repository;

  GetOrganisedTripsUseCase(this.repository);

  Future<Either<Failure, List<OrganiserTripEntity>>> call() async {
    return await repository.getOrganisedTrips();
  }
}
