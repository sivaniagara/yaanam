import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/usecases/create_trip_usecase.dart';

part 'trip_event.dart';
part 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final CreateTripUseCase createTripUseCase;

  TripBloc({required this.createTripUseCase}) : super(TripState.initial()) {
    on<CreateTripSubmitted>(_onCreateTripSubmitted);
  }

  Future<void> _onCreateTripSubmitted(
    CreateTripSubmitted event,
    Emitter<TripState> emit,
  ) async {
    emit(state.copyWith(status: TripStatus.loading));

    final result = await createTripUseCase(event.trip);

    result.fold(
      (failure) => emit(state.copyWith(
        status: TripStatus.error,
        errorMessage: failure.message,
      )),
      (trip) => emit(state.copyWith(
        status: TripStatus.success,
        trip: trip,
      )),
    );
  }
}
