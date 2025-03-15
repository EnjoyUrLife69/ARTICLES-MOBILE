// lib/main.dart
// import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/article_provider.dart';
import 'providers/auth_provider.dart'; // Pastikan ini diimpor
import 'screens/home_page.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'utils/http_override.dart';

void main() {
  // Untuk mengabaikan error sertifikat (hanya untuk development)
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ArticleProvider()),
        ChangeNotifierProvider(
            create: (context) => AuthProvider()), // Tambahkan AuthProvider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.black,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: GoogleFonts.poppins(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        // Definisikan routes
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
        },
      ),
    );
  }
}
