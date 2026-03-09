import '../../domain/entities/update_password_response_entity.dart';

class UpdatePasswordResponseModel extends UpdatePasswordResponseEntity {
  const UpdatePasswordResponseModel({required super.message});

  factory UpdatePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordResponseModel(
      message: json['message'] ?? '',
    );
  }
}
