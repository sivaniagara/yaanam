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
    required super.routeId,
    required super.startingPoint,
    required super.sourceCity,
    required super.sourceState,
    required super.endPoint,
    required super.destinationCity,
    required super.destinationState,
    required super.cost,
    required super.maxParticipants,
    required super.maxVehicle,
    required super.crew,
    required super.mobile,
    required super.publishType,
    required super.tripStatus,
    required super.paymentType,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    // If the data is coming from the create trip response, it might be nested under 'data' 
    // and use different keys (e.g., 'trip_id' instead of 'id').
    // We handle the normalization in the data source, but adding resilience here.
    
    return TripModel(
      id: json['id'] ?? json['trip_id'],
      name: json['name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      lastDateToJoin: json['last_date_to_join'] ?? '',
      rideType: json['ride_type'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      routeId: json['route_id'] ?? 0,
      startingPoint: json['starting_point'] ?? (json['source'] != null ? json['source']['name'] : ''),
      sourceCity: json['source_city'] ?? (json['source'] != null ? json['source']['city'] : ''),
      sourceState: json['source_state'] ?? (json['source'] != null ? json['source']['state'] : ''),
      endPoint: json['end_point'] ?? (json['destination'] != null ? json['destination']['name'] : ''),
      destinationCity: json['destination_city'] ?? (json['destination'] != null ? json['destination']['city'] : ''),
      destinationState: json['destination_state'] ?? (json['destination'] != null ? json['destination']['state'] : ''),
      cost: (json['cost'] as num? ?? 0).toDouble(),
      maxParticipants: json['max_participants'] ?? 0,
      maxVehicle: json['max_vehicle'] ?? 0,
      crew: json['crew'] != null 
          ? CrewModel.fromJson(json['crew']) 
          : const CrewModel(
              servicePerson: CrewMemberModel(name: '', contact: ''),
              organiser: CrewMemberModel(name: '', contact: ''),
            ),
      mobile: json['mobile'] ?? '',
      publishType: json['publish_type'] ?? '',
      tripStatus: json['trip_status'] ?? '',
      paymentType: json['payment_type'] ?? '',
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
      'route_id': routeId,
      'starting_point': startingPoint,
      'source_city': sourceCity,
      'source_state': sourceState,
      'end_point': endPoint,
      'destination_city': destinationCity,
      'destination_state': destinationState,
      'cost': cost,
      'max_participants': maxParticipants,
      'max_vehicle': maxVehicle,
      'crew': (crew as CrewModel).toJson(),
      'mobile': mobile,
      'publish_type': publishType,
      'trip_status': tripStatus,
      'payment_type': paymentType,
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
      servicePerson: CrewMemberModel.fromJson(json['service_person'] ?? {}),
      organiser: CrewMemberModel.fromJson(json['organiser'] ?? {}),
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

class LocationDetailModel extends LocationDetailEntity {
  const LocationDetailModel({
    required super.latitude,
    required super.longitude,
    required super.city,
    required super.state,
  });

  factory LocationDetailModel.fromJson(Map<String, dynamic> json) {
    return LocationDetailModel(
      latitude: double.tryParse(json['latitude']?.toString() ?? json['lat']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? json['lng']?.toString() ?? '0') ?? 0.0,
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
      latitude: double.tryParse(json['latitude']?.toString() ?? json['lat']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? json['lng']?.toString() ?? '0') ?? 0.0,
      stopName: json['stop_name'] ?? json['name'] ?? '',
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
