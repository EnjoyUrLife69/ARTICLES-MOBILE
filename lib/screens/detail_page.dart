import 'dart:developer';
import 'package:articles_mobile/providers/auth_provider.dart';
import 'package:articles_mobile/utils/ui_utils.dart';
import 'package:articles_mobile/widgets/custom_footer..dart';
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
      backgroundColor: Colors.white,
      body: Consumer<ArticleProvider>(
        builder: (context, articleProvider, child) {
          // Loading State
          if (articleProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }

          // Error State
          if (articleProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.black,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Error: ${articleProvider.error}',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      articleProvider.fetchArticleById(article.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black12,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Use selected article or passed article
          final displayArticle = articleProvider.selectedArticle ?? article;

          return CustomScrollView(
            slivers: [
              // Elegant White and Black SliverAppBar
              SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  displayArticle.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildArticleHeaderImage(displayArticle.cover),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Metadata Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                displayArticle.category?.name ??
                                    'Uncategorized',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              displayArticle.releaseDate,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Author Info
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.black12,
                              child: const Icon(
                                Icons.person,
                                color: Colors.black87,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayArticle.user?.name ?? 'Unknown Author',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const Text(
                                  'Staff Writer',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Description
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            displayArticle.description,
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Main Content
                        Html(
                          data: displayArticle.content,
                          style: {
                            "body": Style(
                              fontSize: FontSize(16.0),
                              lineHeight: LineHeight.number(1.6),
                              color: Colors.black,
                            ),
                            "p": Style(
                              margin: Margins.only(bottom: 16.0),
                            ),
                            "h1, h2, h3": Style(
                              color: Colors.black87,
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
                                    backgroundColor: Colors.black12,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // Share Button and Like
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Tombol Share
                            ElevatedButton.icon(
                              icon:
                                  const Icon(Icons.share, color: Colors.white),
                              label: const Text('Share Article'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Sharing article...'),
                                    backgroundColor: Colors.black54,
                                  ),
                                );
                              },
                            ),

                            // Tambahkan jarak antara tombol
                            SizedBox(width: 12),

                            // Tombol Like
                            _buildLikeButton(context, displayArticle),
                          ],
                        ),
                        
                        SizedBox(height: 20),

                        // Related Articles
                        const Text(
                          'Related Articles',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 16),
                        Consumer<ArticleProvider>(
                          builder: (context, articleProvider, _) {
                            return _buildRelatedArticles(
                              context,
                              articleProvider.articles,
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: CustomFooter(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLikeButton(BuildContext context, Article article) {
    return Consumer2<ArticleProvider, AuthProvider>(
      builder: (context, articleProvider, authProvider, _) {
        // Cek apakah user sudah login
        final isLoggedIn = authProvider.isLoggedIn;
        // Cek status like dari provider
        final isLiked = articleProvider.isLiked;

        // Logging untuk debug
        print('Building like button for article ${article.id}');
        print('User logged in: $isLoggedIn');
        print('Article is liked: $isLiked');
        print('Current like count: ${article.likeCount}');

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol Like
            ElevatedButton.icon(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.white,
              ),
              label: Text(
                isLiked ? 'Liked' : 'Like',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                print('Like button pressed for article ${article.id}');

                if (!isLoggedIn) {
                  print('User not logged in, showing login message');
                  // Jika belum login, arahkan ke halaman login
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Silahkan login terlebih dahulu'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.pushNamed(context, '/login');
                  return;
                }

                print('Attempting to toggle like...');
                // Toggle like/unlike dengan debugging
                try {
                  final success = await articleProvider.toggleLike(article.id);
                  print('Toggle like result: $success');

                  if (success) {
                    print('Like status updated to: ${articleProvider.isLiked}');
                    print(
                        'New like count: ${articleProvider.selectedArticle?.likeCount}');

                    showElegantNotification(
                      context,
                      articleProvider.isLiked
                          ? 'Article Liked'
                          : 'Article Unliked',
                    );
                  } else {
                    print('Toggle like failed with success=false');
                    // Tambahkan notifikasi kegagalan
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal mengubah status like'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  print('Exception toggling like: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),

            // Jumlah Like
            Container(
              margin: EdgeInsets.only(left: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${article.likeCount}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildArticleHeaderImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      log('Detail header image URL is null or empty, using placeholder');
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          'https://picsum.photos/800/400',
          fit: BoxFit.cover,
          color: Colors.white54,
          colorBlendMode: BlendMode.darken,
        ),
      );
    }

    log('Loading detail header image: $imageUrl');
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        color: Colors.white54,
        colorBlendMode: BlendMode.darken,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
        errorWidget: (context, url, error) {
          log('Error loading detail image: $url - $error');
          return Image.network(
            'https://picsum.photos/800/400',
            fit: BoxFit.cover,
            color: Colors.white54,
            colorBlendMode: BlendMode.darken,
          );
        },
      ),
    );
  }

  // Perbaikan untuk method _buildRelatedArticleCard
  Widget _buildRelatedArticleCard(BuildContext context, Article article) {
    return GestureDetector(
      onTap: () {
        // Set artikel yang dipilih dan navigasi ke halaman detail
        Provider.of<ArticleProvider>(context, listen: false)
            .setSelectedArticle(article);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(article: article),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: SizedBox(
                width: 120,
                height: 120,
                child: (article.cover != null && article.cover!.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: article.cover!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.network(
                          'https://picsum.photos/120/120?random=${article.id}',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      )
                    : Image.network(
                        'https://picsum.photos/120/120?random=${article.id}',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
              ),
            ),
            // Article Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        article.category?.name ?? 'Uncategorized',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Date
                    Text(
                      article.releaseDate,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedArticles(BuildContext context, List<Article> articles) {
    // Filter daftar artikel untuk mencegah artikel yang sama ditampilkan
    // dan batasi hanya 3 artikel terkait
    final relatedArticles =
        articles.where((a) => a.id != article.id).take(3).toList();

    if (relatedArticles.isEmpty) {
      return const Center(
        child: Text(
          'No related articles found',
          style: TextStyle(
            color: Colors.black54,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var relatedArticle in relatedArticles)
          _buildRelatedArticleCard(context, relatedArticle),
      ],
    );
  }
}
