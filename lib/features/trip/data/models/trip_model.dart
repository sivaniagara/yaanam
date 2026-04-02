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
    return TripModel(
      id: json['id'],
      name: json['name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      lastDateToJoin: json['last_date_to_join'] ?? '',
      rideType: json['ride_type'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      routeId: json['route_id'] ?? 0,
      startingPoint: json['starting_point'] ?? '',
      sourceCity: json['source_city'] ?? '',
      sourceState: json['source_state'] ?? '',
      endPoint: json['end_point'] ?? '',
      destinationCity: json['destination_city'] ?? '',
      destinationState: json['destination_state'] ?? '',
      cost: (json['cost'] as num? ?? 0).toDouble(),
      maxParticipants: json['max_participants'] ?? 0,
      maxVehicle: json['max_vehicle'] ?? 0,
      crew: (json['crew'] as List? ?? [])
          .map((e) => CrewMemberModel.fromJson(e))
          .toList(),
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
      'crew': crew.map((e) => (e as CrewMemberModel).toJson()).toList(),
      'mobile': mobile,
      'publish_type': publishType,
      'trip_status': tripStatus,
      'payment_type': paymentType,
    };
  }
}

class CrewMemberModel extends CrewMemberEntity {
  const CrewMemberModel({
    required super.name,
    required super.contact,
    required super.role,
  });

  factory CrewMemberModel.fromJson(Map<String, dynamic> json) {
    return CrewMemberModel(
      name: json['name'] ?? '',
      contact: json['contact'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact': contact,
      'role': role,
    };
  }
}
