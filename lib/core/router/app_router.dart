import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaanam/core/router/route_names.dart';
import 'package:yaanam/features/auth/presentation/pages/reset_password_page.dart';
import 'package:yaanam/features/auth/presentation/pages/signin_page.dart';
import 'package:yaanam/features/auth/presentation/pages/verification_code_page.dart';

import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/dashboard/presentation/pages/create_trip_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/pages/trip_tracking_page.dart';
import '../../features/introduction/presentation/pages/splash_screen.dart';
import '../../features/introduction/presentation/pages/welcome_screen.dart';

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
  initialLocation: RouteNames.verificationCode,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcomeScreen',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/signIn',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: '/signUp',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/resetPassword',
      builder: (context, state) => const ResetPasswordPage(),
    ),
    GoRoute(
      path: '/verificationCode',
      builder: (context, state) {
        final String targetIdentifier = state.extra as String? ?? 'your email/phone';
        return VerificationCodePage(targetIdentifier: targetIdentifier);
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/create-trip',
      builder: (context, state) => const CreateTripPage(),
    ),
    GoRoute(
      path: '/trip-tracking',  builder: (context, state) => const TripTrackingPage(),
    ),
  ],
);