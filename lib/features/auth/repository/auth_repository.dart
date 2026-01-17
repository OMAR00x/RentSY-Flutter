import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:saved/core/domain/models/user.dart';
import 'package:saved/core/services/api_client.dart';
import 'package:saved/core/services/notidication_service.dart'; 

class AuthRepository {
  
  final Dio _dio = ApiClient().dio;
  final _storage = const FlutterSecureStorage();

  Future<UserModel> login(String mobileNumber, String password) async {
    try {
      final String? fcmToken = await NotificationService.getFcmToken();
      log(fcmToken.toString());
      final response = await _dio.post(
        '/login', 
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
    
    final token = await getToken();
    if (token == null) return null;

    try {
      
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
      
      return null;
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> logout() async {
    try {
      final String? fcmToken = await NotificationService.getFcmToken();
      if (fcmToken != null) {
        await _dio.post('/logout', data: {'fcm_token': fcmToken});
      }
    } catch (e) {
      debugPrint("Error during logout API call: $e");
    }
    await _storage.delete(key: 'auth_token');
    debugPrint("User logged out and token deleted.");
  }
}
