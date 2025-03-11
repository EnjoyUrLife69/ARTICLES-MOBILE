import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../models/article_model.dart';
import '../providers/article_provider.dart';

class DetailPage extends StatelessWidget {
  final Article article;

  const DetailPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ArticleProvider>(
        builder: (context, articleProvider, child) {
          // If the article is being loaded from API
          if (articleProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there was an error loading the article
          if (articleProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${articleProvider.error}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      articleProvider.fetchArticleById(article.id);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Use the selected article from provider if available (for fresh data)
          // otherwise use the article passed to the constructor
          final displayArticle = articleProvider.selectedArticle ?? article;

          return CustomScrollView(
            slivers: [
              // App Bar with image as background
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    displayArticle.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildArticleHeaderImage(displayArticle.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Article Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category & Meta Info
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              displayArticle.category?.name ?? 'Uncategorized',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.amber[800],
                          ),
                          const Spacer(),
                          Text(
                            displayArticle.releaseDate,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Author Info
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            child:
                                const Icon(Icons.person, color: Colors.black),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            displayArticle.user?.name ?? 'Unknown Author',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        displayArticle.description,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Main Content with HTML parsing
                      Html(
                        data: displayArticle.content,
                        style: {
                          "body": Style(
                            fontSize: FontSize(16.0),
                            lineHeight: LineHeight.number(1.6),
                          ),
                          "p": Style(
                            margin: Margins.only(bottom: 16.0),
                          ),
                        },
                        onLinkTap: (url, _, __) async {
                          if (url != null) {
                            final Uri uri = Uri.parse(url);
                            try {
                              await launchUrl(uri);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Could not launch $url'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 30),

                      // Share Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.share),
                            label: const Text('Bagikan Artikel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            onPressed: () {
                              // Share functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Berbagi artikel...'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Related Articles
                      const Text(
                        'Artikel Terkait',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildRelatedArticles(context, articleProvider),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildArticleHeaderImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      log('Detail header image URL is null or empty, using placeholder');
      return Image.network(
        'https://picsum.photos/800/400',
        fit: BoxFit.cover,
      );
    }

    log('Loading detail header image: $imageUrl');
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) {
        log('Error loading detail image: $url - $error');
        return Image.network(
          'https://picsum.photos/800/400',
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildRelatedArticleImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.network(
        'https://picsum.photos/100/200',
        width: 100,
        height: 200,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 100,
      height: 200,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, url, error) {
        log('Error loading related image: $url - $error');
        return Image.network(
          'https://picsum.photos/100/200',
          width: 100,
          height: 200,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildRelatedArticles(BuildContext context, ArticleProvider provider) {
    // Get articles with the same category
    final relatedArticles = provider.articles
        .where((a) =>
            a.id != article.id && a.category?.name == article.category?.name)
        .take(3)
        .toList();

    // If there aren't enough related articles in same category, add others
    if (relatedArticles.length < 3) {
      final otherArticles = provider.articles
          .where((a) => a.id != article.id && !relatedArticles.contains(a))
          .take(3 - relatedArticles.length)
          .toList();

      relatedArticles.addAll(otherArticles);
    }

    return Container(
      height: 200,
      child: relatedArticles.isEmpty
          ? const Center(child: Text('No related articles found'))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: relatedArticles.length,
              itemBuilder: (context, index) {
                final relatedArticle = relatedArticles[index];
                return GestureDetector(
                  onTap: () {
                    provider.setSelectedArticle(relatedArticle);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(article: relatedArticle),
                      ),
                    );
                  },
                  child: Container(
                    width: 250,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child:
                              _buildRelatedArticleImage(relatedArticle.cover),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  relatedArticle.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  relatedArticle.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
