// lib/screens/category_articles_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article_model.dart';
import '../providers/article_provider.dart';
import '../widgets/article_card.dart'; // Jika Anda ingin membuat widget kartu artikel terpisah
import 'detail_page.dart';

class CategoryArticlesPage extends StatelessWidget {
  final String categoryName;

  CategoryArticlesPage({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$categoryName Articles',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.deepPurpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer<ArticleProvider>(
        builder: (context, articleProvider, child) {
          // Mendapatkan artikel berdasarkan kategori
          final articles = articleProvider.getArticlesByCategory(categoryName);

          if (articles.isEmpty) {
            return _noArticlesFound(); // Tampilkan pesan jika tidak ada artikel
          }

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () => _navigateToDetailPage(context, article),
                  child: ArticleCard(
                      article: article), // Custom article card widget
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Fungsi untuk menavigasi ke halaman detail artikel
  void _navigateToDetailPage(BuildContext context, Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(article: article),
      ),
    );
  }

  // Widget untuk menampilkan jika tidak ada artikel
  Widget _noArticlesFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No articles found in this category.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Optional: Refresh the page or show more options
            },
            icon: Icon(Icons.refresh),
            label: Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
