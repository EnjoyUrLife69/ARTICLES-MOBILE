// lib/utils/http_override.dart
import 'dart:io';

// Class untuk mengatasi masalah sertifikat SSL/TLS
// PERHATIAN: Ini hanya untuk development, jangan gunakan di production!
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
