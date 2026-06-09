import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../domain/entities/view_routes_entity.dart';

class ViewRoutesRequestModel extends ViewRoutesRequestEntity {
  const ViewRoutesRequestModel({
    required super.source,
    required super.destination,
    super.waypoints,
  });

  Map<String, dynamic> toJson() {
    return {
      'source': (source as RouteLocationModel).toJson(),
      'destination': (destination as RouteLocationModel).toJson(),
      'waypoints': waypoints?.map((e) => (e as RouteLocationModel).toJson()).toList() ?? [],
    };
  }
}

class RouteLocationModel extends RouteLocationEntity {
  const RouteLocationModel({
    required super.lat,
    required super.lng,
    required super.city,
    required super.state,
    required super.name,
  });

  factory RouteLocationModel.fromJson(Map<String, dynamic> json) {
    return RouteLocationModel(
      lat: (json['lat'] as num? ?? 0).toDouble(),
      lng: (json['lng'] as num? ?? 0).toDouble(),
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'city': city,
      'state': state,
      'name': name,
    };
  }
}

class ViewRoutesResponseModel extends ViewRoutesResponseEntity {
  const ViewRoutesResponseModel({
    required super.routeId,
    required super.source,
    required super.destination,
    required super.waypoints,
    required super.polyline,
    required super.polylinePoints,
    required super.distance,
    required super.duration,
    required super.createdAt,
    required super.stops,
  });

  factory ViewRoutesResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final String polylineStr = data['polyline'] ?? '';

    List<PointLatLng> points = [];
    if (polylineStr.isNotEmpty) {
      try {
        points = PolylinePoints.decodePolyline(polylineStr);
      } catch (e) {
        print('Error decoding polyline: $e');
      }
    }

    final source = RouteLocationModel(
      lat: double.tryParse(data['source_lat']?.toString() ?? '0') ?? 0,
      lng: double.tryParse(data['source_lng']?.toString() ?? '0') ?? 0,
      city: data['source_city'] ?? '',
      state: data['source_state'] ?? '',
      name: data['source_name'] ?? '',
    );

    final destination = RouteLocationModel(
      lat: double.tryParse(data['destination_lat']?.toString() ?? '0') ?? 0,
      lng: double.tryParse(data['destination_lng']?.toString() ?? '0') ?? 0,
      city: data['destination_city'] ?? '',
      state: data['destination_state'] ?? '',
      name: data['destination_name'] ?? '',
    );

    List<RouteStopModel> stops = [];
    if (data['stops'] != null && data['stops'] is List) {
      stops = (data['stops'] as List)
          .map((e) => RouteStopModel.fromJson(e))
          .toList();
    }

    // Parse waypoints from response or extract intermediate points from stops
    List<RouteLocationModel> waypointsList = [];
    if (data['waypoints'] != null && data['waypoints'] is List) {
      waypointsList = (data['waypoints'] as List)
          .map((e) => RouteLocationModel.fromJson(e))
          .toList();
    } else if (stops.isNotEmpty) {
      final sortedStops = List<RouteStopModel>.from(stops)..sort((a, b) => a.sequence.compareTo(b.sequence));
      // Source is usually sequence 0 or first stop, Destination is last
      // We only want the waypoints in between
      if (sortedStops.length > 2) {
        waypointsList = sortedStops.sublist(1, sortedStops.length - 1).map((stop) => RouteLocationModel(
          lat: stop.lat,
          lng: stop.lng,
          city: stop.city,
          state: stop.state,
          name: stop.name,
        )).toList();
      }
    }

    return ViewRoutesResponseModel(
      routeId: data['route_id'] ?? 0,
      source: source,
      destination: destination,
      waypoints: waypointsList,
      polyline: polylineStr,
      polylinePoints: points,
      distance: data['distance'] ?? 0,
      duration: data['duration'] ?? 0,
      createdAt: data['created_at'] ?? '',
      stops: stops,
    );
  }
}

class RouteStopModel extends RouteStopEntity {
  const RouteStopModel({
    required super.stopId,
    required super.lat,
    required super.lng,
    required super.city,
    required super.state,
    required super.name,
    required super.sequence,
  });

  factory RouteStopModel.fromJson(Map<String, dynamic> json) {
    return RouteStopModel(
      stopId: json['stop_id'] ?? 0,
      lat: (json['lat'] as num? ?? 0).toDouble(),
      lng: (json['lng'] as num? ?? 0).toDouble(),
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      name: json['name'] ?? '',
      sequence: json['sequence'] ?? 0,
    );
  }
}
