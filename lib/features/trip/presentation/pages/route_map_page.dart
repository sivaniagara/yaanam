import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:yaanam/core/theme/app_colors.dart';
import 'package:yaanam/features/trip/domain/entities/view_routes_entity.dart';
import 'package:yaanam/features/trip/presentation/bloc/trip_bloc.dart';

const String kGoogleApiKey = "AIzaSyA6xsymZl7I6k6Xl56Si1XxADg2qAccUkQ";

class RouteMapPage extends StatefulWidget {
  final RouteLocationEntity source;
  final RouteLocationEntity destination;
  final List<RouteLocationEntity>? initialWaypoints;

  const RouteMapPage({
    super.key,
    required this.source,
    required this.destination,
    this.initialWaypoints,
  });

  @override
  State<RouteMapPage> createState() => _RouteMapPageState();
}

class _RouteMapPageState extends State<RouteMapPage> {
  GoogleMapController? _mapController;

  /// Single source of truth for waypoints on this screen.
  final List<RouteLocationEntity> _waypoints = [];

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isAddingWaypoint = false;

  @override
  void initState() {
    super.initState();

    // 1. Seed waypoints from the caller (CreateTripPage always passes these).
    if (widget.initialWaypoints != null && widget.initialWaypoints!.isNotEmpty) {
      _waypoints.addAll(widget.initialWaypoints!);
    }

    // 2. If the bloc already holds a completed route, render it immediately.
    final blocState = context.read<TripBloc>().state;
    final existingRoute = blocState.routeResponse;

    if (existingRoute != null && existingRoute.polylinePoints.isNotEmpty) {
      // Restore polyline.
      _polylines = _buildPolylines(existingRoute.polylinePoints);

      // Fit the camera after the first frame (map controller available).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitBounds(existingRoute.polylinePoints
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList());
      });
    } else {
      // No existing route — auto-fetch so the user sees something right away.
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchRoute());
    }

    // 3. Draw all markers (source, destination, waypoints).
    _updateMarkers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Set<Polyline> _buildPolylines(List<dynamic> polylinePoints) {
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: polylinePoints
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList(),
        color: const Color(0xFFCA5049),
        width: 6,
      ),
    };
  }

  void _fetchRoute() {
    final request = ViewRoutesRequestEntity(
      source: widget.source,
      destination: widget.destination,
      waypoints: List<RouteLocationEntity>.from(_waypoints),
    );
    context.read<TripBloc>().add(ViewRoutesRequested(request));
  }

  void _updateMarkers() {
    final newMarkers = <Marker>{};

    // Source marker (fixed, blue).
    newMarkers.add(Marker(
      markerId: const MarkerId('source'),
      position: LatLng(widget.source.lat, widget.source.lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(title: 'Start: ${widget.source.name}'),
    ));

    // Destination marker (fixed, red).
    newMarkers.add(Marker(
      markerId: const MarkerId('destination'),
      position: LatLng(widget.destination.lat, widget.destination.lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: 'End: ${widget.destination.name}'),
    ));

    // Waypoint markers (draggable, orange).
    for (int i = 0; i < _waypoints.length; i++) {
      final wp = _waypoints[i];
      newMarkers.add(Marker(
        markerId: MarkerId('waypoint_$i'),
        position: LatLng(wp.lat, wp.lng),
        draggable: true,
        onDragEnd: (newPos) => _onWaypointDragged(i, newPos),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(title: 'Stop ${i + 1}: ${wp.name}'),
      ));
    }

    setState(() => _markers = newMarkers);
  }

  Future<void> _onWaypointDragged(int index, LatLng newPosition) async {
    String city = _waypoints[index].city;
    String state = _waypoints[index].state;
    String name = _waypoints[index].name;

    try {
      final placemarks = await placemarkFromCoordinates(
          newPosition.latitude, newPosition.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        city = place.locality ?? place.subLocality ?? city;
        state = place.administrativeArea ?? state;
        name = [place.name, place.subLocality, place.locality]
            .where((e) => e != null && e.isNotEmpty)
            .join(', ');
      }
    } catch (e) {
      debugPrint('Reverse geocode error: $e');
    }

    setState(() {
      _waypoints[index] = RouteLocationEntity(
        lat: newPosition.latitude,
        lng: newPosition.longitude,
        city: city,
        state: state,
        name: name,
      );
    });
    _updateMarkers();
  }

  Future<void> _onPlaceSelected(dynamic prediction) async {
    final lat = double.tryParse(prediction.lat ?? '0') ?? 0;
    final lng = double.tryParse(prediction.lng ?? '0') ?? 0;

    String city = '';
    String state = '';
    String name = prediction.description ?? '';

    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        city = place.locality ?? place.subLocality ?? '';
        state = place.administrativeArea ?? '';
      }
    } catch (e) {
      debugPrint('Placemark error: $e');
    }

    setState(() {
      _waypoints.add(RouteLocationEntity(
          lat: lat, lng: lng, city: city, state: state, name: name));
      _isAddingWaypoint = false;
      _searchController.clear();
    });
    _updateMarkers();
  }

  void _fitBounds(List<LatLng> points) {
    if (points.isEmpty || _mapController == null) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        80,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripBloc, TripState>(
      listener: (context, state) {
        if (state.status == TripStatus.success && state.routeResponse != null) {
          final route = state.routeResponse!;

          setState(() {
            // ✅ ONLY update polyline
            _polylines = _buildPolylines(route.polylinePoints);

            // ❌ DO NOT TOUCH WAYPOINTS
            // _waypoints.clear();   <-- removed
            // _waypoints.addAll(...); <-- removed
          });

          if (route.polylinePoints.isNotEmpty) {
            _fitBounds(route.polylinePoints
                .map((p) => LatLng(p.latitude, p.longitude))
                .toList());
          }

          // ✅ redraw markers using existing waypoints
          _updateMarkers();
        }
      },
      builder: (context, state) {
        final isLoading = state.status == TripStatus.loading;

        return Scaffold(
          body: Stack(
            children: [
              // ── Google Map ──────────────────────────────────────────────────
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.source.lat, widget.source.lng),
                  zoom: 12,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                  // If we already have a polyline (restored from bloc),
                  // fit the camera now that the controller is ready.
                  if (_polylines.isNotEmpty) {
                    final pts = _polylines.first.points;
                    if (pts.isNotEmpty) _fitBounds(pts);
                  }
                },
                markers: _markers,
                polylines: _polylines,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                padding: const EdgeInsets.only(top: 250),
              ),

              // ── Top bar + journey card ──────────────────────────────────────
              Positioned(
                top: 40,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildCircleButton(
                            Icons.chevron_left, () => Navigator.pop(context)),
                        const Expanded(
                          child: Text(
                            'Route Map',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _buildAvatar(),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildJourneyCard(state),
                  ],
                ),
              ),

              // ── Add waypoint toggle button ───────────────────────────────────
              Positioned(
                top: 280,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _isAddingWaypoint = !_isAddingWaypoint);
                    if (_isAddingWaypoint) {
                      Future.delayed(const Duration(milliseconds: 100),
                              () => _searchFocusNode.requestFocus());
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCA5049),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 5)
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isAddingWaypoint ? Icons.close : Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isAddingWaypoint ? 'Cancel' : 'Add Stop',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Done button ─────────────────────────────────────────────────
              Positioned(
                bottom: 30,
                left: 16,
                right: 16,
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading || state.routeResponse == null
                        ? null
                        : () {
                      // Return everything CreateTripPage needs.
                      Navigator.pop(context, {
                        'source': state.routeResponse!.source,
                        'destination': state.routeResponse!.destination,
                        'waypoints':
                        List<RouteLocationEntity>.from(_waypoints),
                        'routeId': state.routeResponse!.routeId,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCA5049),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Done',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Journey card (source → waypoints → destination)
  // ---------------------------------------------------------------------------

  Widget _buildJourneyCard(TripState state) {
    final isLoading = state.status == TripStatus.loading;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Source row
          _buildLocationRow(widget.source.name, isSource: true),
          _buildDots(),

          // Waypoints list (scrollable up to 150 px)
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  ..._waypoints.asMap().entries.map((entry) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLocationRow(entry.value.name,
                          isWaypoint: true, index: entry.key),
                      _buildDots(),
                    ],
                  )),

                  // Inline search field when adding a new waypoint
                  if (_isAddingWaypoint) ...[
                    _buildWaypointSearchField(),
                    _buildDots(),
                  ],
                ],
              ),
            ),
          ),

          // Destination row
          _buildLocationRow(widget.destination.name, isDestination: true),

          const SizedBox(height: 12),

          // Form Route button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: isLoading ? null : _fetchRoute,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCA5049),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: isLoading
                  ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
                  : const Text('Form Route',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() => const Padding(
    padding: EdgeInsets.only(left: 36),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text('⋮',
          style: TextStyle(color: Colors.grey, fontSize: 18, height: 0.8)),
    ),
  );

  Widget _buildWaypointSearchField() {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: _searchController,
      focusNode: _searchFocusNode,
      googleAPIKey: kGoogleApiKey,
      inputDecoration: const InputDecoration(
        hintText: 'Search waypoint...',
        prefixIcon: Icon(Icons.location_on, color: Colors.orange, size: 18),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 12),
        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
      ),
      debounceTime: 400,
      isLatLngRequired: true,
      textStyle: const TextStyle(color: Colors.black, fontSize: 14),
      getPlaceDetailWithLatLng: (prediction) => _onPlaceSelected(prediction),
      itemClick: (prediction) {
        _searchController.text = prediction.description ?? '';
        _searchFocusNode.requestFocus();
      },
      isCrossBtnShown: false,
      seperatedBuilder: const Divider(),
      containerHorizontalPadding: 0,
    );
  }

  Widget _buildLocationRow(
      String text, {
        bool isSource = false,
        bool isDestination = false,
        bool isWaypoint = false,
        int? index,
      }) {
    return Row(
      children: [
        Icon(
          isWaypoint ? Icons.location_on : Icons.radio_button_checked,
          color: isSource
              ? Colors.blue
              : isDestination
              ? Colors.red
              : Colors.orange,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isWaypoint)
          IconButton(
            icon: const Icon(Icons.close, size: 16, color: Colors.red),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              setState(() => _waypoints.removeAt(index!));
              _updateMarkers();
            },
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Utility widgets
  // ---------------------------------------------------------------------------

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: IconButton(icon: Icon(icon, size: 20), onPressed: onTap),
    );
  }

  Widget _buildAvatar() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child:
      const Center(child: Text('🧔', style: TextStyle(fontSize: 22))),
    );
  }
}