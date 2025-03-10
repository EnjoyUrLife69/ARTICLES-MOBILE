import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: GoogleFonts.poppins(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> articles = [
    {
      'image': 'https://picsum.photos/800/400?random=1',
      'category': 'Technology',
      'title': 'Masa Depan AI dan Peran Manusia',
      'description':
          'Bagaimana AI akan mengubah masa depan manusia dan industri teknologi?',
      'content':
          'Kecerdasan buatan (AI) telah menjadi salah satu teknologi paling revolusioner di era digital. Seiring perkembangannya yang pesat, banyak pertanyaan muncul tentang bagaimana AI akan membentuk masa depan kita.\n\nBerbagai industri, mulai dari kesehatan hingga transportasi, telah mulai mengadopsi solusi berbasis AI untuk meningkatkan efisiensi dan inovasi. Namun, ini juga memunculkan pertanyaan penting tentang peran manusia di masa depan.\n\nPara ahli memprediksi bahwa alih-alih menggantikan pekerjaan manusia secara keseluruhan, AI akan lebih banyak berperan sebagai alat yang memperkuat kemampuan manusia. Kolaborasi antara manusia dan AI dipercaya akan menciptakan peluang baru dan solusi inovatif untuk berbagai tantangan global.\n\nPada akhirnya, kunci untuk menghadapi masa depan dengan AI adalah dengan terus beradaptasi dan mengembangkan keterampilan yang melengkapi kemampuan AI, seperti kreativitas, empati, dan pemikiran kritis.',
      'author': 'Dr. Satria Wijaya',
      'date': '10 Maret 2025',
    },
    {
      'image': 'https://picsum.photos/800/400?random=2',
      'category': 'Business',
      'title': 'Strategi Sukses di Era Digital',
      'description':
          'Tips dan strategi sukses membangun bisnis di era digital modern.',
      'content':
          'Era digital telah mengubah lanskap bisnis secara fundamental. Perusahaan yang tidak beradaptasi dengan cepat berisiko tertinggal atau bahkan hilang dari persaingan.\n\nBeberapa strategi kunci untuk sukses di era digital meliputi:\n\n1. Adopsi teknologi yang tepat: Identifikasi teknologi yang dapat meningkatkan efisiensi operasional dan pengalaman pelanggan.\n\n2. Fokus pada pengalaman pelanggan: Pastikan setiap interaksi digital dengan pelanggan dirancang dengan baik dan memberikan nilai tambah.\n\n3. Analisis data: Manfaatkan big data dan analitik untuk mendapatkan wawasan berharga tentang pelanggan dan pasar.\n\n4. Fleksibilitas dan agilitas: Kembangkan struktur organisasi yang dapat beradaptasi dengan cepat terhadap perubahan pasar dan teknologi.\n\n5. Investasi pada SDM digital: Rekrut dan kembangkan talenta dengan keterampilan digital yang kuat.\n\nDengan menerapkan strategi-strategi ini, bisnis dari berbagai ukuran dapat memanfaatkan peluang yang ditawarkan oleh transformasi digital dan tetap kompetitif di pasar yang terus berkembang.',
      'author': 'Indra Kusuma',
      'date': '8 Maret 2025',
    },
    {
      'image': 'https://picsum.photos/800/400?random=3',
      'category': 'Food',
      'title': 'Kuliner Unik dari Berbagai Negara',
      'description': 'Mencicipi makanan unik dari seluruh dunia.',
      'content':
          'Dunia kuliner menawarkan kekayaan rasa dan pengalaman yang tak terbatas. Setiap negara memiliki hidangan khas yang menceritakan sejarah, budaya, dan tradisi mereka.\n\nDi Jepang, Fugu atau ikan buntal adalah hidangan yang terkenal karena bahayanya. Jika tidak disiapkan dengan benar oleh koki bersertifikat, ikan ini bisa beracun dan mematikan. Namun, bagi yang berani mencoba, kelezatan dagingnya yang lembut dan rasa uniknya membuat pengalaman ini layak dicoba.\n\nMoving to Peru, ceviche—a dish of raw fish cured in citrus juices—has become internationally renowned. The acidity of the lime or lemon juice "cooks" the fish without heat, resulting in a refreshing and tangy flavor profile.\n\nDi Indonesia sendiri, kita memiliki banyak hidangan unik seperti Kopi Luwak, yang terkenal sebagai kopi termahal di dunia karena proses produksinya yang tidak biasa melalui sistem pencernaan musang.\n\nMenjelajahi kuliner dari berbagai negara tidak hanya memuaskan lidah, tetapi juga memperluas wawasan kita tentang kekayaan budaya dunia melalui bahasa universal: makanan.',
      'author': 'Maya Pertiwi',
      'date': '5 Maret 2025',
    },
    {
      'image': 'https://picsum.photos/800/400?random=4',
      'category': 'Health',
      'title': 'Tips Hidup Sehat dan Bahagia',
      'description': 'Cara menjaga kesehatan tubuh dan pikiran.',
      'content':
          'Hidup sehat dan bahagia adalah aspirasi universal yang kita semua kejar. Namun di tengah kesibukan modern, menjaga keseimbangan kesehatan fisik dan mental bisa menjadi tantangan tersendiri.\n\nBerikut adalah beberapa tips sederhana namun efektif untuk menjaga kesehatan tubuh dan pikiran:\n\n1. Nutrisi Seimbang: Konsumsi makanan yang kaya akan nutrisi penting, termasuk buah-buahan, sayuran, protein tanpa lemak, dan biji-bijian utuh. Hindari makanan olahan dan tinggi gula.\n\n2. Aktivitas Fisik Teratur: Sediakan waktu minimal 30 menit setiap hari untuk berolahraga. Ini bisa berupa jalan cepat, berlari, berenang, atau bahkan yoga.\n\n3. Tidur Berkualitas: Usahakan untuk tidur 7-8 jam setiap malam. Tidur yang cukup membantu memperbaiki sel-sel tubuh dan menjaga fungsi kognitif.\n\n4. Kelola Stres: Praktikkan teknik relaksasi seperti meditasi, pernapasan dalam, atau mindfulness untuk mengurangi stres.\n\n5. Hubungan Sosial: Jaga hubungan dengan keluarga dan teman. Koneksi sosial yang kuat telah terbukti meningkatkan kebahagiaan dan umur panjang.\n\n6. Batasi Paparan Media: Terlalu banyak informasi, terutama berita negatif, dapat memengaruhi kesehatan mental. Atur waktu Anda untuk menggunakan gadget dan media sosial.\n\nIngat, perubahan kecil yang konsisten seiring waktu dapat memberikan dampak besar pada kesehatan dan kebahagiaan Anda secara keseluruhan.',
      'author': 'Dr. Anita Setiawan',
      'date': '3 Maret 2025',
    },
  ];

  int _currentIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _nextSlide();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _nextSlide() {
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

  void _navigateToDetailPage(Map<String, String> article) {
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
              print('$value clicked');
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'login', child: Text('Login')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(Icons.person, color: Colors.black, size: 30),
                  ),
                  SizedBox(height: 10),
                  Text("User Name",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text("user@example.com",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            ListTile(
                leading: Icon(Icons.home), title: Text('Home'), onTap: () {}),
            ListTile(
                leading: Icon(Icons.article),
                title: Text('Articles'),
                onTap: () {}),
            ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {}),
            Divider(),
            ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {}),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
                        onTap: () => _navigateToDetailPage(article),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: article['image']!,
                              width: double.infinity,
                              height: 300,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                            ),
                            // Gradient Overlay
                            Container(
                              width: double.infinity,
                              height: 300,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.3),
                                    Colors.black.withOpacity(0.7)
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article['category']!,
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                  Text(
                                    article['title']!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    article['description']!,
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      articles.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 2),
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
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: _previousSlide,
                  ),
                ),
                // Tombol Next
                Positioned(
                  right: 10,
                  top: 100,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: _nextSlide,
                  ),
                ),
              ],
            ),

            // Kategori Filter
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    _buildCategoryChip('All', true),
                    _buildCategoryChip('Technology', false),
                    _buildCategoryChip('Business', false),
                    _buildCategoryChip('Food', false),
                    _buildCategoryChip('Health', false),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),

            // Judul Bagian Artikel
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Semua Artikel',
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
              physics: NeverScrollableScrollPhysics(), // Ini penting!
              shrinkWrap: true, // Ini juga penting!
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.8,
              ),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () => _navigateToDetailPage(article),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Gambar Artikel
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl: article['image']!,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Tambah sedikit margin agar tidak terlalu menempel
                        SizedBox(height: 10),

                        // Kategori (Warna Emas, Center)
                        Text(
                          article['category']!,
                          style: TextStyle(
                            color: Colors.amber[700],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        // Tambah sedikit margin agar kategori & judul tidak nempel
                        SizedBox(height: 5),

                        // Judul (Center)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            article['title']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              itemCount: 3, // Hanya tampilkan 3 artikel favorit
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
                        child: CachedNetworkImage(
                          imageUrl: articles[index]['image']!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Konten
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                articles[index]['category']!,
                                style: TextStyle(
                                  color: Colors.amber[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                articles[index]['title']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                articles[index]['description']!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
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
    );
  }
}

class DetailPage extends StatelessWidget {
  final Map<String, String> article;
  DetailPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar dengan gambar sebagai background
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                article['title']!,
                style: TextStyle(
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
                  CachedNetworkImage(
                    imageUrl: article['image']!,
                    fit: BoxFit.cover,
                  ),
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

          // Konten Artikel
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori & Meta Info
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          article['category']!,
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.amber[800],
                      ),
                      Spacer(),
                      if (article.containsKey('date'))
                        Text(
                          article['date']!,
                          style: TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Info Penulis
                  if (article.containsKey('author'))
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(Icons.person, color: Colors.black),
                        ),
                        SizedBox(width: 10),
                        Text(
                          article['author']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 24),

                  // Deskripsi Singkat
                  Text(
                    article['description']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),

                  // Konten Utama
                  Text(
                    article['content'] ?? 'Konten artikel belum tersedia.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Tombol Share
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.share),
                        label: Text('Bagikan Artikel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          // Implementasi fungsi share
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Berbagi artikel...'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 40),

                  // Artikel Terkait
                  Text(
                    'Artikel Terkait',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildRelatedArticles(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedArticles() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 250,
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.network(
                    'https://picsum.photos/100/200?random=${index + 10}',
                    width: 100,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Artikel Terkait ${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Deskripsi singkat artikel terkait yang menarik untuk dibaca selanjutnya.',
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
          );
        },
      ),
    );
  }
}
