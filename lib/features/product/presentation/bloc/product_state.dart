part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

//
class ProductInitial extends ProductState {}

//getting all products
class GettingAllProducts extends ProductState {}

class GetAllProductsSuccess extends ProductState {
  final Stream<List<Product>> products;

  GetAllProductsSuccess({required this.products});
}

//adding product
class AddingProduct extends ProductState {}

class AddingProductSuccess extends ProductState {
  final Product product;

  AddingProductSuccess({required this.product});
}

class ErrorState extends ProductState {
  final String error;

  ErrorState({required this.error});
}

//filter products
class FilteringProducts extends ProductState {}

class FilteringProductsSuccess extends ProductState {
  final Stream<List<Product>> products;

  FilteringProductsSuccess({required this.products});
}

//update product
class UpdatingProduct extends ProductState {}

class UpdatingProductSuccess extends ProductState {
  final Product product;

  UpdatingProductSuccess({required this.product});
}

//delete product
class DeletingProduct extends ProductState {}

class DeleteProductSuccess extends ProductState {}


