// lib/services/api_service.dart
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class ApiService {
  // Replace with your API base URL - adjust based on your environment
  static const String baseUrl = 'http://192.168.100.5:8000/api'; // Android emulator
  // static const String baseUrl = 'http://127.0.0.1:8000/api'; // iOS simulator
  // static const String baseUrl = 'https://your-production-api.com/api'; // Production

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
}
