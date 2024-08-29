import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalog/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_catalog/features/product/presentation/widgets/product_search_delegate.dart';

class ProductsPage extends StatelessWidget {
  final Widget child;

  const ProductsPage({super.key, required this.child});

  static Route route(Widget child) =>
      MaterialPageRoute(builder: (context) => ProductsPage(child: child));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product CataLog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(
                  productBloc: BlocProvider.of<ProductBloc>(context),
                ),
              );
            },
          ),
        ],
      ),
      body: child,
    );
  }
}
