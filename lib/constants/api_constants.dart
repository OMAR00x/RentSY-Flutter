// lib/constants/api_constants.dart

// --- ✨ 1. هذا هو عنوان السيرفر الأساسي فقط ---
// لا يحتوي على /api
const String domain = 'http://192.168.137.1:8000';

// --- ✨ 2. هذا هو المسار الكامل لنقاط نهاية الـ API ---
const String baseUrl = '$domain/api'; 

// --- ✨ 3. هذه هي الدالة الصحيحة لعرض الصور ---
// هي تستخدم `domain` (بدون /api) وتضيف إليه /storage
String getFullImageUrl(String relativePath) {
  // إزالة أي '/' في بداية المسار النسبي لتجنب الأخطاء
  if (relativePath.startsWith('/')) {
    relativePath = relativePath.substring(1);
  }
  
  return '$domain/storage/$relativePath';
}
