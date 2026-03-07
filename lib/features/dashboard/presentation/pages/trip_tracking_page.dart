import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yaanam/core/theme/app_colors.dart';

class TripTrackingPage extends StatefulWidget {
  const TripTrackingPage({super.key});

  @override
  State<TripTrackingPage> createState() => _TripTrackingPageState();
}

class _TripTrackingPageState extends State<TripTrackingPage> {
  GoogleMapController? _mapController;

  // Mock data for users in the trip
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('user1'),
      position: LatLng(12.9716, 77.5946),
      infoWindow: InfoWindow(title: 'Ragunath (You)'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    Marker(
      markerId: const MarkerId('user2'),
      position: const LatLng(12.9816, 77.6046),
      infoWindow: const InfoWindow(title: 'Alice'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ),
    Marker(
      markerId: const MarkerId('user3'),
      position: const LatLng(12.9616, 77.5846),
      infoWindow: const InfoWindow(title: 'Bob'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Trip Tracking'),
        backgroundColor: AppColors.primary,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(12.9716, 77.5946),
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '3 Members are live',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const CircleAvatar(child: Text('R')),
                      title: const Text('Ragunath K'),
                      subtitle: const Text('Active now'),
                      trailing: IconButton(
                        icon: const Icon(Icons.my_location, color: AppColors.primary),
                        onPressed: () {
                          _mapController?.animateCamera(
                            CameraUpdate.newLatLng(const LatLng(12.9716, 77.5946)),
                          );
                        },
                      ),
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
}
