import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final String? localImagePath;

  const ProductImage({super.key, required this.imageUrl, this.localImagePath});

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }

  Widget _buildImage() {
    if (_isLocalImageAvailable()) {
      return Image.file(File(localImagePath!));
    }
    return _buildNetworkImage();
  }

  bool _isLocalImageAvailable() {
    return localImagePath != null && File(localImagePath!).existsSync();
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.cover,
    );
  }
}
