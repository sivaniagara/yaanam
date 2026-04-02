import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yaanam/features/trip/domain/entities/view_routes_entity.dart';
import 'package:yaanam/core/theme/app_colors.dart';

class TripTrackingPage extends StatefulWidget {
  final ViewRoutesResponseEntity routeResponse;

  const TripTrackingPage({
    super.key,
    required this.routeResponse,
  });

  @override
  State<TripTrackingPage> createState() => _TripTrackingPageState();
}

class _TripTrackingPageState extends State<TripTrackingPage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initMapData();
  }

  void _initMapData() {
    // Add Source Marker
    _markers.add(
      Marker(
        markerId: const MarkerId('source'),
        position: LatLng(widget.routeResponse.source.lat, widget.routeResponse.source.lng),
        infoWindow: InfoWindow(title: 'Start: ${widget.routeResponse.source.name}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    // Add Destination Marker
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(widget.routeResponse.destination.lat, widget.routeResponse.destination.lng),
        infoWindow: InfoWindow(title: 'End: ${widget.routeResponse.destination.name}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    // Add Stop Markers
    for (var stop in widget.routeResponse.stops) {
      _markers.add(
        Marker(
          markerId: MarkerId('stop_${stop.stopId}'),
          position: LatLng(stop.lat, stop.lng),
          infoWindow: InfoWindow(title: 'Stop ${stop.sequence}: ${stop.name}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    }

    // Add Polyline
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: widget.routeResponse.polylinePoints
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList(),
        color: AppColors.primary,
        width: 5,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fitBounds();
  }

  void _fitBounds() {
    if (_mapController == null) return;

    final List<LatLng> points = widget.routeResponse.polylinePoints
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    if (points.isEmpty) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        50, // Padding
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Route'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.routeResponse.source.lat, widget.routeResponse.source.lng),
              zoom: 12,
            ),
            onMapCreated: _onMapCreated,
            markers: _markers,
            polylines: _polylines,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          
          // Route Info Card
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoItem(Icons.directions_car, '${(widget.routeResponse.distance / 1000).toStringAsFixed(1)} km'),
                        _infoItem(Icons.access_time, '${(widget.routeResponse.duration / 60).toStringAsFixed(0)} mins'),
                        _infoItem(Icons.location_on, '${widget.routeResponse.stops.length} Stops'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
