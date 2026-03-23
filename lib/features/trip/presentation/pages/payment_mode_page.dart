import 'package:flutter/material.dart';
import 'package:yaanam/core/theme/app_colors.dart';

class PaymentModePage extends StatefulWidget {
  final String? initialPaymentType;
  const PaymentModePage({super.key, this.initialPaymentType});

  @override
  State<PaymentModePage> createState() => _PaymentModePageState();
}

class _PaymentModePageState extends State<PaymentModePage> {
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ifscController = TextEditingController();
  final _gpayController = TextEditingController();
  final _upiController = TextEditingController();

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _ifscController.dispose();
    _gpayController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    // Basic logic to determine payment type based on filled fields
    String paymentType = 'DebitCard';
    if (_upiController.text.isNotEmpty || _gpayController.text.isNotEmpty) {
      paymentType = 'UPI';
    }
    
    // In a real app, you might want to return all these details.
    // For now, returning the paymentType as per the entity structure provided.
    Navigator.of(context).pop(paymentType);
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
          'Payment Mode',
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
            _buildSectionHeader('Account Details'),
            const SizedBox(height: 15),
            _buildTextField(label: 'Account Name', controller: _accountNameController, isRequired: true),
            const SizedBox(height: 12),
            _buildTextField(label: 'Account Number', controller: _accountNumberController, isRequired: true, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            _buildTextField(label: 'Bank Name', controller: _bankNameController, isRequired: true),
            const SizedBox(height: 12),
            _buildTextField(label: 'IFSC Code', controller: _ifscController, isRequired: true),
            const SizedBox(height: 20),
            const Text('Or', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 20),
            _buildTextField(label: 'GPAY Number', controller: _gpayController, isRequired: true, keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            _buildTextField(label: 'Upi id', controller: _upiController, isRequired: true),
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
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
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
          child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 11)),
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
