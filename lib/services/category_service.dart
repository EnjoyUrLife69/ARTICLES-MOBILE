// lib/services/category_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  final String baseUrl = 'http://192.168.100.4:8000/api/categories';

  // Fetch all categories
  Future<List<dynamic>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        
        // Check if response is wrapped in a data field
        if (decodedData is Map && decodedData.containsKey('data')) {
          return decodedData['data'];
        }
        
        // If it's directly a list
        if (decodedData is List) {
          return decodedData;
        }
        
        // Otherwise, return as is
        return [decodedData];
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }

  // Fetch a specific category by ID
  Future<dynamic> fetchCategoryById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        
        // Check if response is wrapped in a data field
        if (decodedData is Map && decodedData.containsKey('data')) {
          return decodedData['data'];
        }
        
        return decodedData;
      } else {
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load category: $e');
    }
  }
}