import 'package:flutter/material.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProductListCard extends StatelessWidget {
  final Product product;
  const ProductListCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              IconButton(
                icon:
                    Icon(Icons.favorite_border, size: isSmallScreen ? 24 : 28),
                onPressed: () {},
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  product.category,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: isSmallScreen ? 12 : 14,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AutoSizeText(
                  product.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: isSmallScreen ? 16 : 20,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallScreen ? 10 : 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, size: isSmallScreen ? 20 : 24),
                      ],
                    ),
                    Text(
                      'NGN ${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: isSmallScreen ? 18 : 22,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
