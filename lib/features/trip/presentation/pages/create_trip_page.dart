import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaanam/core/di/dependency_injection.dart';
import 'package:yaanam/core/router/route_names.dart';
import 'package:yaanam/core/theme/app_colors.dart';
import 'package:yaanam/features/trip/domain/entities/trip_entity.dart';
import 'package:yaanam/features/trip/presentation/bloc/trip_bloc.dart';

import '../../domain/entities/view_routes_entity.dart';

class CreateTripPage extends StatefulWidget {
  final TripEntity? trip;
  const CreateTripPage({super.key, this.trip});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final _formKey = GlobalKey<FormState>();
  bool _othersNotAllowed = false;
  bool _isBroadcast = true;

  // Controllers
  final _nameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _sourceController = TextEditingController();
  final _startingPointController = TextEditingController();
  final _destinationController = TextEditingController();
  final _endPointController = TextEditingController();
  final _costController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  final _lastDateToJoinController = TextEditingController();
  final _maxVehicleController = TextEditingController();
  final _mobileController = TextEditingController();

  // Location Data
  double _sourceLat = 11.0168, _sourceLng = 76.9558;
  String _sourceCity = 'Coimbatore', _sourceState = 'Tamil Nadu';
  String _sourceName = 'Gandhipuram Bus Stand';

  double _destLat = 11.4064, _destLng = 76.6932;
  String _destCity = 'Ooty', _destState = 'Tamil Nadu';
  String _destName = 'Ooty Botanical Garden';

  // Selected Data
  String? _selectedRideType;
  String? _selectedVehicle;
  CrewEntity? _crewData;
  String? _paymentType;
  List<RouteLocationEntity> _waypoints = [];
  int? _routeId;

  final List<String> _rideTypes = ['car', 'bike', 'cycle'];
  final List<String> _vehicles = ['Royal Enfield', 'KTM', 'Yamaha', 'Others'];

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      final trip = widget.trip!;
      _nameController.text = trip.name;
      _startDateController.text = trip.startDate.split('T')[0];
      _endDateController.text = trip.endDate.split('T')[0];
      _lastDateToJoinController.text = trip.lastDateToJoin.split('T')[0];
      _selectedRideType = trip.rideType;
      _selectedVehicle = trip.vehicleType;

      _sourceController.text = trip.startingPoint;
      _startingPointController.text = trip.startingPoint;
      _sourceCity = trip.sourceCity;
      _sourceState = trip.sourceState;
      _sourceLat = trip.sourceLat ?? 11.0168;
      _sourceLng = trip.sourceLng ?? 76.9558;

      _destinationController.text = trip.endPoint;
      _endPointController.text = trip.endPoint;
      _destCity = trip.destinationCity;
      _destState = trip.destinationState;
      _destLat = trip.destinationLat ?? 11.4064;
      _destLng = trip.destinationLng ?? 76.6932;

