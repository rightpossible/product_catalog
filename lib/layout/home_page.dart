import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalog/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_catalog/features/product/presentation/pages/products_page.dart';
import 'package:product_catalog/features/product/presentation/pages/add_Edit_product_page.dart';
import 'package:product_catalog/features/product/presentation/widgets/loading_product_list_card.dart';
import 'package:product_catalog/features/product/presentation/widgets/product_loading_widget.dart';
import 'package:product_catalog/features/product/presentation/widgets/product_page_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<ProductBloc>().add(GetAllProductsEvent());
    super.initState();
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildBody(),
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

  Widget _buildBody() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is GetAllProductsSuccess) {
          return _selectedIndex == 0
              ? ProductsPage(
                  child: ProductPageWidgets(productsStream: state.products),
                )
              : const AddEditProductPage();
        } else if (state is FilteringProductsSuccess) {
          return ProductsPage(
            child: ProductPageWidgets(productsStream: state.products),
          );
        } else if (state is ErrorState) {
          return Center(child: Text('Error: ${state.error}'));
        }
        // Show loading state
        return const ProductsPage(
          child: ProductLoadingWidget(),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        context.read<ProductBloc>().add(GetAllProductsEvent());
      }
    });
  }
}
