import 'package:equatable/equatable.dart';

class TripSummaryEntity extends Equatable {
  final int id;
  final String name;
  final String startDate;
  final String endDate;
  final String sourceCity;
  final String destinationCity;
  final String tripStatus;
  final int maxParticipants;
  final ParticipantsSummaryEntity participants;

  const TripSummaryEntity({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.sourceCity,
    required this.destinationCity,
    required this.tripStatus,
    required this.maxParticipants,
    required this.participants,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        startDate,
        endDate,
        sourceCity,
        destinationCity,
        tripStatus,
        maxParticipants,
        participants,
      ];
}

class ParticipantsSummaryEntity extends Equatable {
  final int remaining;
  final JoinStatusEntity joinStatus;
  final PaymentStatusEntity paymentStatus;

  const ParticipantsSummaryEntity({
    required this.remaining,
    required this.joinStatus,
    required this.paymentStatus,
  });

  @override
  List<Object?> get props => [remaining, joinStatus, paymentStatus];
}

class JoinStatusEntity extends Equatable {
  final int pending;
  final int accepted;
  final int rejected;

  const JoinStatusEntity({
    required this.pending,
    required this.accepted,
    required this.rejected,
  });

  @override
  List<Object?> get props => [pending, accepted, rejected];
}

class PaymentStatusEntity extends Equatable {
  final int paid;
  final int unpaid;
  final int refunded;

  const PaymentStatusEntity({
    required this.paid,
    required this.unpaid,
    required this.refunded,
  });

  @override
  List<Object?> get props => [paid, unpaid, refunded];
}
