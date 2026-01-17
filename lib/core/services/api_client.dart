import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:saved/constants/api_constants.dart';

class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          
          const storage = FlutterSecureStorage();
          final token = await storage.read(key: 'auth_token'); 
         
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Accept'] = 'application/json';

         
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          
          return handler.next(e);
        },
      ),
    );
  }

  
  Dio get dio => _dio;
}
