import 'package:flutter/material.dart';
import 'package:product_catalog/features/product/presentation/widgets/loading_product_list_card.dart';

class ProductLoadingWidget extends StatelessWidget {
  const ProductLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6, // Show 6 loading cards
      itemBuilder: (_, __) => const LoadingProductListCard(),
    );
  }
}
