import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_service.dart';
import '../models/organiser_trip_model.dart';
import '../models/trip_model.dart';
import '../models/view_routes_model.dart';

abstract class TripRemoteDataSource {
  Future<TripModel> createTrip(TripModel tripModel);
  Future<TripModel> updateTrip(TripModel tripModel);
  Future<ViewRoutesResponseModel> viewRoutes(ViewRoutesRequestModel requestModel);
  Future<List<TripModel>> getTrips(String endpoint);
  Future<List<OrganiserTripModel>> getOrganisedTrips();
  Future<TripModel> getTripDetail(int tripId);
  Future<void> publishTrip(int tripId);
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
      print("createTrip response => ${response.data}");

      if (response.data['success'] == true) {
        final tripData = response.data['data'];
        final Map<String, dynamic> normalizedData = Map.from(tripData);
        normalizedData['id'] = tripData['trip_id'];
        return TripModel.fromJson(normalizedData);
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to create trip');
      }
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
  Future<TripModel> updateTrip(TripModel tripModel) async {
    try {
      final String endpoint = ApiEndpoints.updateTrip.replaceAll(':tripId', tripModel.id.toString());
      print("updateTrip endpoint: $endpoint");
      print("tripModel.toJson() : ${tripModel.toJson()}");
      final response = await httpService.put(
        endpoint,
        data: tripModel.toJson(),
      );
      print("updateTrip response => ${response.data}");

      if (response.data['success'] == true) {
        return TripModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to update trip');
      }
    } on DioException catch (e) {
      final String message = e.response?.data['message'] ?? 'Failed to update trip';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
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

  @override
  Future<List<TripModel>> getTrips(String endpoint) async {
    try {
      final response = await httpService.get(endpoint);
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => TripModel.fromJson(json)).toList();
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch trips');
      }
    } on DioException catch (e) {
      final String message = e.response?.data['message'] ?? 'Failed to fetch trips';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error occurred');
    }
  }

  @override
  Future<List<OrganiserTripModel>> getOrganisedTrips() async {
    try {
      final response = await httpService.get(ApiEndpoints.organiseTrips);
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data']['trips'] ?? [];
        return data.map((json) => OrganiserTripModel.fromJson(json)).toList();
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch organised trips');
      }
    } on DioException catch (e) {
      final String message = e.response?.data['message'] ?? 'Failed to fetch organised trips';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error occurred');
    }
  }

  @override
  Future<TripModel> getTripDetail(int tripId) async {
    try {
      final String endpoint = ApiEndpoints.getTrip.replaceAll(':tripId', tripId.toString());
      final response = await httpService.get(endpoint);
      if (response.data['success'] == true) {
        return TripModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch trip details');
      }
    } on DioException catch (e) {
      final String message = e.response?.data['message'] ?? 'Failed to fetch trip details';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error occurred');
    }
  }

  @override
  Future<void> publishTrip(int tripId) async {
    try {
      final String endpoint = ApiEndpoints.publishTrip.replaceAll(':tripId', tripId.toString());
      final response = await httpService.put(
        endpoint,
        data: {"action": "publish"},
      );
      if (response.data['success'] != true) {
        throw ServerException(response.data['message'] ?? 'Failed to publish trip');
      }
    } on DioException catch (e) {
      final String message = e.response?.data['message'] ?? 'Failed to publish trip';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error occurred');
    }
  }
}
