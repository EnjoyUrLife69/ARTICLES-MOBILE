// lib/models/article_model.dart
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

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
