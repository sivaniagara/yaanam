import 'package:get_it/get_it.dart';
import '../network/http_service.dart';
import '../../features/auth/di/init_auth_dependency.dart';
import '../../features/trip/di/init_trip_dependency.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<HttpService>(
    () => HttpService(baseUrl: 'https://tripathon-production.up.railway.app/api/'), // Replace with your base URL
  );

  // Features
  initAuthDependency();
  initTripDependency();
}
