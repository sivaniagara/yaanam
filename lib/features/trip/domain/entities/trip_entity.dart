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
  final LocationDetailEntity source;
  final String startingPoint;
  final LocationDetailEntity destination;
  final String endPoint;
  final List<RoutePointEntity> routeMap;
  final double cost;
  final int maxParticipants;
  final int maxVehicle;
  final CrewEntity crew;
  final String mobile;
  final String publishType;
  final int organiserId;
  final String tripStatus;
  final String paymentType;
  final String? createdAt;
  final String? updatedAt;

  const TripEntity({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.lastDateToJoin,
    required this.rideType,
    required this.vehicleType,
    required this.routeId,
    required this.source,
    required this.startingPoint,
    required this.destination,
    required this.endPoint,
    required this.routeMap,
    required this.cost,
    required this.maxParticipants,
    required this.maxVehicle,
    required this.crew,
    required this.mobile,
    required this.publishType,
    required this.organiserId,
    required this.tripStatus,
    required this.paymentType,
    this.createdAt,
    this.updatedAt,
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
        source,
        startingPoint,
        destination,
        endPoint,
        routeMap,
        cost,
        maxParticipants,
        maxVehicle,
        crew,
        mobile,
        publishType,
        organiserId,
        tripStatus,
        paymentType,
        createdAt,
        updatedAt,
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
