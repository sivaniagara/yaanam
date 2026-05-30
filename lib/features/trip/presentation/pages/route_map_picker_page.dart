import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

const String kGoogleApiKey = "AIzaSyA6xsymZl7I6k6Xl56Si1XxADg2qAccUkQ";

class RouteMapPickerPage extends StatefulWidget {
  final LatLng? initialLocation;
  final String fullAddress;

  const RouteMapPickerPage({
    super.key,
    this.initialLocation,
    required this.fullAddress,
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
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _searchController.text = widget.fullAddress;
      _updateMarker(_selectedLocation!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // 📍 Map tap
  void _onMapTap(LatLng position) async {
    setState(() {
      _selectedLocation = position;
      _updateMarker(position);
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

  void _updateMarker(LatLng position) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('selected_point'),
        position: position,
        draggable: true,
        onDragEnd: (newPosition) {
          setState(() {
            _selectedLocation = newPosition;
            _updateMarker(newPosition);
          });
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueOrange,
        ),
      ),
    );
  }

  // 🔥 Select place
  void _onPlaceSelected(dynamic prediction) {
    final lat = double.tryParse(prediction.lat ?? "0") ?? 0;
    final lng = double.tryParse(prediction.lng ?? "0") ?? 0;

    final latLng = LatLng(lat, lng);

    setState(() {
      _selectedLocation = latLng;
      _updateMarker(latLng);
      _searchController.text = prediction.description ?? '';
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 16),
    );

    // ✅ Keep focus stable
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_searchFocusNode.canRequestFocus) {
        _searchFocusNode.requestFocus();
      }
    });
  }

// ✅ Helper to clean unwanted values (like Plus Codes)
  String cleanText(String? value) {
    if (value == null || value.trim().isEmpty) return '';

    final text = value.trim();

    // Detect Plus Codes like "2XPP+VHJ"
    final plusCodeRegex =
    RegExp(r'^[23456789CFGHJMPQRVWX]{4,}\+[23456789CFGHJMPQRVWX]{2,}$');

    if (plusCodeRegex.hasMatch(text)) return '';

    return text;
  }

// ✅ Confirm location
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

        // ✅ Clean and structured address
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
            .toSet() // ✅ remove duplicates
            .join(', ');

        print("fullAddress : $fullAddress");

        // ✅ Better place name (no plus codes)
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
        print("result : ${result}");

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
                  const LatLng(12.9716, 77.5946),
              zoom: 15,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: _onMapTap,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          // 🔥 FIXED SEARCH BAR (NO FOCUS ISSUE)
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: _searchController,
                focusNode: _searchFocusNode,
                googleAPIKey: kGoogleApiKey,
                inputDecoration: const InputDecoration(
                  hintText: "Search place...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                debounceTime: 400,
                isLatLngRequired: true,
                textStyle: const TextStyle(color: Colors.black),

                getPlaceDetailWithLatLng: (prediction) {
                  _onPlaceSelected(prediction);
                },

                itemClick: (prediction) {
                  _searchController.text = prediction.description ?? '';
                  _searchController.selection =
                      TextSelection.fromPosition(
                        TextPosition(
                            offset: _searchController.text.length),
                      );

                  // ✅ KEEP FOCUS
                  _searchFocusNode.requestFocus();
                },

                isCrossBtnShown: false,
                seperatedBuilder: const Divider(),
                containerHorizontalPadding: 0,
              ),
            ),
          ),

          // ✅ CONFIRM BUTTON
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed:
              _selectedLocation != null ? _confirmLocation : null,
              child: _isLoadingAddress
                  ? const CircularProgressIndicator()
                  : const Text("Confirm Location"),
            ),
          ),
        ],
      ),
    );
  }
}