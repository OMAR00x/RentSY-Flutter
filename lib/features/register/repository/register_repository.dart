import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saved/core/domain/models/user.dart';
import 'package:saved/core/services/api_client.dart'; // ✨ 1. استيراد العميل المركزي

class RegisterRepository {
  // ✨ 2. استخدام نسخة Dio من العميل المركزي
  final Dio _dio = ApiClient().dio;

  // دالة مساعدة لقراءة رسائل الخطأ من الـ backend
  String _parseValidationErrors(Map<String, dynamic> errorData) {
    final errorMessages = errorData.entries.map((entry) {
      final errors = entry.value as List;
      return '${entry.key}: ${errors.join(', ')}';
    }).toList();
    return errorMessages.join('\n');
  }

  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String birthdate,
    required String role,
    required XFile avatar,
    required XFile idFront,
    required XFile idBack,
  }) async {
    // ✨ 3. استخدام المسار النسبي فقط
    const String apiUrl = '/register';

    try {
      final formData = FormData.fromMap({
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'birthdate': birthdate,
        'role': role,
        'avatar': await MultipartFile.fromFile(avatar.path, filename: avatar.name),
        'id_front': await MultipartFile.fromFile(idFront.path, filename: idFront.name),
        'id_back': await MultipartFile.fromFile(idBack.path, filename: idBack.name),
      });

      final response = await _dio.post(apiUrl, data: formData);

      if (response.statusCode == 201 && response.data['status'] == 'success') {
        final userJson = response.data['data']['user'];
        return UserModel.fromJson(userJson);
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 422) {
        final errorDetail = e.response?.data['message'] as Map<String, dynamic>;
        final readableError = _parseValidationErrors(errorDetail);
        throw Exception(readableError);
      } else if (e.response != null) {
        final errorMessage = e.response?.data['message'] ?? 'Server error';
        throw Exception(errorMessage);
      } else {
        throw Exception('Failed to connect to the server.');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
