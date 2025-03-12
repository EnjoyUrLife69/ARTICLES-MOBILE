// lib/widgets/custom_footer.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFooter extends StatelessWidget {
  final bool isDark;

  const CustomFooter({Key? key, this.isDark = true}) : super(key: key);

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Pastikan warna selalu hitam
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo atau Nama Aplikasi
          Text(
            'ARTICLES',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          // Sosial Media dan Tautan
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                Icons.web,
                'https://www.yourwebsite.com',
              ),
              SizedBox(width: 20),
              _buildSocialIcon(
                Icons.facebook,
                'https://www.facebook.com/yourpage',
              ),
              SizedBox(width: 20),
              _buildSocialIcon(
                Icons.email,
                'mailto:contact@yourcompany.com',
              ),
            ],
          ),
          SizedBox(height: 16),

          // Tautan Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterLink('Privacy Policy', () {
                Navigator.pushNamed(context, '/privacy');
              }),
              SizedBox(width: 20),
              _buildFooterLink('Terms of Service', () {
                Navigator.pushNamed(context, '/terms');
              }),
              SizedBox(width: 20),
              _buildFooterLink('Contact', () {
                Navigator.pushNamed(context, '/contact');
              }),
            ],
          ),
          SizedBox(height: 16),

          // Hak Cipta
          Text(
            '© 2025 Articles App. All Rights Reserved.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
      onPressed: () => _launchURL(url),
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
