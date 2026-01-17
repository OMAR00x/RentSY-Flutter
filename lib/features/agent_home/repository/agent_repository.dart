import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:saved/core/domain/models/amenity_model.dart';
import 'package:saved/core/domain/models/apartment_model.dart';
import 'package:saved/core/domain/models/area_model.dart';
import 'package:saved/core/domain/models/booking_model.dart';
import 'package:saved/core/domain/models/city_model.dart';
import 'package:saved/core/services/api_client.dart';

class AgentRepository {
  final Dio _dio = ApiClient().dio;

  Future<List<AmenityModel>> getAmenities() async {
    const String endpoint = '/amenities';
    try {
      final response = await _dio.get(endpoint);
      final List amenitiesJson = response.data as List;
      return amenitiesJson.map((json) => AmenityModel.fromJson(json)).toList();
    } on DioException catch (e) {
      log('DioException in getAmenities: ${e.response?.data ?? e.message}'); 
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load amenities',
      );
    }
  }

  Future<List<CityModel>> getCities() async {
    const String endpoint = '/cities';
    try {
      final response = await _dio.get(endpoint);
      final List citiesJson = response.data as List;
      return citiesJson.map((json) => CityModel.fromJson(json)).toList();
    } on DioException catch (e) {
      log('DioException in getCities: ${e.response?.data ?? e.message}'); 
      throw Exception(e.response?.data['message'] ?? 'Failed to load cities');
    }
  }

  Future<List<AreaModel>> getAreasForCity(int cityId) async {
    final String endpoint = '/cities/$cityId/areas';
    try {
      final response = await _dio.get(endpoint);
      final List areasJson = response.data as List;
      return areasJson.map((json) => AreaModel.fromJson(json)).toList();
    } on DioException catch (e) {
      log('DioException in getAreasForCity: ${e.response?.data ?? e.message}'); 
      throw Exception(e.response?.data['message'] ?? 'Failed to load areas');
    }
  }

  Future<List<ApartmentModel>> getMyApartments() async {
    const String endpoint = '/my-apartments';
    try {
      final response = await _dio.get(endpoint);
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List apartmentsJson = response.data['data'] as List;
        return apartmentsJson
            .map((json) => ApartmentModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to load apartments',
        );
      }
    } on DioException catch (e) {
      log('DioException in getMyApartments: ${e.response?.data ?? e.message}'); 
      throw Exception(
        e.response?.data['message'] ?? 'Failed to connect to the server.',
      );
    }
  }

  
  Future<List<BookingModel>> getAgentBookingRequests({int? apartmentId}) async {
    const String endpoint = '/apartment-bookings';
    try {
      Response response;
      if (apartmentId != null) {
        response = await _dio.get(
          endpoint,
          queryParameters: {'apartment_id': apartmentId},
        );
      } else {
        response = await _dio.get(endpoint);
      }

      if (response.data is List) {
        final List responseData = response.data as List;
        return responseData
            .map((bookingJson) => BookingModel.fromJson(bookingJson))
            .toList();
      } else {
        throw Exception(
          'API response for agent booking requests is not a list as expected.',
        );
      }
    } on DioException catch (e) {
      log('DioException in getAgentBookingRequests: ${e.response?.data ?? e.message}');
      final errorMessage =
          e.response?.data?['message'] ??
          'Failed to load agent booking requests. Please try again.';
      throw Exception(errorMessage);
    } catch (e) {
      log('Unexpected error in getAgentBookingRequests: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  
  Future<BookingModel> updateBookingStatus(int bookingId, String status) async {
    final String endpoint = '/bookings/$bookingId/status'; 
    try {
      final response = await _dio.put(
        endpoint,
        data: {'status': status}, 
      );
      if (response.statusCode == 200) {
        return BookingModel.fromJson(response.data['data']);
      } else {
        throw Exception(
          'Failed to update booking status: Unexpected status code ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      log('DioException in updateBookingStatus: ${e.response?.data ?? e.message}');
      final errorMessage =
          e.response?.data?['message'] ??
          'Failed to update booking status. Please try again.';
      throw Exception(errorMessage);
    } catch (e) {
      log('Unexpected error in updateBookingStatus: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
  Future<ApartmentModel> addApartment({
    required String title,
    required String description,
    required String price,
    required int rooms,
    required String address,
    required int cityId,
    required int areaId,
    required List<int> amenities,
    required List<XFile> images,
  }) async {
    const String endpoint = '/apartments';
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      'price': price,
      'price_type': 'daily',
      'rooms': rooms,
      'address': address,
      'city_id': cityId,
      'area_id': areaId,
    });
    for (int i = 0; i < images.length; i++) {
      formData.files.add(
        MapEntry(
          'images[$i]',
          await MultipartFile.fromFile(
            images[i].path,
            filename: images[i].name,
          ),
        ),
      );
    }
    for (int i = 0; i < amenities.length; i++) {
      formData.fields.add(MapEntry('amenities[$i]', amenities[i].toString()));
    }
    try {
      final response = await _dio.post(endpoint, data: formData);
      if (response.statusCode == 201 && response.data['status'] == 'success') {
        return ApartmentModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to add apartment');
      }
    } on DioException catch (e) {
      log('DioException in addApartment: ${e.response?.data ?? e.message}'); 
      throw Exception(e.response?.data['message'] ?? 'Server error on add');
    }
  }

  Future<void> deleteApartment(int apartmentId) async {
    final String endpoint = '/apartments/$apartmentId';
    try {
      await _dio.delete(endpoint);
    } on DioException catch (e) {
      log('DioException in deleteApartment: ${e.response?.data ?? e.message}'); 
      throw Exception(e.response?.data['message'] ?? 'Server error on delete');
    }
  }
}
