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
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<ProductBloc>().add(GetAllProductsEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
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
        try {
          final completer = Completer<void>();
          context.read<ProductBloc>().add(GetAllProductsEvent());

          // Listen for the state change
          final subscription =
              context.read<ProductBloc>().stream.listen((state) {
            if (state is GetAllProductsSuccess || state is ErrorState) {
              if (!completer.isCompleted) completer.complete();
            }
          });

          // Wait for the operation to complete or timeout after 10 seconds
          await completer.future.timeout(const Duration(seconds: 10));
          await subscription.cancel();
        } catch (e) {
          // Handle timeout or any other errors
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Refresh failed: $e')),
          );
        }
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is GetAllProductsSuccess) {
            return ProductsPage(
              child: ProductPageWidgets(productsStream: state.products),
            );
          } else if (state is FilteringProductsSuccess) {
            return ProductsPage(
              child: ProductPageWidgets(productsStream: state.products),
            );
          } else if (state is ErrorState) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const ProductsPage(
            child: ProductLoadingWidget(),
          );
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}
