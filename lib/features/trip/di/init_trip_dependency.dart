import '../../../core/di/dependency_injection.dart';
import '../data/datasources/trip_remote_data_source.dart';
import '../data/repositories/trip_repository_impl.dart';
import '../domain/repositories/trip_repository.dart';
import '../domain/usecases/create_trip_usecase.dart';
import '../domain/usecases/view_routes_usecase.dart';
import '../presentation/bloc/trip_bloc.dart';

void initTripDependency() {
  // Bloc
  sl.registerFactory(
    () => TripBloc(
      createTripUseCase: sl(),
      viewRoutesUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateTripUseCase(sl()));
  sl.registerLazySingleton(() => ViewRoutesUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TripRepository>(
    () => TripRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TripRemoteDataSource>(
    () => TripRemoteDataSourceImpl(httpService: sl()),
  );
}
