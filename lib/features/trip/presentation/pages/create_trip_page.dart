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
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
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
  List<CrewMemberEntity> _crewList = [];
  String? _paymentType;
  final List<RoutePointEntity> _selectedRoutePoints = [];

  final List<String> _rideTypes = ['car', 'bike', 'cycle'];
  final List<String> _vehicles = ['Royal Enfield', 'KTM', 'Yamaha', 'Others'];

  @override
  void initState() {
    super.initState();
    _sourceController.text = _sourceName;
    _destinationController.text = _destName;
    _nameController.text = 'summer trip';
    _startDateController.text = '2026-04-14';
    _endDateController.text = '2026-04-15';
    _lastDateToJoinController.text = '2026-04-10';
    _selectedRideType = 'bike';
    _selectedVehicle = 'KTM';
    _costController.text = '1000';
    _maxVehicleController.text = '20';
    _mobileController.text = '8220676342';
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

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime firstDate = DateTime.now();
    if (controller == _endDateController && _startDateController.text.isNotEmpty) {
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
        if (controller == _startDateController && _endDateController.text.isNotEmpty) {
          DateTime? endDate = DateTime.tryParse(_endDateController.text);
          if (endDate != null && endDate.isBefore(pickedDate)) {
            _endDateController.clear();
          }
        }
      });
    }
  }

  Future<void> _pickLocation(bool isStartingPoint) async {
    print("_pickLocation calling....");
    final result = await context.push(
        RouteNames.routeMapPicker,
        extra: {
          "fullAddress": isStartingPoint ? _sourceController.text : _destinationController.text,
          'lat': isStartingPoint ? _sourceLat : _destLat,
          'lng': isStartingPoint ? _sourceLng : _destLng
        });
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
      print("_startingPointController.text => ${_startingPointController.text}");
      print("_endPointController.text => ${_endPointController.text}");
    }
  }

  void _onViewRouteMap() {
    final request = ViewRoutesRequestEntity(
      source: RouteLocationEntity(
        lat: _sourceLat,
        lng: _sourceLng,
        city: _sourceCity,
        state: _sourceState,
        name: _sourceName,
      ),
      destination: RouteLocationEntity(
        lat: _destLat,
        lng: _destLng,
        city: _destCity,
        state: _destState,
        name: _destName,
      ),
    );

    context.read<TripBloc>().add(ViewRoutesRequested(request));
  }

  void _onSubmit(BuildContext context) async {
    print("_onSubmit completed....");
    final prefs = await SharedPreferences.getInstance();
    final organiserId = prefs.getInt('userId') ?? 0;

    final trip = TripEntity(
      name: _nameController.text,
      startDate: _startDateController.text,
      endDate: _endDateController.text,
      lastDateToJoin: _lastDateToJoinController.text,
      rideType: _selectedRideType ?? 'car',
      vehicleType: _selectedVehicle ?? 'Royal Enfield',
      routeId: context.read<TripBloc>().state.routeResponse?.routeId ?? 0,
      startingPoint: _startingPointController.text,
      sourceCity: _sourceCity,
      sourceState: _sourceState,
      endPoint: _endPointController.text,
      destinationCity: _destCity,
      destinationState: _destState,
      cost: double.tryParse(_costController.text) ?? 0,
      maxParticipants: int.tryParse(_maxParticipantsController.text) ?? 0,
      maxVehicle: int.tryParse(_maxVehicleController.text) ?? 0,
      crew: _crewList,
      mobile: _mobileController.text,
      publishType: _isBroadcast ? 'broadcast' : 'selective',
      tripStatus: 'active',
      paymentType: _paymentType ?? 'DebitCard',
    );

    context.read<TripBloc>().add(CreateTripSubmitted(trip));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripBloc, TripState>(
      listener: (context, state) {
        if (state.status == TripStatus.success) {
          if (state.trip != null) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: 'Success',
              desc: 'Trip created successfully!',
              btnOkOnPress: () => context.go(RouteNames.dashboard),
            ).show();
          } else if (state.routeResponse != null) {
            context.push(RouteNames.tripTracking, extra: state.routeResponse);
          }
        } else if (state.status == TripStatus.error) {
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
        return Scaffold(
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
                  icon: const Icon(Icons.chevron_left, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            title: const Text(
              'Create Trip',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildTextField(label: 'Name', controller: _nameController, isRequired: true),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Start Date',
                        controller: _startDateController,
                        isRequired: true,
                        suffixIcon: Icons.calendar_month_outlined,
                        onTap: () => _selectDate(context, _startDateController),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        label: 'End Date',
                        controller: _endDateController,
                        isRequired: true,
                        suffixIcon: Icons.calendar_month_outlined,
                        onTap: () => _selectDate(context, _endDateController),
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
                ),
                const SizedBox(height: 12),
                _buildDropdownField(
                  label: 'Vehicle',
                  value: _selectedVehicle,
                  items: _vehicles,
                  isRequired: true,
                  onChanged: (val) => setState(() => _selectedVehicle = val),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _othersNotAllowed,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _othersNotAllowed = val!),
                    ),
                    const Text('Others not allowed', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: _buildLocationPicker(
                    label: 'Source',
                    value: _sourceController.text.isEmpty ? null : _sourceController.text,
                    onTap: () => _pickLocation(true),
                  ),
                ),

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: _buildLocationPicker(
                    label: 'Destination',
                    value: _destinationController.text.isEmpty ? null : _destinationController.text,
                    onTap: () => _pickLocation(false),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: state.status == TripStatus.loading ? null : _onViewRouteMap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCA5049),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: state.status == TripStatus.loading && state.routeResponse == null
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('View Route Map', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFCA5049),
                    child: Icon(Icons.chat_bubble, color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _buildTextField(label: 'Cost', controller: _costController, isRequired: true, keyboardType: TextInputType.number)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(label: 'Max Participants', controller: _maxParticipantsController, isRequired: true, keyboardType: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Last Date to Join',
                  controller: _lastDateToJoinController,
                  suffixIcon: Icons.calendar_month_outlined,
                  onTap: () => _selectDate(context, _lastDateToJoinController),
                ),
                const SizedBox(height: 12),
                _buildTextField(label: 'Max Vehicle', controller: _maxVehicleController, isRequired: true, keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                _buildTextField(label: 'Mobile No (Trip Organizer)', controller: _mobileController, isRequired: true, keyboardType: TextInputType.phone),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildSmallButton('Payment Mode', () async {
                        final result = await context.push(RouteNames.paymentMode);
                        if (result != null && result is String) {
                          setState(() => _paymentType = result);
                        }
                      }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSmallButton('Add Crew', () async {
                        final result = await context.push(RouteNames.addCrew, extra: _crewList);
                        if (result != null && result is List<CrewMemberEntity>) {
                          setState(() => _crewList = result);
                        }
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _buildOutlineButton('Broadcast', isSelected: _isBroadcast, onTap: () => setState(() => _isBroadcast = true))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildOutlineButton('Selective', isSelected: !_isBroadcast, onTap: () => setState(() => _isBroadcast = false))),
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
                      onPressed: state.status == TripStatus.loading ? null : () => _onSubmit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                      ),
                      child: state.status == TripStatus.loading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    bool isRequired = false,
    IconData? suffixIcon,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(color: Color(0xFF5E6D7E), fontSize: 14),
            children: [
              if (isRequired) const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: onTap != null,
          onTap: onTap,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFF5E6D7E)) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD1D9E0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD1D9E0))),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(color: Color(0xFF5E6D7E), fontSize: 14),
            children: [
              if (isRequired) const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD1D9E0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD1D9E0))),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationPicker({required String label, String? value, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF5E6D7E), fontSize: 14)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD1D9E0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Color(0xFFCA5049)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value ?? 'Select Location',
                    style: TextStyle(color: value == null ? Colors.grey : Colors.black, fontSize: 14),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }

  Widget _buildOutlineButton(String label, {required bool isSelected, required VoidCallback onTap}) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? AppColors.primary : Colors.black)),
    );
  }
}
