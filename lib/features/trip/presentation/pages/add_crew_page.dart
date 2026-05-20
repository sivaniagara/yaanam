import 'package:flutter/material.dart';
import 'package:yaanam/features/trip/domain/entities/trip_entity.dart';

class AddCrewPage extends StatefulWidget {
  final CrewEntity? initialCrew;
  const AddCrewPage({super.key, this.initialCrew});

  @override
  State<AddCrewPage> createState() => _AddCrewPageState();
}

class _AddCrewPageState extends State<AddCrewPage> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _serviceContactController = TextEditingController();
  final _organiserNameController = TextEditingController();
  final _organiserContactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialCrew != null) {
      _serviceNameController.text = widget.initialCrew!.servicePerson.name;
      _serviceContactController.text = widget.initialCrew!.servicePerson.contact;
      _organiserNameController.text = widget.initialCrew!.organiser.name;
      _organiserContactController.text = widget.initialCrew!.organiser.contact;
    }
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _serviceContactController.dispose();
    _organiserNameController.dispose();
    _organiserContactController.dispose();
    super.dispose();
  }

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  String? _validateContact(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName contact cannot be empty';
    }
    if (value.trim().length != 10) {
      return '$fieldName contact must be 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Please enter a valid $fieldName contact';
    }
    return null;
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final crew = CrewEntity(
        servicePerson: CrewMemberEntity(
          name: _serviceNameController.text.trim(),
          contact: _serviceContactController.text.trim(),
        ),
        organiser: CrewMemberEntity(
          name: _organiserNameController.text.trim(),
          contact: _organiserContactController.text.trim(),
        ),
      );
      Navigator.of(context).pop(crew);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Add Crew',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildSectionHeader('Service Person'),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Name',
                controller: _serviceNameController,
                isRequired: true,
                validator: (value) => _validateName(value, 'Service Person'),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Contact',
                controller: _serviceContactController,
                isRequired: true,
                keyboardType: TextInputType.phone,
                validator: (value) => _validateContact(value, 'Service Person'),
              ),
              const SizedBox(height: 30),
              _buildSectionHeader('Trip Organiser'),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Name',
                controller: _organiserNameController,
                isRequired: true,
                validator: (value) => _validateName(value, 'Trip Organiser'),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Contact',
                controller: _organiserContactController,
                isRequired: true,
                keyboardType: TextInputType.phone,
                validator: (value) => _validateContact(value, 'Trip Organiser'),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 250,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B1D1D), Color(0xFFCA5049)],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFCA5049),
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: isRequired ? '$label*' : label,
            labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: isRequired ? '$label*' : label,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blueGrey.shade100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCA5049)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
