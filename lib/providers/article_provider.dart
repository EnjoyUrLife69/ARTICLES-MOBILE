// lib/providers/article_provider.dart
import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';

class ArticleProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Article> _articles = [];
  Article? _selectedArticle;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Article> get articles => _articles;
  Article? get selectedArticle => _selectedArticle;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filter articles by category
  List<Article> getArticlesByCategory(String category) {
    if (category == 'All') {
      return _articles;
    }
    return _articles
        .where((article) => article.category?.name == category)
        .toList();
  }

  // Fetch all articles
  Future<void> fetchArticles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _articles = await _apiService.getArticles();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Fetch a single article by ID
  Future<void> fetchArticleById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedArticle = await _apiService.getArticle(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Set selected article from the existing articles list
  void setSelectedArticle(Article article) {
    _selectedArticle = article;
    notifyListeners();
  }

  // Clear selected article
  void clearSelectedArticle() {
    _selectedArticle = null;
    notifyListeners();
  }
}
