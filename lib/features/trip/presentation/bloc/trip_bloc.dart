import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/view_routes_entity.dart';
import '../../domain/usecases/create_trip_usecase.dart';
import '../../domain/usecases/view_routes_usecase.dart';

part 'trip_event.dart';
part 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final CreateTripUseCase createTripUseCase;
  final ViewRoutesUseCase viewRoutesUseCase;

  TripBloc({
    required this.createTripUseCase,
    required this.viewRoutesUseCase,
  }) : super(TripState.initial()) {
    on<CreateTripSubmitted>(_onCreateTripSubmitted);
    on<ViewRoutesRequested>(_onViewRoutesRequested);
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

  Future<void> _onViewRoutesRequested(
    ViewRoutesRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(state.copyWith(status: TripStatus.loading));

    final result = await viewRoutesUseCase(event.request);

    result.fold(
      (failure) => emit(state.copyWith(
        status: TripStatus.error,
        errorMessage: failure.message,
      )),
      (response) => emit(state.copyWith(
        status: TripStatus.success,
        routeResponse: response,
      )),
    );
  }
}
