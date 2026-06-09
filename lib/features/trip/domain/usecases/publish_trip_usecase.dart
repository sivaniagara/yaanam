import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/trip_repository.dart';

class PublishTripUseCase {
  final TripRepository repository;

  PublishTripUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int tripId) async {
    return await repository.publishTrip(tripId);
  }
}
