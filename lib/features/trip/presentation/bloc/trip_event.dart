part of 'trip_bloc.dart';

abstract class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object?> get props => [];
}

class CreateTripSubmitted extends TripEvent {
  final TripEntity trip;

  const CreateTripSubmitted(this.trip);

  @override
  List<Object?> get props => [trip];
}

class ViewRoutesRequested extends TripEvent {
  final ViewRoutesRequestEntity request;

  const ViewRoutesRequested(this.request);

  @override
  List<Object?> get props => [request];
}
