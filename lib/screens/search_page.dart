// lib/screens/search_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/article_model.dart';
import '../providers/article_provider.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Article> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _performSearch();
    });
  }

  void _performSearch() {
    setState(() {
      _isSearching = true;
    });

    if (_searchQuery.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    final articleProvider =
        Provider.of<ArticleProvider>(context, listen: false);
    final allArticles = articleProvider.articles;

    // Melakukan pencarian berdasarkan judul, deskripsi,
    final results = allArticles.where((article) {
      final titleMatch =
          article.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final descriptionMatch = article.description
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      // final contentMatch = article.content != null
      //     ? article.content!.toLowerCase().contains(_searchQuery.toLowerCase())
      //     : false;
      final categoryMatch = article.category != null
          ? article.category!.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase())
          : false;

      return titleMatch || descriptionMatch || categoryMatch;
    }).toList();

    setState(() {
      _searchResults = results;
      _isSearching = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari artikel...',
            hintStyle: TextStyle(color: const Color.fromARGB(179, 1, 1, 1)),
            border: InputBorder.none,
          ),
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
          autofocus: true,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
        ],
      ),
      body: _isSearching
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _searchResults.isEmpty && _searchQuery.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tidak ditemukan artikel\ndengan kata kunci "$_searchQuery"',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                )
              : _searchQuery.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Cari artikel yang ingin Anda baca',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      padding: EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final article = _searchResults[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () => _navigateToDetailPage(article),
                            borderRadius: BorderRadius.circular(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Article Thumbnail
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: (article.cover != null &&
                                            article.cover!.isNotEmpty)
                                        ? CachedNetworkImage(
                                            imageUrl: article.cover!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.network(
                                              'https://picsum.photos/100/100?random=${article.id}',
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Image.network(
                                            'https://picsum.photos/100/100?random=${article.id}',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                // Article Details
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Category
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                const Color.fromARGB(255, 255, 155, 16).withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            article.category?.name ??
                                                'Uncategorized',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(221, 255, 157, 9),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        // Title
                                        Text(
                                          article.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        // Release Date
                                        Text(
                                          article.releaseDate,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
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
                      },
                    ),
    );
  }
}
