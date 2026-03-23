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
  double _sourceLat = 0, _sourceLng = 0;
  String _sourceCity = '', _sourceState = '';
  
  double _destLat = 0, _destLng = 0;
  String _destCity = '', _destState = '';

  // Selected Data
  String? _selectedRideType;
  String? _selectedVehicle;
  CrewEntity? _crewData;
  String? _paymentType;
  final List<RoutePointEntity> _selectedRoutePoints = [];

  final List<String> _rideTypes = ['car', 'bike', 'cycle'];
  final List<String> _vehicles = ['Royal Enfield', 'KTM', 'Yamaha', 'Others'];

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
          // _sourceController.text = "$_sourceCity, $_sourceState";
          _sourceController.text = result['fullAddress'];
        } else {
          _destLat = result['latitude'];
          _destLng = result['longitude'];
          _destCity = result['city'];
          _destState = result['state'];
          // _destinationController.text = "$_destCity, $_destState";
          _destinationController.text = result['fullAddress'];
        }
      });
    }
  }

  void _onSubmit(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final organiserId = prefs.getInt('userId') ?? 0;

    final trip = TripEntity(
      name: _nameController.text,
      startDate: _startDateController.text,
      endDate: _endDateController.text,
      lastDateToJoin: _lastDateToJoinController.text,
      rideType: _selectedRideType ?? 'car',
      vehicleType: _selectedVehicle ?? 'Royal Enfield',
      source: LocationDetailEntity(
        latitude: _sourceLat,
        longitude: _sourceLng,
        city: _sourceCity,
        state: _sourceState,
      ),
      startingPoint: _startingPointController.text,
      destination: LocationDetailEntity(
        latitude: _destLat,
        longitude: _destLng,
        city: _destCity,
        state: _destState,
      ),
      endPoint: _endPointController.text,
      routeMap: _selectedRoutePoints,
      cost: double.tryParse(_costController.text) ?? 0,
      maxParticipants: int.tryParse(_maxParticipantsController.text) ?? 0,
      maxVehicle: int.tryParse(_maxVehicleController.text) ?? 0,
      crew: _crewData ?? const CrewEntity(
        servicePerson: CrewMemberEntity(name: '', contact: ''),
        organiser: CrewMemberEntity(name: '', contact: ''),
      ),
      mobile: _mobileController.text,
      publishType: _isBroadcast ? 'broadcast' : 'selective',
      organiserId: organiserId,
      tripStatus: 'active',
      paymentType: _paymentType ?? 'DebitCard',
    );

    context.read<TripBloc>().add(CreateTripSubmitted(trip));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TripBloc>(),
      child: BlocConsumer<TripBloc, TripState>(
        listener: (context, state) {
          if (state.status == TripStatus.success) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: 'Success',
              desc: 'Trip created successfully!',
              btnOkOnPress: () => context.go(RouteNames.dashboard),
            ).show();
          } else if (state.status == TripStatus.error) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              title: 'Error',
              desc: state.errorMessage ?? 'Failed to create trip',
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
                      onPressed: () {}, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCA5049),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('View Route Map', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                          final result = await context.push(RouteNames.addCrew);
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
      ),
    );
  }

  Widget _buildLocationPicker({
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueGrey.shade100),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value ?? label,
                    style: TextStyle(
                      fontSize: 13,
                      color: value != null ? Colors.black : Colors.grey,
                      fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
                    ),
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

  Widget _buildTab(String label, {bool isSelected = false}) {
    return Expanded(
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFCA5049) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFCA5049).withOpacity(0.5)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, bool isRequired = false, IconData? suffixIcon, Color? iconColor, VoidCallback? onTap, VoidCallback? onSuffixTap, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            if (isRequired) const Text(' *', style: TextStyle(color: Colors.red, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 45,
          child: TextField(
            controller: controller,
            readOnly: onTap != null,
            onTap: onTap,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              suffixIcon: suffixIcon != null ? InkWell(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: iconColor ?? Colors.grey, size: 20),
              ) : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blueGrey.shade100),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFCA5049)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label, required String? value, required List<String> items, bool isRequired = false, required ValueChanged<String?> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            if (isRequired) const Text(' *', style: TextStyle(color: Colors.red, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 45,
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blueGrey.shade100),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFCA5049)),
              ),
            ),
            items: items.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallButton(String label, VoidCallback onTap) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFCA5049),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildOutlineButton(String label, {required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFFCA5049) : Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFCA5049) : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
