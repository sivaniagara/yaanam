import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaanam/core/constant/app_images.dart';
import 'package:yaanam/core/constant/enums.dart';
import 'package:yaanam/core/di/dependency_injection.dart';
import 'package:yaanam/core/router/route_names.dart';
import 'package:yaanam/core/theme/app_colors.dart';
import 'package:yaanam/features/auth/presentation/bloc/auth_bloc.dart';

class VerificationCodePage extends StatefulWidget {
  final String targetIdentifier;
  final VerificationType verificationType;

  const VerificationCodePage({
    super.key,
    required this.targetIdentifier,
    required this.verificationType,
  });

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    // Request focus on build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onVerifyPressed(BuildContext context) {
    if (_controller.text.length == 6) {
      if (_userId != null) {
        if(widget.verificationType == VerificationType.signup){
          context.read<AuthBloc>().add(
            AuthVerifyOtpRequested(
              userId: _userId!,
              otp: _controller.text,
            ),
          );
        }else{
          context.go(RouteNames.setNewPassword, extra: _controller.text);
        }

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User session not found. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit verification code')),
      );
    }
  }

  void _onResendPressed(BuildContext context) {
    context.read<AuthBloc>().add(
          AuthResendOtpRequested(
            mobile: widget.targetIdentifier, 
          ),
        );
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
              title: 'Verified',
              desc: 'OTP verified successfully!',
              btnOkOnPress: () {
                if (widget.verificationType == VerificationType.signup) {
                  context.go(RouteNames.signIn);
                } else {
                  // If forgot password, navigate to set new password screen
                  // context.go(RouteNames.setNewPassword); 
                  context.go(RouteNames.signIn); // Fallback for now
                }
              },
            ).show();
          } else if (state.status == AuthStatus.otpSent) {
             AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.bottomSlide,
              title: 'OTP Resent',
              desc: 'A new verification code has been sent.',
              btnOkOnPress: () {},
            ).show();
          } else if (state.status == AuthStatus.error) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: 'Error',
              desc: state.errorMessage ?? 'Action failed. Please try again.',
              btnOkOnPress: () {
                context.pop();
              },
            ).show();
          }
        },
        builder: (context, state) {
          final bool isMainLoading = state.status == AuthStatus.loading;
          final bool isResendLoading = state.status == AuthStatus.resendLoading;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // Background Map
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: SvgPicture.asset(
                    AppImages.map,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.2),
                      BlendMode.dstATop,
                    ),
                  ),
                ),

                // Back Button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0),
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

                // Content
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Verification Code',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Please type the verification code sent to\n${widget.targetIdentifier}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 48),
                            // OTP Boxes
                            GestureDetector(
                              onTap: () => _focusNode.requestFocus(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(6, (index) {
                                  final text = _controller.text;
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      border: Border.all(
                                        color: text.length == index
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: text.length > index
                                          ? Text(
                                              text[index],
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : text.length == index
                                              ? const Text(
                                                  '|',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    color: AppColors.primary,
                                                  ),
                                                )
                                              : const SizedBox(),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            // Hidden TextField
                            Offstage(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                maxLength: 6,
                                keyboardType: TextInputType.number,
                                onChanged: (value) => setState(() {}),
                                decoration: const InputDecoration(
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
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
                                  onPressed: isMainLoading || isResendLoading
                                      ? null
                                      : () => _onVerifyPressed(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: isMainLoading
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text(
                                          'Next',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Resend Code
                            Center(
                              child: GestureDetector(
                                onTap: isMainLoading || isResendLoading ? null : () => _onResendPressed(context),
                                child: isResendLoading 
                                  ? const SizedBox(
                                      height: 20, 
                                      width: 20, 
                                      child: CircularProgressIndicator(strokeWidth: 2)
                                    )
                                  : const Text(
                                      'Resend code',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        )
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
