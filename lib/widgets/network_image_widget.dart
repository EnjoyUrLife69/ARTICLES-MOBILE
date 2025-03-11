// lib/widgets/network_image_widget.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const NetworkImageWidget({
    Key? key,
    required this.imageUrl,
    this.width = double.infinity,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    // Log the image URL for debugging
    log('Building image with URL: $imageUrl');

    // Check if URL is valid
    if (imageUrl == null || imageUrl!.isEmpty) {
      log('Image URL is null or empty, using placeholder');
      imageWidget = _buildPlaceholder();
    } else {
      // Check if URL is valid HTTP/HTTPS
      if (!imageUrl!.startsWith('http://') &&
          !imageUrl!.startsWith('https://')) {
        log('Image URL does not start with http:// or https://, using placeholder');
        imageWidget = _buildPlaceholder();
      } else {
        log('Using CachedNetworkImage for URL: $imageUrl');
        // Use CachedNetworkImage for valid URLs
        imageWidget = CachedNetworkImage(
          imageUrl: imageUrl!,
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) => _buildLoadingIndicator(),
          errorWidget: (context, url, error) {
            log('Error loading image: $url - $error');
            return _buildPlaceholder();
          },
        );
      }
    }

    // Apply border radius if provided
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade500),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Image.network(
      'https://picsum.photos/${width.toInt()}/${height.toInt()}',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        log('Error loading placeholder image: $error');
        return Container(
          width: width,
          height: height,
          color: Colors.grey.shade300,
          child: Icon(
            Icons.image_not_supported,
            size: height / 3,
            color: Colors.grey.shade700,
          ),
        );
      },
    );
  }
}
