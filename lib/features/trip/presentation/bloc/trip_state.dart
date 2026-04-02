part of 'trip_bloc.dart';

enum TripStatus { initial, loading, success, error }

class TripState extends Equatable {
  final TripStatus status;
  final String? errorMessage;
  final TripEntity? trip;
  final ViewRoutesResponseEntity? routeResponse;

  const TripState({
    this.status = TripStatus.initial,
    this.errorMessage,
    this.trip,
    this.routeResponse,
  });

  factory TripState.initial() => const TripState();

  TripState copyWith({
    TripStatus? status,
    String? errorMessage,
    TripEntity? trip,
    ViewRoutesResponseEntity? routeResponse,
  }) {
    return TripState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      trip: trip ?? this.trip,
      routeResponse: routeResponse ?? this.routeResponse,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, trip, routeResponse];
}
