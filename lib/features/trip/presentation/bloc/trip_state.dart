part of 'trip_bloc.dart';

enum TripStatus {
  initial,
  loading,
  success,
  error,
  detailLoading,
  detailSuccess,
  detailError,
  publishLoading,
  publishSuccess,
  publishError
}

class TripState extends Equatable {
  final TripStatus status;
  final String? errorMessage;
  final TripEntity? trip;
  final ViewRoutesResponseEntity? routeResponse;
  final List<TripEntity> trips;
  final List<OrganiserTripEntity> organisedTrips;

  const TripState({
    this.status = TripStatus.initial,
    this.errorMessage,
    this.trip,
    this.routeResponse,
    this.trips = const [],
    this.organisedTrips = const [],
  });

  factory TripState.initial() => const TripState();

  TripState copyWith({
    TripStatus? status,
    String? errorMessage,
    TripEntity? trip,
    ViewRoutesResponseEntity? routeResponse,
    List<TripEntity>? trips,
    List<OrganiserTripEntity>? organisedTrips,
  }) {
    return TripState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      trip: trip ?? this.trip,
      routeResponse: routeResponse ?? this.routeResponse,
      trips: trips ?? this.trips,
      organisedTrips: organisedTrips ?? this.organisedTrips,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        trip,
        routeResponse,
        trips,
        organisedTrips,
      ];
}
