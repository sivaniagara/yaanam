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

class UpdateTripSubmitted extends TripEvent {
  final TripEntity trip;

  const UpdateTripSubmitted(this.trip);

  @override
  List<Object?> get props => [trip];
}

class ViewRoutesRequested extends TripEvent {
  final ViewRoutesRequestEntity request;

  const ViewRoutesRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class GetTripsRequested extends TripEvent {
  final String endpoint;

  const GetTripsRequested(this.endpoint);

  @override
  List<Object?> get props => [endpoint];
}

class GetOrganisedTripsRequested extends TripEvent {
  const GetOrganisedTripsRequested();
}

class GetTripDetailRequested extends TripEvent {
  final int tripId;

  const GetTripDetailRequested(this.tripId);

  @override
  List<Object?> get props => [tripId];
}
