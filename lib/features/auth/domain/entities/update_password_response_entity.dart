import 'package:equatable/equatable.dart';

class UpdatePasswordResponseEntity extends Equatable {
  final String message;

  const UpdatePasswordResponseEntity({required this.message});

  @override
  List<Object?> get props => [message];
}
