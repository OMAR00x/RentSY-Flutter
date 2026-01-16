// lib/constants/api_constants.dart

import 'dart:io';

// تحديد الـ domain تلقائياً حسب المنصة
String get domain {
  if (Platform.isAndroid) {
    return 'http://192.168.137.1:8000'; // للجوال الحقيقي
  } else {}
  return 'http://10.0.2.2:8000'; // للمحاكي
}

String get baseUrl => '$domain/api';

//const String domain = 'http://10.0.2.2:8000';
//const String baseUrl = '$domain/api';

// --- ✨ 3. هذه هي الدالة الصحيحة لعرض الصور ---
// هي تستخدم `domain` (بدون /api) وتضيف إليه /storage
String getFullImageUrl(String relativePath) {
  // إزالة أي '/' في بداية المسار النسبي لتجنب الأخطاء
  if (relativePath.startsWith('/')) {
    relativePath = relativePath.substring(1);
  }

  return '$domain/storage/$relativePath';
}
