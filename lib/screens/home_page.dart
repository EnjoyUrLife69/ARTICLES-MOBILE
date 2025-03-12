// lib/screens/home_page.dart
// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';
import 'package:articles_mobile/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/article_model.dart';
import '../providers/article_provider.dart';
import '../providers/auth_provider.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;
  late PageController _pageController;
  Timer? _timer;
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // Fetch articles when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ArticleProvider>(context, listen: false).fetchArticles();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Initialize or restart the slideshow timer
  void _startSlideshowTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _nextSlide();
    });
  }

  void _nextSlide() {
    final articles =
        Provider.of<ArticleProvider>(context, listen: false).articles;
    if (articles.isEmpty) return;

    setState(() {
      if (_currentIndex < articles.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(_currentIndex,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  void _previousSlide() {
    final articles =
        Provider.of<ArticleProvider>(context, listen: false).articles;
    if (articles.isEmpty) return;

    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      } else {
        _currentIndex = articles.length - 1;
      }
      _pageController.animateToPage(_currentIndex,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  void _navigateToDetailPage(Article article) {
    Provider.of<ArticleProvider>(context, listen: false)
        .setSelectedArticle(article);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(article: article),
      ),
    );
  }

  // Extract unique categories from articles
  List<String> _extractCategories(List<Article> articles) {
    Set<String> categorySet = {'All'};
    for (var article in articles) {
      if (article.category != null && article.category!.name.isNotEmpty) {
        categorySet.add(article.category!.name);
      }
    }
    return categorySet.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleProvider>(
      builder: (context, articleProvider, child) {
        final articles = articleProvider.articles;
        final filteredArticles =
            articleProvider.getArticlesByCategory(_selectedCategory);

        // Extract categories once data is loaded
        if (articles.isNotEmpty && _categories.length == 1) {
          _categories = _extractCategories(articles);
          // Start slideshow timer once data is loaded
          _startSlideshowTimer();
        }

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('ARTICLES'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'login') {
                    Navigator.pushNamed(context, '/login');
                  } else if (value == 'logout') {
                    Provider.of<AuthProvider>(context, listen: false).logout();
                  }
                },
                itemBuilder: (BuildContext context) {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  return authProvider.isLoggedIn
                      ? [PopupMenuItem(value: 'logout', child: Text('Logout'))]
                      : [PopupMenuItem(value: 'login', child: Text('Login'))];
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(Icons.person, color: Colors.black),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.black),
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      final isLoggedIn = authProvider.isLoggedIn;
                      final user = authProvider.user;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: Icon(Icons.person,
                                color: Colors.black, size: 30),
                          ),
                          SizedBox(height: 10),
                          Text(isLoggedIn ? user?.name ?? "User" : "Guest",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          Text(
                              isLoggedIn ? user?.email ?? "" : "Silahkan login",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                        ],
                      );
                    },
                  ),
                ),
                ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {}),
                ListTile(
                    leading: Icon(Icons.article),
                    title: Text('Articles'),
                    onTap: () {}),
                ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {}),
                Divider(),
                // Contoh implementasi di Drawer
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () async {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    if (authProvider.isLoggedIn) {
                      final success = await authProvider.logout();
                      Navigator.pop(context); // Tutup drawer

                      if (success) {
                        // Ganti SnackBar standar dengan notifikasi elegan
                        showElegantNotification(context, 'Logout Successfully!');
                      }
                    } else {
                      Navigator.pop(context); // Tutup drawer
                      Navigator.pushNamed(context, '/login');
                    }
                  },
                ),
              ],
            ),
          ),
          body: articleProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : articleProvider.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${articleProvider.error}'),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              articleProvider.fetchArticles();
                            },
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : articles.isEmpty
                      ? Center(child: Text('No articles found'))
                      : SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            children: [
                              // Slideshow
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: PageView.builder(
                                      controller: _pageController,
                                      itemCount: articles.length,
                                      onPageChanged: (index) {
                                        setState(() {
                                          _currentIndex = index;
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        final article = articles[index];
                                        return GestureDetector(
                                          onTap: () =>
                                              _navigateToDetailPage(article),
                                          child: Stack(
                                            children: [
                                              _buildArticleImage(
                                                  article.cover, 300.0),
                                              // Gradient Overlay
                                              Container(
                                                width: double.infinity,
                                                height: 300,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.black
                                                          .withOpacity(0.3),
                                                      Colors.black
                                                          .withOpacity(0.7)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Teks Keterangan Artikel
                                              Positioned(
                                                bottom: 20,
                                                left: 20,
                                                right: 20,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      article.category?.name ??
                                                          'Uncategorized',
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      article.title,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      article.description,
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // Indikator Slide
                                  Positioned(
                                    bottom: 5,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        articles.length,
                                        (index) => Container(
                                          width: 8,
                                          height: 8,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 2),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _currentIndex == index
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Tombol Previous
                                  Positioned(
                                    left: 10,
                                    top: 100,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back_ios,
                                          color: Colors.white),
                                      onPressed: _previousSlide,
                                    ),
                                  ),
                                  // Tombol Next
                                  Positioned(
                                    right: 10,
                                    top: 100,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_forward_ios,
                                          color: Colors.white),
                                      onPressed: _nextSlide,
                                    ),
                                  ),
                                ],
                              ),

                              // Kategori Filter
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: SingleChildScrollView(
                                  physics: ClampingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      ..._categories.map((category) =>
                                          _buildCategoryChip(category,
                                              category == _selectedCategory)),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              ),

                              // Judul Bagian Artikel
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedCategory == 'All'
                                          ? 'Semua Artikel'
                                          : 'Artikel $_selectedCategory',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Lihat Semua',
                                        style: TextStyle(
                                          color: Colors.amber[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Grid Artikel
                              GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.all(8.0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 0.8,
                                ),
                                itemCount: filteredArticles.length,
                                itemBuilder: (context, index) {
                                  final article = filteredArticles[index];
                                  return GestureDetector(
                                    onTap: () => _navigateToDetailPage(article),
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Gambar Artikel
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(12)),
                                            child: Container(
                                              height:
                                                  150.0, // Atur tinggi gambar sesuai keinginan
                                              child: _buildGridArticleImage(
                                                  article.cover, 120.0),
                                            ),
                                          ),

                                          SizedBox(
                                              height:
                                                  10), // Jarak antara gambar dan kategori

                                          // Kategori (Warna Emas, Center) dengan margin top tambahan
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top:
                                                    10), // Menambah margin top untuk kategori
                                            child: Text(
                                              article.category?.name ??
                                                  'Uncategorized',
                                              style: TextStyle(
                                                color: Colors.amber[700],
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),

                                          SizedBox(
                                              height:
                                                  5), // Jarak antara kategori dan judul

                                          // Judul (Center) dengan margin top tambahan
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5,
                                                left: 10,
                                                right:
                                                    10), // Menambah margin top untuk judul
                                            child: Text(
                                              article.title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              softWrap:
                                                  true, // Membuat teks bisa wrap ke baris baru
                                              overflow: TextOverflow
                                                  .visible, // Agar teks tetap terlihat sepenuhnya
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // Judul Bagian Artikel Favorit
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Artikel Favorit',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Lihat Semua',
                                        style: TextStyle(
                                          color: Colors.amber[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // List Artikel Favorit
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    articles.length > 3 ? 3 : articles.length,
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: EdgeInsets.only(bottom: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        // Gambar
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ),
                                          child: _buildFavoriteArticleImage(
                                              articles[index].cover, 100.0),
                                        ),
                                        // Konten
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  articles[index]
                                                          .category
                                                          ?.name ??
                                                      'Uncategorized',
                                                  style: TextStyle(
                                                    color: Colors.amber[700],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  articles[index].title,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  articles[index].description,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              // Padding di bagian bawah agar tampilan lebih baik
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
        );
      },
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = label;
          });
        },
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          backgroundColor: isSelected ? Colors.black : Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _buildArticleImage(String? imageUrl, double height) {
    if (imageUrl == null || imageUrl.isEmpty) {
      log('Slideshow image URL is null or empty, using placeholder');
      return Image.network(
        'https://picsum.photos/800/400',
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
      );
    }

    log('Loading slideshow image: $imageUrl');
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) {
        log('Error loading slideshow image: $url - $error');
        return Image.network(
          'https://picsum.photos/800/400',
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildGridArticleImage(String? imageUrl, double height) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.network(
        'https://picsum.photos/400/200',
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, url, error) {
        log('Error loading grid image: $url - $error');
        return Image.network(
          'https://picsum.photos/400/200',
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildFavoriteArticleImage(String? imageUrl, double size) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.network(
        'https://picsum.photos/100/100',
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, url, error) {
        log('Error loading favorite image: $url - $error');
        return Image.network(
          'https://picsum.photos/100/100',
          width: size,
          height: size,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
