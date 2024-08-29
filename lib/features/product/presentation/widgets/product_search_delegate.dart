import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_catalog/features/product/presentation/pages/product_details_page.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  final ProductBloc productBloc;

  ProductSearchDelegate({required this.productBloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildSearchResults();
  }

  Widget buildSearchResults() {
    productBloc.add(ApplyFiltersEvent(
      category: null,
      minPrice: 0,
      maxPrice: double.infinity,
    ));

    return BlocBuilder<ProductBloc, ProductState>(
      bloc: productBloc,
      builder: (context, state) {
        if (state is FilteringProductsSuccess) {
          return StreamBuilder<List<Product>>(
            stream: state.products,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final results = snapshot.data!
                    .where((product) => product.name
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final product = results[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      leading: Image.network(product.imageUrl,
                          width: 50, height: 50),
                      onTap: () {
                        close(context, product);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsPage(product: product),
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        } else if (state is ErrorState) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
