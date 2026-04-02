import 'package:flutter/material.dart';
import 'package:yaanam/features/trip/domain/entities/trip_entity.dart';

class AddCrewPage extends StatefulWidget {
  final List<CrewMemberEntity>? initialCrew;
  const AddCrewPage({super.key, this.initialCrew});

  @override
  State<AddCrewPage> createState() => _AddCrewPageState();
}

class _AddCrewPageState extends State<AddCrewPage> {
  final List<CrewMemberEntity> _crewList = [];
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _roleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.initialCrew != null) {
      _crewList.addAll(widget.initialCrew!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _addCrewMember() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _crewList.add(CrewMemberEntity(
          role: _roleController.text.trim(),
          name: _nameController.text.trim(),
          contact: _contactController.text.trim(),
        ));
        _roleController.clear();
        _nameController.clear();
        _contactController.clear();
      });
    }
  }

  void _removeCrewMember(int index) {
    setState(() {
      _crewList.removeAt(index);
    });
  }

  void _onSubmit() {
    Navigator.of(context).pop(_crewList);
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          label: 'Role',
                          hintText: 'e.g., Mechanic, Organizer, Medical',
                          controller: _roleController,
                          isRequired: true,
                          validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a role' : null,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          label: 'Name',
                          controller: _nameController,
                          isRequired: true,
                          validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a name' : null,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          label: 'Contact',
                          controller: _contactController,
                          isRequired: true,
                          keyboardType: TextInputType.phone,
                          validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a contact' : null,
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: _addCrewMember,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFCA5049),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('Add to List'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Crew Members',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _crewList.isEmpty
                      ? const Center(child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text('No crew members added yet', style: TextStyle(color: Colors.grey)),
                      ))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _crewList.length,
                          itemBuilder: (context, index) {
                            final member = _crewList[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFFCA5049).withOpacity(0.1),
                                  child: const Icon(Icons.person, color: Color(0xFFCA5049)),
                                ),
                                title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${member.role} • ${member.contact}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => _removeCrewMember(index),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: SizedBox(
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? hintText,
    required TextEditingController controller,
    bool isRequired = false,
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
              if (isRequired) const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText ?? 'Enter $label',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD1D9E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD1D9E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCA5049)),
            ),
          ),
        ),
      ],
    );
  }
}
