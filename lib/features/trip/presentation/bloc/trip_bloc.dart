import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/organiser_trip_entity.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/trip_summary_entity.dart';
import '../../domain/entities/view_routes_entity.dart';
import '../../domain/usecases/create_trip_usecase.dart';
import '../../domain/usecases/update_trip_usecase.dart';
import '../../domain/usecases/view_routes_usecase.dart';
import '../../domain/usecases/get_trips_usecase.dart';
import '../../domain/usecases/get_organised_trips_usecase.dart';
import '../../domain/usecases/get_trip_detail_usecase.dart';
import '../../domain/usecases/publish_trip_usecase.dart';

part 'trip_event.dart';
part 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final CreateTripUseCase createTripUseCase;
  final UpdateTripUseCase updateTripUseCase;
  final ViewRoutesUseCase viewRoutesUseCase;
  final GetTripsUseCase getTripsUseCase;
  final GetOrganisedTripsUseCase getOrganisedTripsUseCase;
  final GetTripDetailUseCase getTripDetailUseCase;
  final PublishTripUseCase publishTripUseCase;

  TripBloc({
    required this.createTripUseCase,
    required this.updateTripUseCase,
    required this.viewRoutesUseCase,
    required this.getTripsUseCase,
    required this.getOrganisedTripsUseCase,
    required this.getTripDetailUseCase,
    required this.publishTripUseCase,
  }) : super(TripState.initial()) {
    on<CreateTripSubmitted>(_onCreateTripSubmitted);
    on<UpdateTripSubmitted>(_onUpdateTripSubmitted);
    on<ViewRoutesRequested>(_onViewRoutesRequested);
    on<GetTripsRequested>(_onGetTripsRequested);
    on<GetOrganisedTripsRequested>(_onGetOrganisedTripsRequested);
    on<GetTripDetailRequested>(_onGetTripDetailRequested);
    on<PublishTripRequested>(_onPublishTripRequested);
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

  Future<void> _onUpdateTripSubmitted(
    UpdateTripSubmitted event,
    Emitter<TripState> emit,
  ) async {
    emit(state.copyWith(status: TripStatus.loading));

    final result = await updateTripUseCase(event.trip);

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

  Future<void> _onGetTripsRequested(
    GetTripsRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(state.copyWith(status: TripStatus.loading));

    final result = await getTripsUseCase(event.endpoint);

    result.fold(
      (failure) => emit(state.copyWith(
        status: TripStatus.error,
        errorMessage: failure.message,
      )),
      (trips) => emit(state.copyWith(
        status: TripStatus.success,
        trips: trips,
      )),
    );
  }

  Future<void> _onGetOrganisedTripsRequested(
    GetOrganisedTripsRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(state.copyWith(status: TripStatus.loading));

    final result = await getOrganisedTripsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: TripStatus.error,
        errorMessage: failure.message,
      )),
      (trips) => emit(state.copyWith(
        status: TripStatus.success,
        organisedTrips: trips,
      )),
    );
  }

  Future<void> _onGetTripDetailRequested(
    GetTripDetailRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(state.copyWith(status: TripStatus.detailLoading));

    final result = await getTripDetailUseCase(event.tripId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: TripStatus.detailError,
        errorMessage: failure.message,
      )),
      (trip) => emit(state.copyWith(
        status: TripStatus.detailSuccess,
        trip: trip,
      )),
    );
  }

  Future<void> _onPublishTripRequested(
    PublishTripRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(state.copyWith(status: TripStatus.publishLoading));

    final result = await publishTripUseCase(event.tripId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: TripStatus.publishError,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: TripStatus.publishSuccess)),
    );
  }
}
