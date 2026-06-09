import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

const String kGoogleApiKey = "AIzaSyA6xsymZl7I6k6Xl56Si1XxADg2qAccUkQ";

class RouteMapPickerPage extends StatefulWidget {
  final LatLng? initialLocation;
  final String fullAddress;
  final LatLng? sourceLocation;
  final String? sourceAddress;

  const RouteMapPickerPage({
    super.key,
    this.initialLocation,
    required this.fullAddress,
    this.sourceLocation,
    this.sourceAddress,
  });

  @override
  State<RouteMapPickerPage> createState() => _RouteMapPickerPageState();
}

class _RouteMapPickerPageState extends State<RouteMapPickerPage> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;

  final Set<Marker> _markers = {};
  bool _isLoadingAddress = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _sourceInfoController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.sourceAddress != null) {
      _sourceInfoController.text = widget.sourceAddress!;
    }

    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _searchController.text = widget.fullAddress;
    }
    _updateMarkers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sourceInfoController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onMapTap(LatLng position) async {
    setState(() {
      _selectedLocation = position;
      _updateMarkers();
    });

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final address = [
          place.name,
          place.locality,
          place.administrativeArea,
        ].where((e) => e?.isNotEmpty ?? false).join(', ');

        _searchController.text = address;
      }
    } catch (_) {}
  }

  void _updateMarkers() {
    setState(() {
      _markers.clear();

      // Source Marker (Fixed Blue Pin)
      if (widget.sourceLocation != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('source_point'),
            position: widget.sourceLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            infoWindow: const InfoWindow(title: 'Starting Point'),
          ),
        );
      }

      // Selected Point Marker (Red Pin)
      if (_selectedLocation != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('selected_point'),
            position: _selectedLocation!,
            draggable: true,
            onDragEnd: (newPosition) {
              setState(() {
                _selectedLocation = newPosition;
                _updateMarkers();
              });
            },
            icon: BitmapDescriptor.defaultMarker, // Default Red
          ),
        );
      }
    });
  }

  void _onPlaceSelected(dynamic prediction) {
    final lat = double.tryParse(prediction.lat ?? "0") ?? 0;
    final lng = double.tryParse(prediction.lng ?? "0") ?? 0;

    final latLng = LatLng(lat, lng);

    setState(() {
      _selectedLocation = latLng;
      _updateMarkers();
      _searchController.text = prediction.description ?? '';
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 16),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_searchFocusNode.canRequestFocus) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  String cleanText(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    final text = value.trim();
    final plusCodeRegex = RegExp(r'^[23456789CFGHJMPQRVWX]{4,}\+[23456789CFGHJMPQRVWX]{2,}$');
    if (plusCodeRegex.hasMatch(text)) return '';
    return text;
  }

  Future<void> _confirmLocation() async {
    if (_selectedLocation == null) return;
    setState(() => _isLoadingAddress = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final addressParts = [
          cleanText(place.name),
          cleanText(place.street),
          cleanText(place.subLocality),
          cleanText(place.locality),
          cleanText(place.administrativeArea),
          cleanText(place.postalCode),
          cleanText(place.country),
        ];

        final fullAddress = addressParts
            .where((e) => e.isNotEmpty)
            .toSet()
            .join(', ');

        String placeName = '';
        if (cleanText(place.locality).isNotEmpty) {
          placeName = cleanText(place.locality);
        } else if (cleanText(place.subLocality).isNotEmpty) {
          placeName = cleanText(place.subLocality);
        } else if (cleanText(place.street).isNotEmpty) {
          placeName = cleanText(place.street);
        }

        final city = cleanText(place.locality).isNotEmpty
            ? cleanText(place.locality)
            : cleanText(place.subLocality);

        final result = {
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude,
          'state': cleanText(place.administrativeArea),
          'city': city,
          'placeName': placeName,
          'fullAddress': fullAddress,
        };

        if (mounted) {
          Navigator.of(context).pop(result);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get address: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingAddress = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialLocation ??
                  widget.sourceLocation ??
                  const LatLng(12.9716, 77.5946),
              zoom: 15,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: _onMapTap,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            padding: const EdgeInsets.only(top: 200),
          ),

          // Custom AppBar / Header Section
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.chevron_left, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        "Route Map",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 45), // Balancing spacer
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      if (widget.sourceAddress != null) ...[
                        _buildInputField(
                          controller: _sourceInfoController,
                          hint: "Source Point",
                          readOnly: true,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 36),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("⋮", style: TextStyle(color: Colors.grey, fontSize: 18, height: 0.8)),
                          ),
                        ),
                      ],
                      GooglePlaceAutoCompleteTextField(
                        textEditingController: _searchController,
                        focusNode: _searchFocusNode,
                        googleAPIKey: kGoogleApiKey,
                        inputDecoration: InputDecoration(
                          hintText: widget.sourceLocation != null ? "Search End Point" : "Search place...",
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        debounceTime: 400,
                        isLatLngRequired: true,
                        textStyle: const TextStyle(color: Colors.black, fontSize: 14),
                        getPlaceDetailWithLatLng: (prediction) {
                          _onPlaceSelected(prediction);
                        },
                        itemClick: (prediction) {
                          _searchController.text = prediction.description ?? '';
                          _searchController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _searchController.text.length),
                          );
                          _searchFocusNode.requestFocus();
                        },
                        isCrossBtnShown: false,
                        seperatedBuilder: const Divider(),
                        containerHorizontalPadding: 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Confirm Button
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedLocation != null ? _confirmLocation : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCA5049),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: _isLoadingAddress
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Confirm Location", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required bool readOnly,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}
