import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingProductListCard extends StatelessWidget {
  const LoadingProductListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePlaceholder(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextPlaceholder(width: 100, height: 12),
                  const SizedBox(height: 8),
                  _buildTextPlaceholder(width: double.infinity, height: 16),
                  const SizedBox(height: 4),
                  _buildTextPlaceholder(width: 200, height: 16),
                  const SizedBox(height: 10),
                  _buildPriceAndRatingPlaceholder(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 150,
      color: Colors.white,
    );
  }

  Widget _buildTextPlaceholder({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      color: Colors.white,
    );
  }

  Widget _buildPriceAndRatingPlaceholder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTextPlaceholder(width: 80, height: 12),
        _buildTextPlaceholder(width: 60, height: 16),
      ],
    );
  }
}
