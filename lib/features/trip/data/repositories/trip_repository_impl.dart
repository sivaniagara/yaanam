import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_remote_data_source.dart';
import '../models/trip_model.dart';

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
        source: LocationDetailModel(
          latitude: trip.source.latitude,
          longitude: trip.source.longitude,
          city: trip.source.city,
          state: trip.source.state,
        ),
        startingPoint: trip.startingPoint,
        destination: LocationDetailModel(
          latitude: trip.destination.latitude,
          longitude: trip.destination.longitude,
          city: trip.destination.city,
          state: trip.destination.state,
        ),
        endPoint: trip.endPoint,
        routeMap: trip.routeMap
            .map((e) => RoutePointModel(
                  latitude: e.latitude,
                  longitude: e.longitude,
                  stopName: e.stopName,
                ))
            .toList(),
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
        organiserId: trip.organiserId,
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
}
