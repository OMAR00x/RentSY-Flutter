import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:saved/core/domain/models/user.dart';
import 'package:saved/core/services/api_client.dart';
import 'package:saved/core/services/notidication_service.dart'; // ✨ 1. استيراد العميل الجديد

class AuthRepository {
  // ✨ 2. استخدام نسخة Dio من العميل المركزي
  final Dio _dio = ApiClient().dio;
  final _storage = const FlutterSecureStorage();

  Future<UserModel> login(String mobileNumber, String password) async {
    try {
      final String? fcmToken = await NotificationService.getFcmToken();
      log(fcmToken.toString());
      final response = await _dio.post(
        '/login', // المسار فقط، لأن العنوان الأساسي موجود في العميل
        data: {
          'phone': mobileNumber,
          'password': password,
          'fcm_token': fcmToken,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final userData = response.data['data']['user'] as Map<String, dynamic>;
        final token = response.data['data']['token'] as String;

        userData['token'] = token;
        final user = UserModel.fromJson(userData);

        // ✨ استخدام نفس المفتاح الذي استخدمناه في العميل
        await _storage.write(key: 'auth_token', value: user.token);
        debugPrint("Login successful. Token saved for user: ${user.firstName}");

        return user;
      } else {
        final errorMessage =
            response.data['message'] ?? 'An unknown error occurred';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Server error';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<UserModel?> getAuthenticatedUser() async {
    // التوكن سيتم إضافته تلقائياً بواسطة الـ Interceptor
    final token = await getToken();
    if (token == null) return null;

    try {
      // ✨ 3. الطلب أصبح أبسط بكثير
      final response = await _dio.get('/profile');

      final userData = response.data as Map<String, dynamic>;
      userData['token'] = token;
      final user = UserModel.fromJson(userData);
      debugPrint(
        "Successfully retrieved authenticated user: ${user.firstName}",
      );
      return user;
    } catch (e) {
      debugPrint("Failed to fetch user with token. Error: $e");
      // await logout(); // يفضل عدم تسجيل الخروج تلقائياً هنا
      return null;
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    debugPrint("User logged out and token deleted.");
  }
}
