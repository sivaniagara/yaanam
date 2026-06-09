import '../../domain/entities/trip_summary_entity.dart';

class TripSummaryModel extends TripSummaryEntity {
  const TripSummaryModel({
    required super.id,
    required super.name,
    required super.startDate,
    required super.endDate,
    required super.sourceCity,
    required super.destinationCity,
    required super.tripStatus,
    required super.maxParticipants,
    required super.participants,
  });

  factory TripSummaryModel.fromJson(Map<String, dynamic> json) {
    return TripSummaryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      sourceCity: json['source_city'] ?? '',
      destinationCity: json['destination_city'] ?? '',
      tripStatus: json['trip_status'] ?? '',
      maxParticipants: json['max_participants'] ?? 0,
      participants: ParticipantsSummaryModel.fromJson(json['participants'] ?? {}),
    );
  }
}

class ParticipantsSummaryModel extends ParticipantsSummaryEntity {
  const ParticipantsSummaryModel({
    required super.remaining,
    required super.joinStatus,
    required super.paymentStatus,
  });

  factory ParticipantsSummaryModel.fromJson(Map<String, dynamic> json) {
    return ParticipantsSummaryModel(
      remaining: json['remaining'] ?? 0,
      joinStatus: JoinStatusModel.fromJson(json['join_status'] ?? {}),
      paymentStatus: PaymentStatusModel.fromJson(json['payment_status'] ?? {}),
    );
  }
}

class JoinStatusModel extends JoinStatusEntity {
  const JoinStatusModel({
    required super.pending,
    required super.accepted,
    required super.rejected,
  });

  factory JoinStatusModel.fromJson(Map<String, dynamic> json) {
    return JoinStatusModel(
      pending: json['pending'] ?? 0,
      accepted: json['accepted'] ?? 0,
      rejected: json['rejected'] ?? 0,
    );
  }
}

class PaymentStatusModel extends PaymentStatusEntity {
  const PaymentStatusModel({
    required super.paid,
    required super.unpaid,
    required super.refunded,
  });

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    return PaymentStatusModel(
      paid: json['paid'] ?? 0,
      unpaid: json['unpaid'] ?? 0,
      refunded: json['refunded'] ?? 0,
    );
  }
}
