import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:yaanam/core/theme/app_colors.dart';

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

  List<LocationSuggestion> _suggestions = [];
  bool _isSearching = false;

  String _joinAddressParts(List<String?> parts) {
    final seen = <String>{};
    final normalizedParts = <String>[];

    for (final part in parts) {
      final value = part?.trim();
      if (value == null || value.isEmpty) continue;

      final key = value.toLowerCase();
      if (seen.add(key)) {
        normalizedParts.add(value);
      }
    }

    return normalizedParts.join(', ');
  }

  LocationSuggestion _buildSuggestion(Location location, Placemark place) {
    final title = _joinAddressParts([
      place.name,
      place.street,
      place.thoroughfare,
      place.subThoroughfare,
    ]);

    final subtitle = _joinAddressParts([
      place.subLocality,
      place.locality,
      place.subAdministrativeArea,
      place.administrativeArea,
      place.postalCode,
      place.country,
    ]);

    final fullAddress = _joinAddressParts([
      title,
      subtitle,
    ]);

    return LocationSuggestion(
      latLng: LatLng(location.latitude, location.longitude),
      title: title.isNotEmpty ? title : subtitle,
      subtitle: title.isNotEmpty ? subtitle : null,
      description: fullAddress,
    );
  }

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

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _updateMarker(position);
      _searchController.clear();
      _suggestions.clear();
    });
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

  // 🔥 FIXED SEARCH
  Future<void> _searchPlaces(String query) async {
    if (query.length < 2) {
      setState(() {
        _suggestions.clear();
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      List<Location> locations = await locationFromAddress(query);

      // limit results (important)
      locations = locations.take(5).toList();

      List<LocationSuggestion> temp = [];

      for (var loc in locations) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          loc.latitude,
          loc.longitude,
        );

        if (placemarks.isNotEmpty) {
          temp.add(_buildSuggestion(loc, placemarks.first));
        }
      }

      setState(() {
        _suggestions = temp;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _suggestions.clear();
        _isSearching = false;
      });
    }
  }

  void _selectSuggestion(LocationSuggestion suggestion) {
    setState(() {
      _selectedLocation = suggestion.latLng;
      _updateMarker(suggestion.latLng);
      _searchController.text = suggestion.description;
      _suggestions.clear();
      _searchFocusNode.unfocus();
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(suggestion.latLng, 16),
    );
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
          place.name,
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.postalCode,
          place.country,
        ];

        print("addressParts : ${addressParts}");

        final fullAddress = addressParts
            .where((e) => e != null && e!.isNotEmpty)
            .join(', ');

        final result = {
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude,
          'state': place.administrativeArea ?? '',
          'city': place.locality ?? place.subLocality ?? '',
          'placeName': place.locality ??
              place.subLocality ??
              place.street ??
              place.name ??
              '',
          'fullAddress': fullAddress,
        };

        if (mounted) {
          print("result : $result");
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

          // 🔍 SEARCH BAR
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  setState(() {});
                  _searchPlaces(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search place...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _suggestions.clear();
                      setState(() {});
                    },
                  )
                      : null,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // 📍 SUGGESTIONS
          if (_suggestions.isNotEmpty)
            Positioned(
              top: 120,
              left: 16,
              right: 16,
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (_, index) {
                    final item = _suggestions[index];
                    return ListTile(
                      title: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: item.subtitle != null && item.subtitle!.isNotEmpty
                          ? Text(
                              item.subtitle!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      isThreeLine: item.subtitle != null && item.subtitle!.isNotEmpty,
                      onTap: () => _selectSuggestion(item),
                    );
                  },
                ),
              ),
            ),

          // ✅ CONFIRM BUTTON
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _selectedLocation != null
                  ? _confirmLocation
                  : null,
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

class LocationSuggestion {
  final LatLng latLng;
  final String title;
  final String? subtitle;
  final String description;

  LocationSuggestion({
    required this.latLng,
    required this.title,
    this.subtitle,
    required this.description,
  });
}
