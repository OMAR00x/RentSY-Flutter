import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:saved/constants/api_constants.dart';

class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // جلب التوكن من التخزين الآمن
          const storage = FlutterSecureStorage();
          final token = await storage.read(key: 'auth_token'); // ✨ استخدام المفتاح الصحيح

          // إذا كان التوكن موجوداً، أضفه إلى الهيدر
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Accept'] = 'application/json';

          // استكمل الطلب
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // يمكنك التعامل مع الأخطاء العامة هنا (مثل انتهاء صلاحية التوكن)
          return handler.next(e);
        },
      ),
    );
  }

  // دالة getter للوصول إلى نسخة Dio من خارج الكلاس
  Dio get dio => _dio;
}
