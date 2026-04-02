import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yaanam/core/router/route_names.dart';
import 'package:yaanam/features/auth/presentation/pages/reset_password_page.dart';
import 'package:yaanam/features/auth/presentation/pages/signin_page.dart';
import 'package:yaanam/features/auth/presentation/pages/verification_code_page.dart';
import 'package:yaanam/features/auth/presentation/pages/set_new_password_page.dart';
import 'package:yaanam/features/trip/domain/entities/view_routes_entity.dart';
import 'package:yaanam/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:yaanam/features/trip/presentation/pages/add_crew_page.dart';
import 'package:yaanam/features/trip/presentation/pages/payment_mode_page.dart';
import 'package:yaanam/features/trip/presentation/pages/trip_tracking_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/introduction/presentation/pages/splash_screen.dart';
import '../../features/introduction/presentation/pages/welcome_screen.dart';
import '../../features/trip/presentation/pages/create_trip_page.dart';
import '../../features/trip/presentation/pages/route_map_picker_page.dart';
import '../constant/enums.dart';
import '../di/dependency_injection.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

Widget pageSlider(context, animation, secondaryAnimation, child){
  const begin = Offset(2.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}

final router = GoRouter(
  initialLocation: RouteNames.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: RouteNames.signIn,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: RouteNames.signUp,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: RouteNames.resetPassword,
      builder: (context, state) => const ResetPasswordPage(),
    ),
    GoRoute(
      path: RouteNames.verificationCode,
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>? ?? {};
        final String identifier = extra['emailId'] ?? extra['mobile'] ?? 'your email/phone';
        final VerificationType type = extra['verificationType'] ?? VerificationType.signup;
        
        return VerificationCodePage(
          targetIdentifier: identifier,
          verificationType: type,
        );
      },
    ),
    GoRoute(
      path: RouteNames.setNewPassword,
      builder: (context, state) {
        final String otp = state.extra as String? ?? '';
        return SetNewPasswordPage(otp: otp);
      },
    ),
    GoRoute(
      path: RouteNames.dashboard,
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: RouteNames.createTrip,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<TripBloc>(),
          child: const CreateTripPage(),
        );
      },
    ),
    GoRoute(
      path: RouteNames.tripTracking,
      builder: (context, state) {
        final routeResponse = state.extra as ViewRoutesResponseEntity;
        return TripTrackingPage(routeResponse: routeResponse);
      },
    ),
    GoRoute(
      path: RouteNames.addCrew,
      builder: (context, state) => const AddCrewPage(),
    ),
    GoRoute(
      path: RouteNames.paymentMode,
      builder: (context, state) => const PaymentModePage(),
    ),
    GoRoute(
      path: RouteNames.routeMapPicker,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>? ?? {};
        return RouteMapPickerPage(fullAddress: data['fullAddress'], initialLocation: data['lat'] == 0 ? null : LatLng(data['lat'], data['lng']),);
      },
    ),
  ],
);