part of 'trip_bloc.dart';

enum TripStatus { initial, loading, success, error }

class TripState extends Equatable {
  final TripStatus status;
  final String? errorMessage;
  final TripEntity? trip;

  const TripState({
    this.status = TripStatus.initial,
    this.errorMessage,
    this.trip,
  });

  factory TripState.initial() => const TripState();

  TripState copyWith({
    TripStatus? status,
    String? errorMessage,
    TripEntity? trip,
  }) {
    return TripState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      trip: trip ?? this.trip,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, trip];
}
