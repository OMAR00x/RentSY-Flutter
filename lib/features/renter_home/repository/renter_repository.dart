import 'package:dio/dio.dart';
import 'package:saved/core/domain/models/apartment_model.dart';
import 'package:saved/core/domain/models/booking_model.dart';
import 'package:saved/core/services/api_client.dart'; // ✨ 1. استيراد العميل المركزي

class RenterRepository {
  // ✨ 2. استخدام نسخة Dio من العميل المركزي
  final Dio _dio = ApiClient().dio;

  /// يجلب كل الشقق المتاحة للعرض للمستأجر
  Future<List<ApartmentModel>> getAllApartments() async {
    // ✨ 3. المسار الذي أعطيتني إياه
    const String endpoint = '/apartments';

    try {
      // ✨ 4. الطلب أصبح بسيطاً جداً لأن التوكن يضاف تلقائياً
      final response = await _dio.get(endpoint);

      // الـ API يرجع قائمة مباشرة، لذا نقوم بتحويلها
      if (response.data is List) {
        final List responseData = response.data as List;
        
        // تحويل كل عنصر في القائمة إلى ApartmentModel
        return responseData
            .map((apartmentJson) => ApartmentModel.fromJson(apartmentJson))
            .toList();
      } else {
        // في حال أرجع الـ API شيئاً غير متوقع (ليس قائمة)
        throw Exception('API response is not a list as expected.');
      }
    } on DioException catch (e) {
      // التعامل مع أخطاء الشبكة والـ API
      final errorMessage = e.response?.data?['message'] ?? 'Failed to load apartments. Please try again.';
      throw Exception(errorMessage);
    } catch (e) {
      // للتعامل مع أي أخطاء أخرى غير متوقعة
      throw Exception('An unexpected error occurred: $e');
    }
  }
  Future<bool> toggleFavoriteApartment(int apartmentId) async {
    final String endpoint = '/apartments/$apartmentId/favorite';
    try {
      final response = await _dio.post(endpoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // نتوقع أن الـ API سيرجع {"is_favorite": true/false}
        return response.data['is_favorite'] ?? false;
      } else {
        throw Exception('Failed to toggle favorite status: Unexpected status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? 'Failed to toggle favorite status. Please try again.';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // ✨ جديد: دالة لجلب الشقق المفضلة للمستأجر
  Future<List<ApartmentModel>> getFavoriteApartments() async {
    const String endpoint = '/favorites';
    try {
      final response = await _dio.get(endpoint);
      if (response.data is List) {
        final List responseData = response.data as List;
        return responseData
            .map((apartmentJson) => ApartmentModel.fromJson(apartmentJson))
            .toList();
      } else {
        throw Exception('API response for favorites is not a list as expected.');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? 'Failed to load favorite apartments. Please try again.';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<BookingModel> createBooking({
    required int apartmentId,
    required DateTime startDate,
    required DateTime endDate,
    required String paymentMethod,
  }) async {
    const String endpoint = '/bookings'; // المسار الذي أعطيتني إياه
    try {
      final response = await _dio.post(
        endpoint,
        data: {
          'apartment_id': apartmentId,
          'start_date': startDate.toIso8601String().split('T').first, // تنسيق التاريخ ليتناسب مع الـ API
          'end_date': endDate.toIso8601String().split('T').first,     // تنسيق التاريخ ليتناسب مع الـ API
          'payment_method': paymentMethod,
        },
      );

      if (response.statusCode == 201) { // 201 Created is typical for successful creation
        // الـ API يرجع كائن BookingModel مباشرة تحت مفتاح 'data'
        return BookingModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to create booking: Unexpected status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? 'Failed to create booking. Please try again.';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
  Future<List<BookingModel>> getMyBookings() async {
    const String endpoint = '/my-bookings'; // The user provided this endpoint
    try {
      final response = await _dio.get(endpoint);
      if (response.data is List) {
        final List responseData = response.data as List;
        return responseData
            .map((bookingJson) => BookingModel.fromJson(bookingJson))
            .toList();
      } else {
        throw Exception('API response for my-bookings is not a list as expected.');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? 'Failed to load your bookings. Please try again.';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
  Future<BookingModel> rescheduleBooking({
    required int bookingId,
    required DateTime newStartDate,
    required DateTime newEndDate,
  }) async {
    final String endpoint = '/bookings/$bookingId/reschedule';
    try {
      final response = await _dio.put(
        endpoint,
        data: {
          'start_date': newStartDate.toIso8601String().split('T').first,
          'end_date': newEndDate.toIso8601String().split('T').first,
        },
      );
      if (response.statusCode == 200) { // Assuming 200 OK for successful update
        // The API returns the updated booking directly, according to common practices.
        // If it returns a different structure, adjust this part.
        return BookingModel.fromJson(response.data);
      } else {
        throw Exception('Failed to reschedule booking: Unexpected status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? 'Failed to reschedule booking. Please try again.';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Cancels an existing booking.
  Future<void> cancelBooking({required int bookingId}) async {
    final String endpoint = '/bookings/$bookingId';
    try {
      final response = await _dio.delete(endpoint);
      if (response.statusCode != 200 && response.statusCode != 204) { // 200 OK or 204 No Content for successful delete
        throw Exception('Failed to cancel booking: Unexpected status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? 'Failed to cancel booking. Please try again.';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}

