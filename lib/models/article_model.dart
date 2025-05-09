// lib/models/article_model.dart
import 'user.dart'; // Pastikan mengimpor model User

class Article {
  final String id;
  final String title;
  final String description;
  final String content;
  final String? cover;
  final String status;
  final String releaseDate;
  final int viewCount;
  final int shareCount;
  final int likeCount;
  final Category? category;
  final User? user;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    this.cover,
    required this.status,
    required this.releaseDate,
    required this.viewCount,
    required this.shareCount,
    required this.likeCount,
    this.category,
    this.user,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      cover: json['cover'], // Accept null or any string value
      status: json['status'] ?? '',
      releaseDate: json['release_date'] ?? '',
      viewCount: json['view_count'] ?? 0,
      shareCount: json['share_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      category: json['categorie'] != null
          ? Category.fromJson(json['categorie'])
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Article copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? cover,
    String? status,
    String? releaseDate,
    int? viewCount,
    int? shareCount,
    int? likeCount,
    Category? category,
    User? user,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      cover: cover ?? this.cover,
      status: status ?? this.status,
      releaseDate: releaseDate ?? this.releaseDate,
      viewCount: viewCount ?? this.viewCount,
      shareCount: shareCount ?? this.shareCount,
      likeCount: likeCount ?? this.likeCount,
      category: category ?? this.category,
      user: user ?? this.user,
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

