import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:yaanam/core/constant/app_images.dart';
import 'package:yaanam/core/di/dependency_injection.dart';
import 'package:yaanam/core/router/route_names.dart';
import 'package:yaanam/core/theme/app_colors.dart';
import 'package:yaanam/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yaanam/features/introduction/presentation/widgets/brand_name.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _rememberMe = false;
  bool _obscurePassword = true;
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mobileController.text = '8220676342';
    _passwordController.text = 'SivaYaanam@#1999';
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignInPressed(BuildContext context) {
    if (_mobileController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      context.read<AuthBloc>().add(
            AuthSignInRequested(
              mobileNumber: _mobileController.text,
              password: _passwordController.text,
            ),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter mobile and password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.bottomSlide,
              title: 'Success',
              desc: 'Signed in successfully',
              btnOkOnPress: () {
                context.go(RouteNames.dashboard);
              },
            ).show();
          } else if (state.status == AuthStatus.error) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: 'Error',
              desc: state.errorMessage ?? 'Login failed',
              btnOkOnPress: () {},
            ).show();
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // Background Map
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: SvgPicture.asset(
                    AppImages.map,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.2),
                      BlendMode.dstATop,
                    ),
                  ),
                ),

                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Center(
                          child: Column(
                            children: [
                              Image.asset(
                                AppImages.logo,
                                width: 80,
                                height: 80,
                              ),
                              const BrandName(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, -5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Center(
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Center(
                                child: Text(
                                  'Sign in to my account',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              const Text(
                                'Mobile Number',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _mobileController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'Enter Mobile',
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  prefixIcon: const Icon(Icons.phone_android, color: AppColors.primary),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  hintText: 'Enter Password',
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  prefixIcon: const Icon(Icons.fingerprint, color: AppColors.primary),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          onChanged: (value) => setState(() => _rememberMe = value!),
                                          activeColor: AppColors.primary,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Remember Me', style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.push(RouteNames.resetPassword);
                                    },
                                    child: const Text(
                                      'Forgot Password',
                                      style: TextStyle(color: AppColors.primary, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFB71C1C), Color(0xFFD32F2F)],
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: state.status == AuthStatus.loading
                                        ? null
                                        : () => _onSignInPressed(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                    ),
                                    child: state.status == AuthStatus.loading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            'Sign In',
                                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Don't have an account? ", style: TextStyle(fontSize: 12)),
                                    GestureDetector(
                                      onTap: () {
                                        context.go(RouteNames.signUp);
                                      },
                                      child: const Text(
                                        'Sign Up Here',
                                        style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
