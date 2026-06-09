import '../../domain/entities/organiser_trip_entity.dart';

class OrganiserTripModel extends OrganiserTripEntity {
  const OrganiserTripModel({
    required super.id,
    required super.name,
    required super.startDate,
    required super.endDate,
    required super.sourceCity,
    required super.destinationCity,
    required super.tripStatus,
    required super.publishType,
    required super.maxParticipants,
    required super.participants,
  });

  factory OrganiserTripModel.fromJson(Map<String, dynamic> json) {
    return OrganiserTripModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      sourceCity: json['source_city'] ?? '',
      destinationCity: json['destination_city'] ?? '',
      tripStatus: json['trip_status'] ?? '',
      publishType: json['publish_type'] ?? '',
      maxParticipants: json['max_participants'] ?? 0,
      participants: ParticipantsModel.fromJson(json['participants'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate,
      'end_date': endDate,
      'source_city': sourceCity,
      'destination_city': destinationCity,
      'trip_status': tripStatus,
      'publish_type': publishType,
      'max_participants': maxParticipants,
      'participants': (participants as ParticipantsModel).toJson(),
    };
  }
}

class ParticipantsModel extends ParticipantsEntity {
  const ParticipantsModel({
    required super.remaining,
    required super.joinStatus,
    required super.paymentStatus,
  });

  factory ParticipantsModel.fromJson(Map<String, dynamic> json) {
    return ParticipantsModel(
      remaining: json['remaining'] ?? 0,
      joinStatus: JoinStatusModel.fromJson(json['join_status'] ?? {}),
      paymentStatus: PaymentStatusModel.fromJson(json['payment_status'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'remaining': remaining,
      'join_status': (joinStatus as JoinStatusModel).toJson(),
      'payment_status': (paymentStatus as PaymentStatusModel).toJson(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'pending': pending,
      'accepted': accepted,
      'rejected': rejected,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'paid': paid,
      'unpaid': unpaid,
      'refunded': refunded,
    };
  }
}
