import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/trip_entity.dart';
import '../entities/view_routes_entity.dart';

abstract class TripRepository {
  Future<Either<Failure, TripEntity>> createTrip(TripEntity trip);
  Future<Either<Failure, ViewRoutesResponseEntity>> viewRoutes(ViewRoutesRequestEntity request);
}
