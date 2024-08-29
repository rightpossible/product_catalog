import 'package:flutter/material.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/presentation/pages/product_details_page.dart';
import 'package:product_catalog/features/product/presentation/widgets/loading_product_list_card.dart';
import 'package:product_catalog/features/product/presentation/widgets/product_list_card.dart';

class ProductPageWidgets extends StatelessWidget {
  const ProductPageWidgets({
    super.key,
    required this.productsStream,
  });

  final Stream<List<Product>> productsStream;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Best Sale Product',
                  style: Theme.of(context).textTheme.titleLarge),
              Text('Filter', style: Theme.of(context).textTheme.titleMedium)
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Product>>(
            stream: productsStream,
            builder: (context, snapshot) {
              final isLoading = !snapshot.hasData;
              final products = snapshot.data ?? [];
              final itemCount = isLoading ? 6 : products.length;

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (isLoading) {
                    return const LoadingProductListCard();
                  }
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context, ProductDetailsPage.route(products[index])),
                    child: ProductListCard(product: products[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
