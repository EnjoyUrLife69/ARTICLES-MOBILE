// lib/widgets/article_card.dart

import 'package:flutter/material.dart';
import '../models/article_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Artikel
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: article.cover ??
                  'https://picsum.photos/400/200', // Default if no cover
              height: 150.0,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
            ),
          ),
          SizedBox(height: 10),
          // Judul Artikel
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              article.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 5),
          // Kategori Artikel
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              article.category?.name ?? 'Uncategorized',
              style: TextStyle(color: Colors.amber[700], fontSize: 12),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
