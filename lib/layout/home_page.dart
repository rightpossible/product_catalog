import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalog/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_catalog/features/product/presentation/pages/products_page.dart';
import 'package:product_catalog/features/product/presentation/pages/add_edit_product_page.dart';
import 'package:product_catalog/features/product/presentation/widgets/product_loading_widget.dart';
import 'package:product_catalog/features/product/presentation/widgets/product_page_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetAllProductsEvent());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildProductsPage(),
          const AddEditProductPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Product',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildProductsPage() {
    return RefreshIndicator(
      onRefresh: () async {
        final completer = Completer<void>();
        context.read<ProductBloc>().add(GetAllProductsEvent());

        late final StreamSubscription subscription;

        subscription = context.read<ProductBloc>().stream.listen((state) {
          if (state is GetAllProductsSuccess || state is ErrorState) {
            completer.complete();
            subscription.cancel();
          }
        });

        return completer.future;
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is GetAllProductsSuccess) {
            return ProductsPage(
              child: ProductPageWidgets(productsStream: state.products),
            );
          } else if (state is ErrorState) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is GettingAllProducts) {
            return const ProductsPage(
              child: ProductLoadingWidget(),
            );
          }
          return const ProductsPage(
            child: ProductLoadingWidget(),
          );
        },
      ),
    );
  }
}
