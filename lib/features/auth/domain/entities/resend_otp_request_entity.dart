import 'package:equatable/equatable.dart';

class ResendOtpRequestEntity extends Equatable {
  final String mobile;

  const ResendOtpRequestEntity({required this.mobile});

  @override
  List<Object?> get props => [mobile];
}
