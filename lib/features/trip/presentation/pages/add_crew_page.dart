import 'package:flutter/material.dart';
import 'package:yaanam/features/trip/domain/entities/trip_entity.dart';

class AddCrewPage extends StatefulWidget {
  final CrewEntity? initialCrew;
  const AddCrewPage({super.key, this.initialCrew});

  @override
  State<AddCrewPage> createState() => _AddCrewPageState();
}

class _AddCrewPageState extends State<AddCrewPage> {
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
      print(_serviceNameController.text);
      print(_serviceContactController.text);
      print(_organiserNameController.text);
      print(_organiserContactController.text);
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

  void _onSubmit() {
    final crew = CrewEntity(
      servicePerson: CrewMemberEntity(
        name: _serviceNameController.text,
        contact: _serviceContactController.text,
      ),
      organiser: CrewMemberEntity(
        name: _organiserNameController.text,
        contact: _organiserContactController.text,
      ),
    );
    Navigator.of(context).pop(crew);
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
        child: Column(
          children: [
            // const SizedBox(height: 10),
            // Row(
            //   children: [
            //     _buildTab('MY TRIP', isSelected: false),
            //     const SizedBox(width: 8),
            //     _buildTab('ORGANISE', isSelected: true),
            //     const SizedBox(width: 8),
            //     _buildTab('ACTIVE', isSelected: false),
            //   ],
            // ),
            const SizedBox(height: 30),
            _buildSectionHeader('Service Person'),
            const SizedBox(height: 15),
            _buildTextField(label: 'Name', controller: _serviceNameController, isRequired: true),
            const SizedBox(height: 12),
            _buildTextField(label: 'Contact', controller: _serviceContactController, isRequired: true, keyboardType: TextInputType.phone),
            const SizedBox(height: 30),
            _buildSectionHeader('Trip Organiser'),
            const SizedBox(height: 15),
            _buildTextField(label: 'Name', controller: _organiserNameController, isRequired: true),
            const SizedBox(height: 12),
            _buildTextField(label: 'Contact', controller: _organiserContactController, isRequired: true, keyboardType: TextInputType.phone),
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

  Widget _buildTextField({required String label, required TextEditingController controller, bool isRequired = false, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        SizedBox(
          height: 45,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: isRequired ? '$label*' : label,
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: isRequired ? '$label*' : label,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
          ),
        ),
      ],
    );
  }
}
