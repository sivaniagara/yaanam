import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaanam/core/di/dependency_injection.dart';
import 'package:yaanam/core/theme/app_colors.dart';
import 'package:yaanam/features/auth/domain/entities/signup_entity.dart';
import 'package:yaanam/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yaanam/core/device/device_info_service.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/error/error_message.dart';
import '../../../../core/router/route_names.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String _selectedInterest = 'car';
  final List<String> _interests = ["car", "bike", "cycle"];

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'siva prakash';
    _displayNameController.text = 'siva';
    _dobController.text = '1999-06-21';
    _mobileController.text = '8220676342';
    _emailController.text = 'sivamuthuraj1999@gmail.com';
    _passwordController.text = 'SivaYaanam@#1999';
    _confirmPasswordController.text = 'SivaYaanam@#1999';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    _dobController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSignUpPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: 'Passwords do not match',
          btnOkOnPress: () {},
        ).show();
        return;
      }

      final deviceInfo = DeviceInfoService();
      
      final signupEntity = SignupEntity(
        name: _nameController.text,
        dob: _dobController.text,
        mobile: _mobileController.text,
        email: _emailController.text,
        interest: _selectedInterest,
        type: 'normal',
        deviceToken: await deviceInfo.getDeviceToken() ?? '',
        deviceType: deviceInfo.getDeviceType(),
        deviceMacAddress: await deviceInfo.getDeviceMacAddress(),
        profilePhoto: '', 
        location: const LocationEntity(
          latitude: 0.0,
          longitude: 0.0,
          state: 'Unknown',
          city: 'Unknown',
        ),
        password: _passwordController.text,
      );

      if (mounted) {
        context.read<AuthBloc>().add(AuthSignupRequested(signupEntity));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.otpSent) {
            context.go(RouteNames.verificationCode, extra: {'mobile': _mobileController.text, 'verificationType': VerificationType.signup});
          }else if (state.status == AuthStatus.error && state.errorMessage == ErrorMessage.userAlreadyExistSignUp) {
            context.go(RouteNames.verificationCode, extra: {'mobile': _mobileController.text, 'verificationType': VerificationType.signup});
          } else if (state.status == AuthStatus.error) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: 'Error',
              desc: state.errorMessage ?? 'Signup failed',
              btnOkOnPress: () {
                context.go(RouteNames.verificationCode, extra: {'mobile': _mobileController.text, 'verificationType': VerificationType.signup});
              },
              btnOkColor: Colors.red,
            ).show();
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
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
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D1B2A),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(label: 'Name', controller: _nameController, isRequired: true),
                      const SizedBox(height: 10),
                      _buildTextField(label: 'Display Name', controller: _displayNameController),
                      const SizedBox(height: 10),
                      _buildTextField(
                        label: 'Date of Birth',
                        controller: _dobController,
                        isRequired: true,
                        suffixIcon: const Icon(Icons.calendar_month_outlined, color: Color(0xFF5E6D7E)),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            _dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(label: 'Mobile Number', controller: _mobileController, isRequired: true, keyboardType: TextInputType.phone),
                      const SizedBox(height: 10),
                      _buildTextField(label: 'E-Mail', controller: _emailController, isRequired: true, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 10),
                      _buildDropdownField(label: 'Interest'),
                      const SizedBox(height: 10),
                      _buildTextField(
                        label: 'Password',
                        controller: _passwordController,
                        isRequired: true,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFF5E6D7E),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        label: 'Confirm Password',
                        controller: _confirmPasswordController,
                        isRequired: true,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFF5E6D7E),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        label: 'Upload Profile Photo',
                        suffixIcon: const Icon(Icons.image_outlined, color: Color(0xFF5E6D7E)),
                      ),
                      const SizedBox(height: 30),
                      // Next Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColorDark,
                                Theme.of(context).primaryColor,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFB71C1C).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: state.status == AuthStatus.loading ? null : () => _onSignUpPressed(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: state.status == AuthStatus.loading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.go(RouteNames.signIn);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    bool isRequired = false,
    bool obscureText = false,
    Widget? suffixIcon,
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
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: onTap != null,
          onTap: onTap,
          keyboardType: keyboardType,
          validator: isRequired ? (value) => value == null || value.isEmpty ? 'Field required' : null : null,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: suffixIcon,
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
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF5E6D7E), fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedInterest,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD1D9E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD1D9E0)),
            ),
          ),
          hint: Text(label, style: const TextStyle(color: Color(0xFFD1D9E0))),
          items: _interests.map((interest) {
            return DropdownMenuItem(
              value: interest,
              child: Text(interest),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedInterest = value!;
            });
          },
        ),
      ],
    );
  }
}
