// lib/providers/article_provider.dart
// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';

class ArticleProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Article> _articles = [];
  Article? _selectedArticle;
  bool _isLoading = false;
  String? _error;
  bool _isLiked = false; // Status like untuk artikel yang sedang dilihat
  Map<String, bool> _articleLikeStatus =
      {}; // Menyimpan status like untuk banyak artikel

  // Getters
  List<Article> get articles => _articles;
  Article? get selectedArticle => _selectedArticle;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLiked => _isLiked;
  bool isArticleLiked(String articleId) =>
      _articleLikeStatus[articleId] ?? false;

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

  // Clear selected article
  void clearSelectedArticle() {
    _selectedArticle = null;
    notifyListeners();
  }


  Future<bool> checkLikeStatus(String articleId) async {
    try {
      final result = await _apiService.checkArticleLikeStatus(articleId);

      if (result['success']) {
        _isLiked = result['isLiked'];
        _articleLikeStatus[articleId] = result['isLiked'];
        notifyListeners();
        return result['isLiked'];
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Toggle status like artikel (versi refactor)
  Future<bool> toggleLike(String articleId) async {
    try {
      final result = await _apiService.toggleLikeArticle(articleId);

      if (result['success']) {
        // Update status like
        _isLiked = result['liked'];
        _articleLikeStatus[articleId] = result['liked'];

        // Update jumlah like di artikel yang dipilih
        if (_selectedArticle != null && _selectedArticle!.id == articleId) {
          _selectedArticle = _selectedArticle!.copyWith(
            likeCount: result['likeCount'],
          );
        }

        // Update jumlah like di daftar artikel
        final index =
            _articles.indexWhere((article) => article.id == articleId);
        if (index != -1) {
          _articles[index] = _articles[index].copyWith(
            likeCount: result['likeCount'],
          );
        }

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // setSelectedArticle untuk juga memeriksa status like
  void setSelectedArticle(Article article) {
    _selectedArticle = article;
    // Periksa status like saat artikel dipilih
    checkLikeStatus(article.id);
    notifyListeners();
  }
}
