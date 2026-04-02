import 'package:equatable/equatable.dart';

class TripEntity extends Equatable {
  final int? id;
  final String name;
  final String startDate;
  final String endDate;
  final String lastDateToJoin;
  final String rideType;
  final String vehicleType;
  final int routeId;
  final String sourceCity;
  final String sourceState;
  final String startingPoint;
  final String destinationCity;
  final String destinationState;
  final String endPoint;
  final double cost;
  final int maxParticipants;
  final int maxVehicle;
  final CrewEntity crew;
  final String mobile;
  final String publishType;
  final String tripStatus;
  final String paymentType;

  const TripEntity({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.lastDateToJoin,
    required this.rideType,
    required this.vehicleType,
    required this.routeId,
    required this.sourceCity,
    required this.sourceState,
    required this.startingPoint,
    required this.endPoint,
    required this.destinationCity,
    required this.destinationState,
    required this.cost,
    required this.maxParticipants,
    required this.maxVehicle,
    required this.crew,
    required this.mobile,
    required this.publishType,
    required this.tripStatus,
    required this.paymentType,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        startDate,
        endDate,
        lastDateToJoin,
        rideType,
        vehicleType,
        startingPoint,
        sourceCity,
        sourceState,
        endPoint,
        destinationCity,
        destinationState,
        cost,
        maxParticipants,
        maxVehicle,
        crew,
        mobile,
        publishType,
        tripStatus,
        paymentType,
      ];
}

class LocationDetailEntity extends Equatable {
  final double latitude;
  final double longitude;
  final String city;
  final String state;

  const LocationDetailEntity({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.state,
  });

  @override
  List<Object?> get props => [latitude, longitude, city, state];
}

class RoutePointEntity extends Equatable {
  final double latitude;
  final double longitude;
  final String stopName;

  const RoutePointEntity({
    required this.latitude,
    required this.longitude,
    required this.stopName,
  });

  @override
  List<Object?> get props => [latitude, longitude, stopName];
}

class CrewEntity extends Equatable {
  final CrewMemberEntity servicePerson;
  final CrewMemberEntity organiser;

  const CrewEntity({
    required this.servicePerson,
    required this.organiser,
  });

  @override
  List<Object?> get props => [servicePerson, organiser];
}

class CrewMemberEntity extends Equatable {
  final String name;
  final String contact;

  const CrewMemberEntity({
    required this.name,
    required this.contact,
  });

  @override
  List<Object?> get props => [name, contact];
}
