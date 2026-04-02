import 'package:equatable/equatable.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class ViewRoutesRequestEntity extends Equatable {
  final RouteLocationEntity source;
  final RouteLocationEntity destination;

  const ViewRoutesRequestEntity({
    required this.source,
    required this.destination,
  });

  @override
  List<Object?> get props => [source, destination];
}

class RouteLocationEntity extends Equatable {
  final double lat;
  final double lng;
  final String city;
  final String state;
  final String name;

  const RouteLocationEntity({
    required this.lat,
    required this.lng,
    required this.city,
    required this.state,
    required this.name,
  });

  @override
  List<Object?> get props => [lat, lng, city, state, name];
}

class ViewRoutesResponseEntity extends Equatable {
  final int routeId;
  final RouteLocationEntity source;
  final RouteLocationEntity destination;
  final List<RouteLocationEntity> waypoints;
  final String polyline;
  final List<PointLatLng> polylinePoints; // ✅ Expects PointLatLng
  final int distance;
  final int duration;
  final String createdAt;
  final List<RouteStopEntity> stops;

  const ViewRoutesResponseEntity({
    required this.routeId,
    required this.source,
    required this.destination,
    required this.waypoints,
    required this.polyline,
    required this.polylinePoints,
    required this.distance,
    required this.duration,
    required this.createdAt,
    required this.stops,
  });

  @override
  List<Object?> get props => [
    routeId,
    source,
    destination,
    waypoints,
    polyline,
    polylinePoints,
    distance,
    duration,
    createdAt,
    stops,
  ];
}

class RouteStopEntity extends Equatable {
  final int stopId;
  final double lat;
  final double lng;
  final String city;
  final String state;
  final String name;
  final int sequence;

  const RouteStopEntity({
    required this.stopId,
    required this.lat,
    required this.lng,
    required this.city,
    required this.state,
    required this.name,
    required this.sequence,
  });

  @override
  List<Object?> get props => [stopId, lat, lng, city, state, name, sequence];
}
