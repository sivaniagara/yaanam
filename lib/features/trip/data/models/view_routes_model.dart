import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:yaanam/core/environment/app_config.dart';
import '../../domain/entities/view_routes_entity.dart';

class ViewRoutesRequestModel extends ViewRoutesRequestEntity {
  const ViewRoutesRequestModel({
    required super.source,
    required super.destination,
  });

  Map<String, dynamic> toJson() {
    return {
      'source': (source as RouteLocationModel).toJson(),
      'destination': (destination as RouteLocationModel).toJson(),
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

  // Factory method for the server response format
  factory RouteLocationModel.fromServerJson(Map<String, dynamic> json, {required bool isSource}) {
    return RouteLocationModel(
      lat: double.tryParse(json[isSource ? 'source_lat' : 'destination_lat']?.toString() ?? '0') ?? 0,
      lng: double.tryParse(json[isSource ? 'source_lng' : 'destination_lng']?.toString() ?? '0') ?? 0,
      city: json[isSource ? 'source_city' : 'destination_city'] ?? '',
      state: json[isSource ? 'source_state' : 'destination_state'] ?? '',
      name: json[isSource ? 'source_name' : 'destination_name'] ?? '',
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
    // Extract the nested data object
    final data = json['data'] ?? json; // Handle both nested and flat structures

    final String polylineStr = data['polyline'] ?? '';

    // Decode polyline - returns List<PointLatLng>
    List<PointLatLng> points = [];

    if (polylineStr.isNotEmpty) {
      try {
        points = PolylinePoints.decodePolyline(polylineStr);
      } catch (e) {
        print('Error decoding polyline: $e');
      }
    }

    // Create source and destination from the server's flat structure
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

    // Parse stops if they exist
    List<RouteStopModel> stops = [];
    if (data['stops'] != null && data['stops'] is List) {
      stops = (data['stops'] as List)
          .map((e) => RouteStopModel.fromJson(e))
          .toList();
    }

    return ViewRoutesResponseModel(
      routeId: data['route_id'] ?? 0,
      source: source,
      destination: destination,
      waypoints: [], // No waypoints in your response
      polyline: polylineStr,
      polylinePoints: points,
      distance: data['distance'] ?? 0,
      duration: data['duration'] ?? 0,
      createdAt: data['created_at'] ?? '',
      stops: stops,
    );
  }

  // Optional: Add a convenience method to convert to LatLng for Google Maps
  List<LatLng> get polylineAsLatLng {
    return polylinePoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
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