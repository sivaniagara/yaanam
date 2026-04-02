import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/trip_entity.dart';
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
      final tripModel = TripModel(
        name: trip.name,
        startDate: trip.startDate,
        endDate: trip.endDate,
        lastDateToJoin: trip.lastDateToJoin,
        rideType: trip.rideType,
        vehicleType: trip.vehicleType,
        routeId: trip.routeId,
        // source: LocationDetailModel(
        //   latitude: trip.source.latitude,
        //   longitude: trip.source.longitude,
        //   city: trip.source.city,
        //   state: trip.source.state,
        // ),
        startingPoint: trip.startingPoint,
        sourceCity: trip.sourceCity,
        sourceState: trip.sourceState,
        // destination: LocationDetailModel(
        //   latitude: trip.destination.latitude,
        //   longitude: trip.destination.longitude,
        //   city: trip.destination.city,
        //   state: trip.destination.state,
        // ),
        endPoint: trip.endPoint,
        destinationCity: trip.destinationCity,
        destinationState: trip.destinationState,
        // routeMap: trip.routeMap
        //     .map((e) => RoutePointModel(
        //           latitude: e.latitude,
        //           longitude: e.longitude,
        //           stopName: e.stopName,
        //         ))
        //     .toList(),
        cost: trip.cost,
        maxParticipants: trip.maxParticipants,
        maxVehicle: trip.maxVehicle,
        crew: trip.crew.map((e){
          return CrewMemberModel(name: e.name, contact: e.contact, role: e.role);
        }).toList(),
        mobile: trip.mobile,
        publishType: trip.publishType,
        // organiserId: trip.organiserId,
        tripStatus: trip.tripStatus,
        paymentType: trip.paymentType,
      );

      final result = await remoteDataSource.createTrip(tripModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred while creating the trip'));
    }
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
      );

      final result = await remoteDataSource.viewRoutes(requestModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred while fetching routes'));
    }
  }
}
