import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/organiser_trip_entity.dart';
import '../entities/trip_entity.dart';
import '../entities/trip_summary_entity.dart';
import '../entities/view_routes_entity.dart';

abstract class TripRepository {
  Future<Either<Failure, TripEntity>> createTrip(TripEntity trip);
  Future<Either<Failure, TripEntity>> updateTrip(TripEntity trip);
  Future<Either<Failure, ViewRoutesResponseEntity>> viewRoutes(ViewRoutesRequestEntity request);
  Future<Either<Failure, List<TripSummaryEntity>>> getTrips(String endpoint);
  Future<Either<Failure, List<OrganiserTripEntity>>> getOrganisedTrips();
  Future<Either<Failure, TripEntity>> getTripDetail(int tripId);
  Future<Either<Failure, Unit>> publishTrip(int tripId);
}