      _costController.text = trip.cost.toString();
      _maxParticipantsController.text = trip.maxParticipants.toString();
      _maxVehicleController.text = trip.maxVehicle.toString();
      _mobileController.text = trip.mobile;
      _crewData = trip.crew;
      _paymentType = trip.paymentType;
      _isBroadcast = trip.publishType.toLowerCase() == 'broadcast';
      _routeId = trip.routeId;
    }
    else{
      _startDateController.text = "2026-07-20";
      _endDateController.text = "2026-07-21";
      _lastDateToJoinController.text = "2026-07-03";
      _selectedRideType = 'bike';
      _selectedVehicle = 'Yamaha';
      _costController.text = '1000';
      _maxParticipantsController.text = '30';
      _maxVehicleController.text = '20';
      _mobileController.text = '9999999999';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _sourceController.dispose();
    _startingPointController.dispose();
    _destinationController.dispose();
    _endPointController.dispose();
    _costController.dispose();
    _maxParticipantsController.dispose();
    _lastDateToJoinController.dispose();
    _maxVehicleController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime firstDate = DateTime.now();
    if (controller == _endDateController &&
        _startDateController.text.isNotEmpty) {
      DateTime? startDate = DateTime.tryParse(_startDateController.text);
      if (startDate != null) firstDate = startDate;
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = "${pickedDate.toLocal()}".split(' ')[0];
        if (controller == _startDateController &&
            _endDateController.text.isNotEmpty) {
          DateTime? endDate = DateTime.tryParse(_endDateController.text);
          if (endDate != null && endDate.isBefore(pickedDate)) {
            _endDateController.clear();
          }
        }
      });
    }
  }

  Future<void> _pickLocation(bool isStartingPoint) async {
    final Map<String, dynamic> extraData = {
      "fullAddress":
      isStartingPoint ? _sourceController.text : _destinationController.text,
      'lat': isStartingPoint ? _sourceLat : _destLat,
      'lng': isStartingPoint ? _sourceLng : _destLng
    };

    if (!isStartingPoint && _sourceController.text.isNotEmpty) {
      extraData['sourceLat'] = _sourceLat;
      extraData['sourceLng'] = _sourceLng;
      extraData['sourceAddress'] = _sourceController.text;
    }

    final result =
    await context.push(RouteNames.routeMapPicker, extra: extraData);
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        if (isStartingPoint) {
          _sourceLat = result['latitude'];
          _sourceLng = result['longitude'];
          _sourceCity = result['city'];
          _sourceState = result['state'];
          _sourceName = result['fullAddress'];
          _sourceController.text = result['fullAddress'];
          _startingPointController.text = result['fullAddress'];
        } else {
          _destLat = result['latitude'];
          _destLng = result['longitude'];
          _destCity = result['city'];
          _destState = result['state'];
          _destName = result['fullAddress'];
          _destinationController.text = result['fullAddress'];
          _endPointController.text = result['fullAddress'];
        }
      });
    }
  }

  /// Builds the source entity from current local state.
  RouteLocationEntity get _sourceEntity => RouteLocationEntity(
    lat: _sourceLat,
    lng: _sourceLng,
    city: _sourceCity,
    state: _sourceState,
    name: _sourceName,
  );

  /// Builds the destination entity from current local state.
  RouteLocationEntity get _destinationEntity => RouteLocationEntity(
    lat: _destLat,
    lng: _destLng,
    city: _destCity,
    state: _destState,
    name: _destName,
  );

  /// Navigates to RouteMapPage and awaits result, then updates local state.
  Future<void> _navigateToRouteMap() async {
    final result = await context.push(
      RouteNames.routeMap,
      extra: {
        'source': _sourceEntity,
        'destination': _destinationEntity,
        'initialWaypoints': List<RouteLocationEntity>.from(_waypoints),
        // 'bloc' removed — RouteMapPage inherits TripBloc via the widget tree
        // from CreateTripPage's BlocProvider. Passing it via extra caused
        // GoRouter serialization warnings.
      },
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        final source = result['source'] as RouteLocationEntity;
        final destination = result['destination'] as RouteLocationEntity;

        _sourceLat = source.lat;
        _sourceLng = source.lng;
        _sourceCity = source.city;
        _sourceState = source.state;
        _sourceName = source.name;
        _sourceController.text = source.name;
        _startingPointController.text = source.name;

        _destLat = destination.lat;
        _destLng = destination.lng;
        _destCity = destination.city;
        _destState = destination.state;
        _destName = destination.name;
        _destinationController.text = destination.name;
        _endPointController.text = destination.name;

        _waypoints =
        List<RouteLocationEntity>.from(result['waypoints'] as List);
        _routeId = result['routeId'] as int?;
      });
    }
  }

  /// Called when user taps "View Route Map".
  /// Always navigate directly — RouteMapPage fetches the route itself.
  /// Never dispatch ViewRoutesRequested from here; doing so causes
  /// the BlocConsumer listener below to re-push RouteMapPage every time
  /// "Form Route" is tapped inside the already-open map screen.
  void _onViewRouteMap() {
    _navigateToRouteMap();
  }

  void _onSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'Validation Error',
        desc: 'Please fill in all required fields correctly.',
        btnOkOnPress: () {},
        btnOkColor: const Color(0xFFCA5049),
      ).show();
      return;
    }

    if (_routeId == null && widget.trip == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'Route Map Required',
        desc:
        'Please click on "View Route Map" and form a route before submitting the trip.',
        btnOkOnPress: () {},
        btnOkColor: const Color(0xFFCA5049),
      ).show();
      return;
    }

    if (_crewData == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'Crew Details Required',
        desc: 'Please add crew details before submitting the trip.',
        btnOkOnPress: () {},
        btnOkColor: const Color(0xFFCA5049),
      ).show();
      return;
    }

    final trip = TripEntity(
      id: widget.trip?.id,
      name: _nameController.text,
      startDate: _startDateController.text,
      endDate: _endDateController.text,
      lastDateToJoin: _lastDateToJoinController.text,
      rideType: _selectedRideType ?? 'car',
      vehicleType: _selectedVehicle ?? 'Royal Enfield',
      routeId: _routeId ?? 0,
      startingPoint: _startingPointController.text,
      sourceLat: _sourceLat,
      sourceLng: _sourceLng,
      sourceCity: _sourceCity,
      sourceState: _sourceState,
      endPoint: _endPointController.text,
      destinationLat: _destLat,
      destinationLng: _destLng,
      destinationCity: _destCity,
      destinationState: _destState,
      cost: _costController.text,
      maxParticipants: int.tryParse(_maxParticipantsController.text) ?? 0,
      maxVehicle: int.tryParse(_maxVehicleController.text) ?? 0,
      crew: _crewData!,
      mobile: _mobileController.text,
      publishType: _isBroadcast ? 'broadcast' : 'selective',
      tripStatus: widget.trip?.tripStatus ?? 'active',
      paymentType: _paymentType ?? 'DebitCard',
    );

    if (widget.trip != null) {
      context.read<TripBloc>().add(UpdateTripSubmitted(trip));
    } else {
      context.read<TripBloc>().add(CreateTripSubmitted(trip));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.trip != null;
    return BlocConsumer<TripBloc, TripState>(
      listener: (context, state) {
        if (state.status == TripStatus.success && state.trip != null) {
          if (isEdit) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: 'Success',
              desc: 'Trip updated successfully!',
              btnOkOnPress: () => context.go(RouteNames.dashboard),
            ).show();
          } else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.question,
              title: 'Trip Created',
              desc: 'Trip created successfully. Do you want to publish it now?',
              btnCancelText: 'Later',
              btnOkText: 'Publish',
              btnCancelOnPress: () {
                context.pop();
                // context.read<TripBloc>().add(const GetOrganisedTripsRequested());
              },
              btnOkOnPress: () {
                if (state.trip?.id != null) {
                  context.read<TripBloc>().add(PublishTripRequested(state.trip!.id!));
                }
              },
            ).show();
          }
        } else if (state.status == TripStatus.publishSuccess) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Published',
            desc: 'The trip was successfully published.',
            btnOkOnPress: () {
              context.pop();
              // context.read<TripBloc>().add(const GetOrganisedTripsRequested());
            },
          ).show();
        } else if (state.status == TripStatus.error || state.status == TripStatus.publishError) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error',
            desc: state.errorMessage ?? 'Operation failed',
            btnOkOnPress: () {},
          ).show();
        }
      },
      builder: (context, state) {
        // Show a small indicator on the button if a route has already been saved.
        final hasRoute = _routeId != null || state.routeResponse != null;
        final isLoading = state.status == TripStatus.loading || state.status == TripStatus.publishLoading;

        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon:
                      const Icon(Icons.chevron_left, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                title: Text(
                  isEdit ? 'Edit Trip' : 'Create Trip',
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildTextField(
                        label: 'Name',
                        controller: _nameController,
                        isRequired: true,
                        validator: (val) =>
                        (val == null || val.isEmpty) ? 'Please enter name' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'Start Date',
                              controller: _startDateController,
                              isRequired: true,
                              suffixIcon: Icons.calendar_month_outlined,
                              onTap: () =>
                                  _selectDate(context, _startDateController),
                              validator: (val) =>
                              (val == null || val.isEmpty) ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              label: 'End Date',
                              controller: _endDateController,
                              isRequired: true,
                              suffixIcon: Icons.calendar_month_outlined,
                              onTap: () =>
                                  _selectDate(context, _endDateController),
                              validator: (val) =>
                              (val == null || val.isEmpty) ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildDropdownField(
                        label: 'Ride Type',
                        value: _selectedRideType,
                        items: _rideTypes,
                        isRequired: true,
                        onChanged: (val) => setState(() => _selectedRideType = val),
                        validator: (val) =>
                        val == null ? 'Please select ride type' : null,
                      ),
                      const SizedBox(height: 12),
                      _buildDropdownField(
                        label: 'Vehicle',
                        value: _selectedVehicle,
                        items: _vehicles,
                        isRequired: true,
                        onChanged: (val) => setState(() => _selectedVehicle = val),
                        validator: (val) =>
                        val == null ? 'Please select vehicle' : null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: _othersNotAllowed,
                            activeColor: AppColors.primary,
                            onChanged: (val) =>
                                setState(() => _othersNotAllowed = val!),
                          ),
                          const Text('Others not allowed',
                              style:
                              TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: _buildLocationPicker(
                          label: 'Source',
                          value: _sourceController.text.isEmpty
                              ? null
                              : _sourceController.text,
                          onTap: () => _pickLocation(true),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: _buildLocationPicker(
                          label: 'Destination',
                          value: _destinationController.text.isEmpty
                              ? null
                              : _destinationController.text,
                          onTap: () => _pickLocation(false),
                        ),
                      ),

                      // Waypoints summary chip row (shown once waypoints exist)
                      if (_waypoints.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _buildWaypointsSummary(),
                      ],

                      const SizedBox(height: 20),

                      // View Route Map button — shows a checkmark when route is saved.
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : _onViewRouteMap,
                          icon: state.status == TripStatus.loading &&
                              state.routeResponse == null
                              ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                              : Icon(
                            hasRoute ? Icons.map : Icons.map_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text(
                            hasRoute ? 'View / Edit Route Map' : 'View Route Map',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCA5049),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFCA5049),
                          child: Icon(Icons.chat_bubble,
                              color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'Cost',
                              controller: _costController,
                              isRequired: true,
                              keyboardType: TextInputType.number,
                              validator: (val) =>
                              (val == null || val.isEmpty) ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              label: 'Max Participants',
                              controller: _maxParticipantsController,
                              isRequired: true,
                              keyboardType: TextInputType.number,
                              validator: (val) =>
                              (val == null || val.isEmpty) ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        label: 'Last Date to Join',
                        controller: _lastDateToJoinController,
                        isRequired: true,
                        suffixIcon: Icons.calendar_month_outlined,
                        onTap: () =>
                            _selectDate(context, _lastDateToJoinController),
                        validator: (val) =>
                        (val == null || val.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        label: 'Max Vehicle',
                        controller: _maxVehicleController,
                        isRequired: true,
                        keyboardType: TextInputType.number,
                        validator: (val) =>
                        (val == null || val.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        label: 'Mobile No (Trip Organizer)',
                        controller: _mobileController,
                        isRequired: true,
                        keyboardType: TextInputType.phone,
                        validator: (val) =>
                        (val == null || val.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSmallButton('Payment Mode', () async {
                              final result =
                              await context.push(RouteNames.paymentMode);
                              if (result != null && result is String) {
                                setState(() => _paymentType = result);
                              }
                            }),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSmallButton('Add Crew', () async {
                              final result = await context.push(
                                  RouteNames.addCrew,
                                  extra: _crewData);
                              if (result != null && result is CrewEntity) {
                                setState(() => _crewData = result);
                              }
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                              child: _buildOutlineButton('Broadcast',
                                  isSelected: _isBroadcast,
                                  onTap: () =>
                                      setState(() => _isBroadcast = true))),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildOutlineButton('Selective',
                                  isSelected: !_isBroadcast,
                                  onTap: () =>
                                      setState(() => _isBroadcast = false))),
                        ],
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 200,
                        height: 45,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B1D1D), Color(0xFFCA5049)],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () => _onSubmit(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22)),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                                : Text(isEdit ? 'Update' : 'Submit',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            if (state.status == TripStatus.publishLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Shows a compact summary of waypoints below the destination field.
  Widget _buildWaypointsSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_waypoints.length} waypoint${_waypoints.length > 1 ? 's' : ''} added',
            style: TextStyle(
                fontSize: 12,
                color: Colors.orange.shade800,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _waypoints.map((wp) {
              return Chip(
                label: Text(
                  wp.name.length > 20
                      ? '${wp.name.substring(0, 20)}…'
                      : wp.name,
                  style: const TextStyle(fontSize: 11),
                ),
                backgroundColor: Colors.orange.shade100,
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    bool isRequired = false,
    IconData? suffixIcon,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(color: Color(0xFF5E6D7E), fontSize: 14),
            children: [
              if (isRequired)
                const TextSpan(
                    text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: onTap != null,
          onTap: onTap,
          keyboardType: keyboardType,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: const Color(0xFF5E6D7E))
                : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFD1D9E0))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFD1D9E0))),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Colors.red, width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    String? value,
    required List<String> items,
    bool isRequired = false,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(color: Color(0xFF5E6D7E), fontSize: 14),
            children: [
              if (isRequired)
                const TextSpan(
                    text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFD1D9E0))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFD1D9E0))),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Colors.red, width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationPicker(
      {required String label, String? value, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            const TextStyle(color: Color(0xFF5E6D7E), fontSize: 14)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD1D9E0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: Color(0xFFCA5049)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value ?? 'Select Location',
                    style: TextStyle(
                        color: value == null ? Colors.grey : Colors.black,
                        fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade100,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildOutlineButton(String label,
      {required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFCA5049) : Colors.white,
          border: Border.all(color: const Color(0xFFCA5049)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFFCA5049),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
