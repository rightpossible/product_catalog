import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_catalog/layout/home_page.dart';
import 'package:product_catalog/features/product/presentation/pages/add_edit_product_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  static route(Product product) => MaterialPageRoute(
      builder: (context) => ProductDetailsPage(product: product));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2, end: 0),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, size: 28),
            onPressed: () => _navigateToEditProduct(context),
          ),
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is DeletingProduct) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is DeleteProductSuccess) {
                // Close the loading dialog
                Navigator.of(context).pop();
                // Navigate back to the home page
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              } else if (state is ErrorState) {
                // Close the loading dialog if it's open
                Navigator.of(context).pop();
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            child: IconButton(
              icon: const Icon(Icons.delete, size: 28),
              onPressed: () => _showDeleteConfirmation(context),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.home, size: 28),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            ),
          ),
        ],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage().animate().fadeIn(duration: 500.ms).scale(
                  begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 200.ms)
                            .slideX(begin: -0.2, end: 0),
                        const SizedBox(height: 16),
                        _buildRatingAndPrice(context)
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 300.ms)
                            .slideX(begin: 0.2, end: 0),
                        const SizedBox(height: 24),
                        _buildSectionTitle(context, 'Description')
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 400.ms),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 500.ms)
                            .slideY(begin: 0.2, end: 0),
                        const SizedBox(height: 24),
                        _buildSectionTitle(context, 'Category')
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 600.ms),
                        const SizedBox(height: 8),
                        Text(
                          product.category,
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 700.ms)
                            .slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 500.ms, delay: 200.ms).scale(
                    begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0)),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: _buildAddToCartButton(context),
    );
  }

  Widget _buildProductImage() {
    return Hero(
      tag: 'product_image_${product.id}',
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 500, // Limit the height on large screens
          maxWidth: double.infinity,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: product.imageUrl.isNotEmpty
            ? Image.network(
                product.imageUrl,
                fit: BoxFit.contain, // Use contain instead of cover
              )
            : const Center(
                child: Icon(Icons.image, size: 100, color: Colors.grey),
              ),
      ),
    );
  }

  Widget _buildRatingAndPrice(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Icon(Icons.star, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text('4.9',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.3)),
        const SizedBox(width: 8),
        const Text('(123 Ratings)'),
        const Spacer(),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .shimmer(
                duration: 1500.ms,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement add to cart functionality
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Add to Cart', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  void _navigateToEditProduct(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddEditProductPage(productToEdit: product),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(context);
              },
            ),
          ],
        )
            .animate()
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0))
            .fadeIn(duration: 300.ms);
      },
    );
  }

  void _deleteProduct(BuildContext context) {
    BlocProvider.of<ProductBloc>(context)
        .add(DeleteProductEvent(product: product));
  }
}
