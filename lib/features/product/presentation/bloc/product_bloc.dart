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
  final GetAllProducts _getAllProducts;
  final AddProduct _addProduct;
  final UpdateProduct _updateProduct;
  final DeleteProduct _deleteProduct;
  final FilterProducts _filterProducts;
  ProductBloc({
    required GetAllProducts getAllProducts,
    required AddProduct addProduct,
    required UpdateProduct updateProduct,
    required DeleteProduct deleteProduct,
    required FilterProducts filterProducts,
  })  : _getAllProducts = getAllProducts,
        _addProduct = addProduct,
        _updateProduct = updateProduct,
        _deleteProduct = deleteProduct,
        _filterProducts = filterProducts,
        super(ProductInitial()) {
    on<ProductEvent>((event, emit) {});
    on<GetAllProductsEvent>(_onGetAllProducts);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<FilterProductsEvent>(_onFilterProducts);
  }

  Future<void> _onGetAllProducts(
      GetAllProductsEvent event, Emitter<ProductState> emit) async {
    emit(GettingAllProducts());
    final result = await _getAllProducts.call(NoParams());

    if (emit.isDone) return;
    result.fold(
      (l) => emit(ErrorState(error: l.message)),
      (r) => emit(GetAllProductsSuccess(products: r)),
    );
  }

  Future<void> _onAddProduct(
      AddProductEvent event, Emitter<ProductState> emit) async {
    emit(AddingProductState());
    final result = await _addProduct.call(
        AddProductParams(product: event.product, imageFile: event.imageFile));

    if (emit.isDone) return;
    result.fold(
      (l) => emit(ErrorState(error: l.message)),
      (r) => emit(AddingProductSuccessState(product: r)),
    );
  }

  Future<void> _onUpdateProduct(
      UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(UpdatingProductState());
    final result =
        await _updateProduct.call(UpdateProductParams(product: event.product));
    result.fold((l) => emit(ErrorState(error: l.message)),
        (r) => emit(UpdatingProductSuccessState()));
  }

  Future<void> _onDeleteProduct(
      DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(DeletingProductState());
    final result =
        await _deleteProduct.call(DeleteProductParams(id: event.productId));
    result.fold((l) => emit(ErrorState(error: l.message)),
        (r) => emit(DeletingProductSuccessState()));
  }

  Future<void> _onFilterProducts(
      FilterProductsEvent event, Emitter<ProductState> emit) async {
    emit(FilteringProductsState());
    final result = await _filterProducts.call(FilterProductsParams(
        category: event.category, min: event.min, max: event.max));
    result.fold((l) => emit(ErrorState(error: l.message)),
        (r) => emit(FilteringProductsSuccessState(products: r)));
  }
}
