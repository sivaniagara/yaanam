import 'package:equatable/equatable.dart';

class SignupEntity extends Equatable {
  final String name;
  final String dob;
  final String mobile;
  final String email;
  final String interest;
  final String type;
  final String deviceToken;
  final String deviceType;
  final String deviceMacAddress;
  final String profilePhoto;
  final LocationEntity location;
  final String password;

  const SignupEntity({
    required this.name,
    required this.dob,
    required this.mobile,
    required this.email,
    required this.interest,
    required this.type,
    required this.deviceToken,
    required this.deviceType,
    required this.deviceMacAddress,
    required this.profilePhoto,
    required this.location,
    required this.password,
  });

  @override
  List<Object?> get props => [
        name,
        dob,
        mobile,
        email,
        interest,
        type,
        deviceToken,
        deviceType,
        deviceMacAddress,
        profilePhoto,
        location,
        password,
      ];
}

class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final String state;
  final String city;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    required this.state,
    required this.city,
  });

  @override
  List<Object?> get props => [latitude, longitude, state, city];
}
