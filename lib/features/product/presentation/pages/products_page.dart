import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  final Widget child;

  const ProductsPage({super.key, required this.child});

  static Route route(Widget child) =>
      MaterialPageRoute(builder: (context) => ProductsPage(child: child));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: child,
    );
  }
}
