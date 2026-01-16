import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/message.dart';
import '../models/conversation.dart';

class ChatRepository {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Message>> getMessages(int apartmentId) async {
    final token = await _storage.read(key: 'auth_token');
    final response = await _dio.get(
      '$baseUrl/chat/messages/$apartmentId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (response.data as List).map((e) => Message.fromJson(e)).toList();
  }

  Future<Message> sendMessage({
    required int toUserId,
    required int apartmentId,
    required String body,
  }) async {
    final token = await _storage.read(key: 'auth_token');
    final response = await _dio.post(
      '$baseUrl/chat/send',
      data: {
        'to_user_id': toUserId,
        'apartment_id': apartmentId,
        'body': body,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return Message.fromJson(response.data['message']);
  }

  Future<void> markMessagesAsRead(int apartmentId) async {
    final token = await _storage.read(key: 'auth_token');
    await _dio.post(
      '$baseUrl/chat/mark-read/$apartmentId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<List<Conversation>> getConversations() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      final response = await _dio.get(
        '$baseUrl/chat/conversations',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );
      return (response.data as List).map((e) => Conversation.fromJson(e)).toList();
    } catch (e) {
      print('Error getting conversations: $e');
      rethrow;
    }
  }
}