import 'dart:convert';
import 'dart:developer' as developer;
import 'package:articles_mobile/services/auth_service.dart';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  // API base URL
  static const String baseUrl = 'http://192.168.0.210:8000/api';

  // Get all articles with debug logging
  Future<List<Article>> getArticles() async {
    try {
      developer.log('Fetching articles from: $baseUrl/articles');
      final response = await http.get(Uri.parse('$baseUrl/articles'));

      developer.log('Response status code: ${response.statusCode}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        developer.log(
            'Response body: ${response.body.substring(0, min(500, response.body.length))}...');

        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          List<dynamic> articlesJson = jsonResponse['data'];

          // Log the first article to check its structure
          if (articlesJson.isNotEmpty) {
            developer.log(
                'First article structure: ${json.encode(articlesJson[0])}');
            if (articlesJson[0]['cover'] != null) {
              developer.log('Cover URL: ${articlesJson[0]['cover']}');
            } else {
              developer.log('Cover is null in the first article');
            }
          }

          return articlesJson.map((json) => Article.fromJson(json)).toList();
        } else {
          throw Exception(
              'Failed to parse articles data: ${jsonResponse['message'] ?? 'Unknown error'}');
        }
      } else {
        developer.log('Error response body: ${response.body}');
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Exception during API call: $e');
      throw Exception('Failed to fetch articles: $e');
    }
  }

  // Get single article by ID with debug logging
  Future<Article> getArticle(String id) async {
    try {
      developer.log('Fetching article with ID: $id');
      final response = await http.get(Uri.parse('$baseUrl/articles/$id'));

      developer.log('Response status code: ${response.statusCode}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        developer.log(
            'Response body: ${response.body.substring(0, min(500, response.body.length))}...');

        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          // Log the article structure
          developer
              .log('Article structure: ${json.encode(jsonResponse['data'])}');
          if (jsonResponse['data']['cover'] != null) {
            developer.log('Cover URL: ${jsonResponse['data']['cover']}');
          } else {
            developer.log('Cover is null in article data');
          }

          return Article.fromJson(jsonResponse['data']);
        } else {
          throw Exception(
              'Failed to parse article data: ${jsonResponse['message'] ?? 'Unknown error'}');
        }
      } else {
        developer.log('Error response body: ${response.body}');
        throw Exception('Failed to load article: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Exception during API call: $e');
      throw Exception('Failed to fetch article: $e');
    }
  }

  // Helper function for min
  int min(int a, int b) {
    return a < b ? a : b;
  }

  // Like/Unlike artikel (toggle)
  Future<Map<String, dynamic>> toggleLikeArticle(String articleId) async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Anda harus login terlebih dahulu',
        };
      }

      developer.log('Toggling like for article ID: $articleId');

      final response = await http.post(
        Uri.parse('$baseUrl/articles/$articleId/like'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      developer.log('Like toggle response status code: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        developer.log('Like toggle response: ${json.encode(jsonResponse)}');

        return {
          'success': true,
          'liked': jsonResponse['liked'] ?? false,
          'likeCount': jsonResponse['like_count'] ?? 0,
          'message': jsonResponse['message'] ?? 'Berhasil mengubah status like',
        };
      } else {
        developer.log('Error like toggle response: ${response.body}');
        return {
          'success': false,
          'message': 'Gagal mengubah status like: ${response.statusCode}',
        };
      }
    } catch (e) {
      developer.log('Exception during like toggle API call: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Check like status for an article
  Future<Map<String, dynamic>> checkArticleLikeStatus(String articleId) async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();

      if (token == null) {
        return {
          'success': true,
          'isLiked': false,
        };
      }

      developer.log('Checking like status for article ID: $articleId');

      final response = await http.get(
        Uri.parse('$baseUrl/articles/$articleId/check-like'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      developer.log('Check like status response code: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        developer
            .log('Check like status response: ${json.encode(jsonResponse)}');

        return {
          'success': true,
          'isLiked': jsonResponse['is_liked'] ?? false,
        };
      } else {
        developer.log('Error check like status response: ${response.body}');
        return {
          'success': false,
          'isLiked': false,
          'message': 'Gagal memeriksa status like: ${response.statusCode}',
        };
      }
    } catch (e) {
      developer.log('Exception during check like status API call: $e');
      return {
        'success': false,
        'isLiked': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Update the share count of an article
  Future<Map<String, dynamic>> updateArticleShareCount(String articleId) async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'User not logged in or no token available',
        };
      }

      Dio dio = Dio();

      final response = await dio.post(
        '$baseUrl/articles/update-share/$articleId', // Corrected the URL
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Menambahkan token ke header
          },
        ),
      );

      // Log the response data to check what the server returns
      print('Response Data: ${response.data}');
      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Berhasil
        print('Share count updated: ${response.data['share_count']}');
        return {
          'success': true,
          'shareCount': response.data['share_count'] ?? 0,
        };
      } else {
        // Gagal
        print(
            'Failed to update share count. Status code: ${response.statusCode}');
        print('Response: ${response.data}');
        return {
          'success': false,
          'message': 'Failed to update share count',
        };
      }
    } catch (e) {
      print('API Error updating share count: $e');
      return {'success': false, 'message': 'Failed to update share count'};
    }
  }
}
