import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/organiser_trip_entity.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/trip_summary_entity.dart';
import '../../domain/entities/view_routes_entity.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_remote_data_source.dart';
import '../models/trip_model.dart';
import '../models/view_routes_model.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;

  TripRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TripEntity>> createTrip(TripEntity trip) async {
    try {
      final tripModel = _toModel(trip);
      final result = await remoteDataSource.createTrip(tripModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred while creating the trip'));
    }
  }

  @override
  Future<Either<Failure, TripEntity>> updateTrip(TripEntity trip) async {
    try {
      final tripModel = _toModel(trip);
      final result = await remoteDataSource.updateTrip(tripModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred while updating the trip'));
    }
  }

  TripModel _toModel(TripEntity trip) {
    return TripModel(
      id: trip.id,
      name: trip.name,
      startDate: trip.startDate,
      endDate: trip.endDate,
      lastDateToJoin: trip.lastDateToJoin,
      rideType: trip.rideType,
      vehicleType: trip.vehicleType,
      routeId: trip.routeId,
      startingPoint: trip.startingPoint,
      sourceLat: trip.sourceLat,
      sourceLng: trip.sourceLng,
      sourceCity: trip.sourceCity,
      sourceState: trip.sourceState,
      endPoint: trip.endPoint,
      destinationLat: trip.destinationLat,
      destinationLng: trip.destinationLng,
      destinationCity: trip.destinationCity,
      destinationState: trip.destinationState,
      cost: trip.cost,
      maxParticipants: trip.maxParticipants,
      maxVehicle: trip.maxVehicle,
      crew: CrewModel(
        servicePerson: CrewMemberModel(
          name: trip.crew.servicePerson.name,
          contact: trip.crew.servicePerson.contact,
        ),
        organiser: CrewMemberModel(
          name: trip.crew.organiser.name,
          contact: trip.crew.organiser.contact,
        ),
      ),
      mobile: trip.mobile,
      publishType: trip.publishType,
      tripStatus: trip.tripStatus,
      paymentType: trip.paymentType,
    );
  }

  @override
  Future<Either<Failure, ViewRoutesResponseEntity>> viewRoutes(ViewRoutesRequestEntity request) async {
    try {
      final requestModel = ViewRoutesRequestModel(
        source: RouteLocationModel(
          lat: request.source.lat,
          lng: request.source.lng,
          city: request.source.city,
          state: request.source.state,
          name: request.source.name,
        ),
        destination: RouteLocationModel(
          lat: request.destination.lat,
          lng: request.destination.lng,
          city: request.destination.city,
          state: request.destination.state,
          name: request.destination.name,
        ),
        waypoints: request.waypoints?.map((e) => RouteLocationModel(
          lat: e.lat,
          lng: e.lng,
          city: e.city,
          state: e.state,
          name: e.name,
        )).toList(),
      );

      final result = await remoteDataSource.viewRoutes(requestModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred while fetching routes'));
    }
  }

  @override
  Future<Either<Failure, List<TripSummaryEntity>>> getTrips(String endpoint) async {
    try {
      final result = await remoteDataSource.getTrips(endpoint);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred while fetching trips'));
    }
  }

  @override
  Future<Either<Failure, List<OrganiserTripEntity>>> getOrganisedTrips() async {
    try {
      final result = await remoteDataSource.getOrganisedTrips();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred while fetching organised trips'));
    }
  }

  @override
  Future<Either<Failure, TripEntity>> getTripDetail(int tripId) async {
    try {
      final result = await remoteDataSource.getTripDetail(tripId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred while fetching trip details'));
    }
  }

  @override
  Future<Either<Failure, Unit>> publishTrip(int tripId) async {
    try {
      await remoteDataSource.publishTrip(tripId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred while publishing the trip'));
    }
  }
}
