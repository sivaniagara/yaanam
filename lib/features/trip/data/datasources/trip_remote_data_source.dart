import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_service.dart';
import '../models/trip_model.dart';
import '../models/view_routes_model.dart';

abstract class TripRemoteDataSource {
  Future<TripModel> createTrip(TripModel tripModel);
  Future<ViewRoutesResponseModel> viewRoutes(ViewRoutesRequestModel requestModel);
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final HttpService httpService;

  TripRemoteDataSourceImpl({required this.httpService});

  @override
  Future<TripModel> createTrip(TripModel tripModel) async {
    try {
      print("tripModel.toJson() : ${tripModel.toJson()}");
      final response = await httpService.post(
        ApiEndpoints.createTrip,
        data: tripModel.toJson(),
      );
      return TripModel.fromJson(response.data);
    } on DioException catch (e) {
      final String message = e.response?.data['message'] ?? 'Failed to create trip';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      print("e : $e");
      throw ServerException('Network error occurred');
    }
  }

  @override
  Future<ViewRoutesResponseModel> viewRoutes(ViewRoutesRequestModel requestModel) async {
    try {
      print("requestModel.toJson() : ${requestModel.toJson()}");
      final response = await httpService.post(
        ApiEndpoints.viewRoutes,
        data: requestModel.toJson(),
      );
      print("viewRoutes => ${response.data}");
      return ViewRoutesResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final String message = e.response?.data['message'] ?? 'Failed to fetch routes';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error occurred');
    }
  }
}
