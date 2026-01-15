import 'dart:io';
import 'package:dio/dio.dart';
import 'package:saved/core/domain/models/user.dart';
import 'package:saved/core/services/api_client.dart'; // ✨ 1. استيراد العميل

class ProfileRepository {
  // ✨ 2. استخدام نفس العميل المركزي
  final Dio _dio = ApiClient().dio;

  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    String? password,
    File? avatar,
  }) async {
    try {
      final Map<String, dynamic> data = {
        '_method': 'PUT', // ✨ ملاحظة مهمة: بعض الـ backends تتطلب هذا الحقل مع FormData
        'first_name': firstName,
        'last_name': lastName,
      };

      if (password != null && password.isNotEmpty) {
        data['password'] = password;
      }

      if (avatar != null) {
        String fileName = avatar.path.split('/').last;
        data['avatar'] = await MultipartFile.fromFile(avatar.path, filename: fileName);
      }

      final formData = FormData.fromMap(data);

      // ✨ 3. استخدام post مع FormData لتحديث البيانات (أكثر توافقية)
      final response = await _dio.post('/profile', data: formData);

      // الـ API يرجع بيانات المستخدم المحدثة
      return UserModel.fromJson(response.data);

    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Failed to update profile';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
