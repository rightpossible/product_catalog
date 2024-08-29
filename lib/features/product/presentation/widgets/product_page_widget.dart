import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/entities/categories.dart';
import 'package:product_catalog/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_catalog/features/product/presentation/pages/product_details_page.dart';

import 'package:product_catalog/features/product/presentation/widgets/product_list_card.dart';

class ProductPageWidgets extends StatelessWidget {
  const ProductPageWidgets({
    super.key,
    required this.productsStream,
  });

  final Stream<List<Product>> productsStream;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Best Sale Product',
                      style: Theme.of(context).textTheme.titleLarge),
                  TextButton.icon(
                    onPressed: () => _showFilterBottomSheet(context),
                    icon: const Icon(Icons.filter_list),
                    label: Text('Filter',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: state is FilteringProductsSuccess
                    ? state.products
                    : productsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final products = snapshot.data ?? [];

                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters or Add new product',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return AnimationLimiter(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ProductDetailsPage(
                                            product: products[index]),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                ),
                                child:
                                    ProductListCard(product: products[index]),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
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
}

class FilterBottomSheet extends StatefulWidget {
  final Function(Category?, RangeValues) onApplyFilters;

  const FilterBottomSheet({super.key, required this.onApplyFilters});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
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
