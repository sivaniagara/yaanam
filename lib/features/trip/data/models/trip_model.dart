import '../../domain/entities/trip_entity.dart';

class TripModel extends TripEntity {
  const TripModel({
    super.id,
    required super.name,
    required super.startDate,
    required super.endDate,
    required super.lastDateToJoin,
    required super.rideType,
    required super.vehicleType,
    required super.source,
    required super.startingPoint,
    required super.destination,
    required super.endPoint,
    required super.routeMap,
    required super.cost,
    required super.maxParticipants,
    required super.maxVehicle,
    required super.crew,
    required super.mobile,
    required super.publishType,
    required super.organiserId,
    required super.tripStatus,
    required super.paymentType,
    super.createdAt,
    super.updatedAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      name: json['name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      lastDateToJoin: json['last_date_to_join'] ?? '',
      rideType: json['ride_type'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      source: LocationDetailModel.fromJson(json['source']),
      startingPoint: json['starting_point'] ?? '',
      destination: LocationDetailModel.fromJson(json['destination']),
      endPoint: json['end_point'] ?? '',
      routeMap: (json['route_map'] as List? ?? [])
          .map((e) => RoutePointModel.fromJson(e))
          .toList(),
      cost: (json['cost'] as num? ?? 0).toDouble(),
      maxParticipants: json['max_participants'] ?? 0,
      maxVehicle: json['max_vehicle'] ?? 0,
      crew: CrewModel.fromJson(json['crew']),
      mobile: json['mobile'] ?? '',
      publishType: json['publish_type'] ?? '',
      organiserId: json['organiser_id'] ?? 0,
      tripStatus: json['trip_status'] ?? '',
      paymentType: json['payment_type'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'start_date': startDate,
      'end_date': endDate,
      'last_date_to_join': lastDateToJoin,
      'ride_type': rideType,
      'vehicle_type': vehicleType,
      'source': (source as LocationDetailModel).toJson(),
      'starting_point': startingPoint,
      'destination': (destination as LocationDetailModel).toJson(),
      'end_point': endPoint,
      'route_map': routeMap.map((e) => (e as RoutePointModel).toJson()).toList(),
      'cost': cost,
      'max_participants': maxParticipants,
      'max_vehicle': maxVehicle,
      'crew': (crew as CrewModel).toJson(),
      'mobile': mobile,
      'publish_type': publishType,
      'organiser_id': organiserId,
      'trip_status': tripStatus,
      'payment_type': paymentType,
    };
  }
}

class LocationDetailModel extends LocationDetailEntity {
  const LocationDetailModel({
    required super.latitude,
    required super.longitude,
    required super.city,
    required super.state,
  });

  factory LocationDetailModel.fromJson(Map<String, dynamic> json) {
    return LocationDetailModel(
      latitude: (json['latitude'] as num? ?? 0).toDouble(),
      longitude: (json['longitude'] as num? ?? 0).toDouble(),
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'state': state,
    };
  }
}

class RoutePointModel extends RoutePointEntity {
  const RoutePointModel({
    required super.latitude,
    required super.longitude,
    required super.stopName,
  });

  factory RoutePointModel.fromJson(Map<String, dynamic> json) {
    return RoutePointModel(
      latitude: (json['latitude'] as num? ?? 0).toDouble(),
      longitude: (json['longitude'] as num? ?? 0).toDouble(),
      stopName: json['stop_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'stop_name': stopName,
    };
  }
}

class CrewModel extends CrewEntity {
  const CrewModel({
    required super.servicePerson,
    required super.organiser,
  });

  factory CrewModel.fromJson(Map<String, dynamic> json) {
    return CrewModel(
      servicePerson: CrewMemberModel.fromJson(json['service_person']),
      organiser: CrewMemberModel.fromJson(json['organiser']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_person': (servicePerson as CrewMemberModel).toJson(),
      'organiser': (organiser as CrewMemberModel).toJson(),
    };
  }
}

class CrewMemberModel extends CrewMemberEntity {
  const CrewMemberModel({
    required super.name,
    required super.contact,
  });

  factory CrewMemberModel.fromJson(Map<String, dynamic> json) {
    return CrewMemberModel(
      name: json['name'] ?? '',
      contact: json['contact'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact': contact,
    };
  }
}
