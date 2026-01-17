
import 'dart:io';

String get domain {
  if (Platform.isAndroid) {
    return 'http://192.168.1.103:8000'; 
  } else {}
  return 'http://10.0.2.2:8000'; 
}

String get baseUrl => '$domain/api';

String getFullImageUrl(String relativePath) {
  
  if (relativePath.startsWith('/')) {
    relativePath = relativePath.substring(1);
  }

  return '$domain/storage/$relativePath';
}
