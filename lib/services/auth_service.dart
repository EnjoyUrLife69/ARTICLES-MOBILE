// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  // API base URL
  final String baseUrl = 'http://192.168.100.6:8000/api';

  // Menyimpan token ke SharedPreferences
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Mendapatkan token dari SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Menyimpan data user ke SharedPreferences
  Future<void> storeUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  // Mendapatkan data user dari SharedPreferences
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');

    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Menghapus data (logout)
  Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Sesuaikan dengan struktur respons API Anda
        final user = User(
          id: responseData['data']['id'],
          name: responseData['data']['name'],
          email: responseData['data']['email'],
          image: responseData['data']['image'],
        );

        final token = responseData['access_token'];

        // Simpan token dan user di local storage
        await storeToken(token);
        await storeUser(user);

        return {
          'status': true,
          'message': 'Register berhasil',
          'user': user,
          'token': token,
        };
      } else {
        // Gagal register
        return {
          'status': false,
          'message': responseData['message'] ?? 'Registrasi gagal',
          'errors': responseData['errors'] ?? responseData,
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Untuk mendapatkan data user, kita perlu memanggil endpoint profile
        await storeToken(responseData['access_token']);

        // Fetch user profile with token
        final userResponse = await http.get(
          Uri.parse('$baseUrl/user'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${responseData['access_token']}',
          },
        );

        if (userResponse.statusCode == 200) {
          final userData = jsonDecode(userResponse.body);
          final user = User(
            id: userData['id'],
            name: userData['name'],
            email: userData['email'],
            image: userData['image'],
          );

          await storeUser(user);

          return {
            'status': true,
            'message': responseData['message'] ?? 'Login berhasil',
            'user': user,
            'token': responseData['access_token'],
          };
        } else {
          return {
            'status': false,
            'message': 'Gagal mendapatkan data profil',
          };
        }
      } else {
        // Gagal login
        return {
          'status': false,
          'message': responseData['message'] ?? 'Login gagal',
          'errors': responseData['errors'] ?? {},
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    final token = await getToken();

    if (token == null) {
      return {
        'status': false,
        'message': 'Token tidak ditemukan',
      };
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Hapus data lokal terlepas dari respons server
      await clearStorage();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': responseData['message'] ?? 'Logout berhasil',
        };
      } else {
        return {
          'status': false,
          'message': 'Gagal logout',
        };
      }
    } catch (e) {
      // Hapus data lokal meskipun error
      await clearStorage();
      return {
        'status':
            true, // masih dianggap sukses karena kita menghapus data lokal
        'message': 'Logout berhasil (lokal)',
      };
    }
  }

  // Get Profile
  Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();

    if (token == null) {
      return {
        'status': false,
        'message': 'Token tidak ditemukan',
      };
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        final user = User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          image: userData['image'],
        );

        // Update user data in local storage
        await storeUser(user);

        return {
          'status': true,
          'message': 'Profil berhasil diambil',
          'user': user,
        };
      } else {
        return {
          'status': false,
          'message': 'Gagal mendapatkan profil',
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
