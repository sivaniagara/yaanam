import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/trip_summary_entity.dart';
import '../repositories/trip_repository.dart';

class GetTripsUseCase {
  final TripRepository repository;

  GetTripsUseCase(this.repository);

  Future<Either<Failure, List<TripSummaryEntity>>> call(String endpoint) async {
    return await repository.getTrips(endpoint);
  }
}
