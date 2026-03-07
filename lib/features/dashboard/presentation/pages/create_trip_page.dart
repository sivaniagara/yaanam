import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:yaanam/core/theme/app_colors.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  
  LatLng? _startLocation;
  LatLng? _destinationLocation;
  final List<LatLng> _stopPoints = [];

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(12.9716, 77.5946), // Bangalore
    zoom: 12,
  );

  void _onMapTap(LatLng position) {
    setState(() {
      if (_startLocation == null) {
        _startLocation = position;
        _addMarker(position, 'Start', BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
      } else if (_destinationLocation == null) {
        _destinationLocation = position;
        _addMarker(position, 'Destination', BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
        _getPolyline();
      } else {
        _stopPoints.add(position);
        _addMarker(position, 'Stop ${_stopPoints.length}', BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure));
      }
    });
  }

  void _addMarker(LatLng position, String id, BitmapDescriptor icon) {
    _markers.add(
      Marker(
        markerId: MarkerId(id),
        position: position,
        icon: icon,
        infoWindow: InfoWindow(title: id),
      ),
    );
  }

  void _getPolyline() async {
    // In a real app, you would use Google Directions API here
    // For this demo, we'll just connect the points directly
    setState(() {
      _polylineCoordinates = [_startLocation!, ..._stopPoints, _destinationLocation!];
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: _polylineCoordinates,
          color: AppColors.primary,
          width: 5,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Trip'),
        backgroundColor: AppColors.primary,
        actions: [
          if (_startLocation != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => setState(() {
                _markers.clear();
                _polylines.clear();
                _startLocation = null;
                _destinationLocation = null;
                _stopPoints.clear();
              }),
            )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
            polylines: _polylines,
            onTap: _onMapTap,
            myLocationEnabled: true,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _startLocation == null 
                    ? 'Tap to set Start Point' 
                    : _destinationLocation == null 
                      ? 'Tap to set Destination' 
                      : 'Tap to add Stops/Hotels',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _destinationLocation != null
          ? FloatingActionButton.extended(
              onPressed: () {
                // Save trip logic
              },
              label: const Text('Save Trip'),
              icon: const Icon(Icons.check),
              backgroundColor: AppColors.primary,
            )
          : null,
    );
  }
}
