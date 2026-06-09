class ApiEndpoints {
  ApiEndpoints._();

  static const String signup = 'users/signup';
  static const String login = 'users/signin';
  static const String verifyOtp = 'users/verify-otp';
  static const String resendOtp = 'users/resend-otp';
  static const String forgetPassword = 'users/forgot-password';
  static const String updatePassword = 'users/reset-password';
  static const String createTrip = 'trips/create';
  static const String updateTrip = 'trips/update/:tripId';
  static const String viewRoutes = 'routes/route';
  static const String tripList = 'trips/list';
  static const String organiseTrips = 'trips/organiser/list';
  static const String activeTrips = 'trips/active';
  static const String getTrip = 'trips/:tripId';
  static const String publishTrip = 'trips/:tripId/action';
}
