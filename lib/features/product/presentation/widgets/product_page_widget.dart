import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/entities/categories.dart';
import 'package:product_catalog/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_catalog/features/product/presentation/pages/product_details_page.dart';

import 'package:product_catalog/features/product/presentation/widgets/product_list_card.dart';
import 'package:product_catalog/features/product/presentation/widgets/product_loading_widget.dart';

class ProductPageWidgets extends StatelessWidget {
  const ProductPageWidgets({
    super.key,
    required this.productsStream,
  });

  final Stream<List<Product>> productsStream;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: _handleErrorState,
      builder: (context, state) {
        return Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildProductList(context, state),
            ),
          ],
        );
      },
    );
  }

  void _handleErrorState(BuildContext context, ProductState state) {
    if (state is ErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Best Sale Product',
              style: Theme.of(context).textTheme.titleLarge),
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _showFilterBottomSheet(context),
      icon: const Icon(Icons.filter_list),
      label: Text('Filter', style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildProductList(BuildContext context, ProductState state) {
    return StreamBuilder<List<Product>>(
      stream:
          state is FilteringProductsSuccess ? state.products : productsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ProductLoadingWidget();
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final products = snapshot.data ?? [];

        if (products.isEmpty) {
          return _buildEmptyProductList(context);
        }

        return _buildProductGrid(products);
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AnimatedPadding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: FilterBottomSheet(
            onApplyFilters: (category, priceRange) {
              context.read<ProductBloc>().add(ApplyFiltersEvent(
                    category: category?.toString().split('.').last,
                    minPrice: priceRange.start,
                    maxPrice: priceRange.end,
                  ));
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyProductList(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try Adding new product',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5, // Adjusted for more vertical space
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) =>
            _buildProductItem(context, products[index], index),
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, Product product, int index) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 375),
      columnCount: 2,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: GestureDetector(
            onTap: () => _navigateToProductDetails(context, product),
            child: Container(
              decoration: _buildProductItemDecoration(context),
              child: ProductListCard(product: product),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToProductDetails(BuildContext context, Product product) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailsPage(product: product),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  BoxDecoration _buildProductItemDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final Function(Category?, RangeValues) onApplyFilters;

  const FilterBottomSheet({super.key, required this.onApplyFilters});

  @override
  FilterBottomSheetState createState() => FilterBottomSheetState();
}

class FilterBottomSheetState extends State<FilterBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  Category? selectedCategory;
  RangeValues priceRange = const RangeValues(0, 1000);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(_animation),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filter Products',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              DropdownButtonFormField<Category>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: Category.values.map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(_formatCategoryName(category)),
                  );
                }).toList(),
                onChanged: (Category? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text('Price Range',
                  style: Theme.of(context).textTheme.titleMedium),
              RangeSlider(
                values: priceRange,
                min: 0,
                max: 1000,
                divisions: 20,
                labels: RangeLabels(
                  '\$${priceRange.start.round()}',
                  '\$${priceRange.end.round()}',
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    priceRange = values;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  widget.onApplyFilters(selectedCategory, priceRange);
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCategoryName(Category category) {
    return category
        .toString()
        .split('.')
        .last
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .trim()
        .capitalize();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
