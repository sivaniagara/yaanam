import '../../domain/entities/signup_entity.dart';

class SignupModel extends SignupEntity {
  const SignupModel({
    required super.name,
    required super.dob,
    required super.mobile,
    required super.email,
    required super.interest,
    required super.type,
    required super.deviceToken,
    required super.deviceType,
    required super.deviceMacAddress,
    required super.profilePhoto,
    required super.location,
    required super.password,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      name: json['name'],
      dob: json['dob'],
      mobile: json['mobile'],
      email: json['email'],
      interest: json['interest'],
      type: json['type'],
      deviceToken: json['device_token'],
      deviceType: json['device_type'],
      deviceMacAddress: json['device_mac_address'],
      profilePhoto: json['profile_photo'],
      location: LocationModel.fromJson(json['location']),
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dob': dob,
      'mobile': mobile,
      'email': email,
      'interest': interest,
      'type': type,
      'device_token': deviceToken,
      'device_type': deviceType,
      'device_mac_address': deviceMacAddress,
      'profile_photo': profilePhoto,
      'location': (location as LocationModel).toJson(),
      'password': password,
    };
  }
}

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    required super.state,
    required super.city,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      state: json['state'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'state': state,
      'city': city,
    };
  }
}
