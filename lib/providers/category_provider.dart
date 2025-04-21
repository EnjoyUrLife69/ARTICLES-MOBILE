import 'package:flutter/material.dart';
import '../services/category_service.dart'; // Your service to interact with the API

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<dynamic> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all categories
  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      var fetchedCategories = await _categoryService.fetchCategories();

      // Process the categories to ensure article counts are available
      _categories = fetchedCategories.map((category) {
        // Add a default value if articles_count doesn't exist
        if (!category.containsKey('articles_count')) {
          category['articles_count'] = 0;
        }
        return category;
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Fetch category by ID (if needed)
  Future<void> fetchCategoryById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch single category if needed
      final category = await _categoryService.fetchCategoryById(id);
      _categories = [
        category
      ]; // Update the categories list with the fetched category
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Clear error message if necessary
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
