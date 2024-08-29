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
class AddingProductState extends ProductState {}

class AddingProductSuccessState extends ProductState {
  final Product product;

  AddingProductSuccessState({required this.product});
}

class ErrorState extends ProductState {
  final String error;

  ErrorState({required this.error});
}

//filter products
class FilteringProductsState extends ProductState {}

class FilteringProductsSuccessState extends ProductState {
  final List<Product> products;

  FilteringProductsSuccessState({required this.products});
}

//update product
class UpdatingProductState extends ProductState {}

class UpdatingProductSuccessState extends ProductState {}

//delete product
class DeletingProductState extends ProductState {}

class DeletingProductSuccessState extends ProductState {}
