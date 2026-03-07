import 'package:equatable/equatable.dart';

class LoginResponseEntity extends Equatable {
  final String message;
  final String token;
  final LoggedUserEntity user;

  const LoginResponseEntity({
    required this.message,
    required this.token,
    required this.user,
  });

  @override
  List<Object?> get props => [message, token, user];
}

class LoggedUserEntity extends Equatable {
  final int id;
  final String name;
  final String interest;
  final String type;
  final UserLocationEntity location;
  final String state;
  final String city;

  const LoggedUserEntity({
    required this.id,
    required this.name,
    required this.interest,
    required this.type,
    required this.location,
    required this.state,
    required this.city,
  });

  @override
  List<Object?> get props => [id, name, interest, type, location, state, city];
}

class UserLocationEntity extends Equatable {
  final double x;
  final double y;

  const UserLocationEntity({
    required this.x,
    required this.y,
  });

  @override
  List<Object?> get props => [x, y];
}
