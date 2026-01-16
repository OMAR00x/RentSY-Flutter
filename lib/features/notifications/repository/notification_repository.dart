import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      print('Token: $token');
      final response = await _dio.get(
        '$baseUrl/notifications',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );
      return (response.data as List).map((e) => NotificationModel.fromJson(e)).toList();
    } catch (e) {
      print('Error getting notifications: $e');
      rethrow;
    }
  }

  Future<void> markAsRead(int id) async {
    final token = await _storage.read(key: 'auth_token');
    await _dio.put(
      '$baseUrl/notifications/$id/read',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<void> markAllAsRead() async {
    final token = await _storage.read(key: 'auth_token');
    await _dio.post(
      '$baseUrl/notifications/mark-all-read',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}