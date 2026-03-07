import '../../domain/entities/login_response_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  const LoginResponseModel({
    required super.message,
    required super.token,
    required super.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      user: LoggedUserModel.fromJson(json['user']),
    );
  }
}

class LoggedUserModel extends LoggedUserEntity {
  const LoggedUserModel({
    required super.id,
    required super.name,
    required super.interest,
    required super.type,
    required super.location,
    required super.state,
    required super.city,
  });

  factory LoggedUserModel.fromJson(Map<String, dynamic> json) {
    return LoggedUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      interest: json['interest'] ?? '',
      type: json['type'] ?? '',
      location: UserLocationModel.fromJson(json['location']),
      state: json['state'] ?? '',
      city: json['city'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'interest': interest,
      'type': type,
      'location': (location as UserLocationModel).toJson(),
      'state': state,
      'city': city,
    };
  }
}

class UserLocationModel extends UserLocationEntity {
  const UserLocationModel({
    required super.x,
    required super.y,
  });

  factory UserLocationModel.fromJson(Map<String, dynamic> json) {
    return UserLocationModel(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}
