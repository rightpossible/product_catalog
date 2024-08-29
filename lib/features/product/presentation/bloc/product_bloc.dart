import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/usecases/add_product.dart';
import 'package:product_catalog/features/product/domain/usecases/delete_product.dart';
import 'package:product_catalog/features/product/domain/usecases/filter_products.dart';
import 'package:product_catalog/features/product/domain/usecases/get_products.dart';
import 'package:product_catalog/features/product/domain/usecases/update_product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts getAllProducts;
  final AddProduct addProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final FilterProducts filterProducts;

  ProductBloc({
    required this.getAllProducts,
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.filterProducts,
  }) : super(ProductInitial()) {
    on<GetAllProductsEvent>(_onGetAllProducts);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<ApplyFiltersEvent>(_onApplyFilters);
  }

  Future<void> _onGetAllProducts(
      GetAllProductsEvent event, Emitter<ProductState> emit) async {
    emit(GettingAllProducts());
    final result = await getAllProducts.call(NoParams());

    if (emit.isDone) return;
    result.fold(
      (l) => emit(ErrorState(error: l.message)),
      (r) => emit(GetAllProductsSuccess(products: r)),
    );
  }

  Future<void> _onAddProduct(
      AddProductEvent event, Emitter<ProductState> emit) async {
    emit(AddingProduct());
    final result = await addProduct.call(
        AddProductParams(product: event.product, imageFile: event.imageFile));

    if (emit.isDone) return;
    result.fold(
      (l) => emit(ErrorState(error: l.message)),
      (r) => emit(AddingProductSuccess(product: r)),
    );
  }

  Future<void> _onUpdateProduct(
      UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(UpdatingProduct());
    final result =
        await updateProduct.call(UpdateProductParams(product: event.product));
    result.fold((l) => emit(ErrorState(error: l.message)),
        (r) => emit(UpdatingProductSuccess(product: r)));

    add(GetAllProductsEvent());
  }

  Future<void> _onDeleteProduct(
      DeleteProductEvent event, Emitter<ProductState> emit) async {
    print('Bloc: Deleting product ${event.product.id}');
    emit(DeletingProduct());
    final result =
        await deleteProduct.call(DeleteProductParams(product: event.product));
    result.fold(
      (failure) {
        print('Bloc: Failed to delete product: ${failure.message}');
        emit(ErrorState(error: failure.message));
      },
      (_) {
        print('Bloc: Product deleted successfully');
        emit(DeleteProductSuccess());
        // After emitting DeleteProductSuccess, we should fetch the updated product list
        // add(GetAllProductsEvent());
      },
    );
  }

  Future<void> _onApplyFilters(
      ApplyFiltersEvent event, Emitter<ProductState> emit) async {
    emit(FilteringProducts());
    final result = await filterProducts(FilterProductsParams(
      category: event.category ?? '',
      min: event.minPrice,
      max: event.maxPrice,
    ));
    result.fold(
      (failure) => emit(ErrorState(error: failure.message)),
      (filteredProducts) {
        print('Filtered products: $filteredProducts'); // Debug print
        emit(FilteringProductsSuccess(products: filteredProducts));
      },
    );
  }
}
