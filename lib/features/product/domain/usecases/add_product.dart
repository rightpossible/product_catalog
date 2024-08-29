import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/usecase/usecase.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

/// Use case for adding a new product to the catalog.
class AddProduct extends UseCase<Product, AddProductParams> {
  /// The repository responsible for product-related operations.
  final ProductRepository repository;

  /// Creates an instance of [AddProduct] with the given [repository].
  AddProduct(this.repository);

  /// Executes the use case to add a new product.
  ///
  /// Takes [AddProductParams] as input and returns a [Future] that resolves to
  /// an [Either] containing either a [Failure] or the added [Product].
  @override
  Future<Either<Failure, Product>> call(AddProductParams params) async {
    return await repository.addProduct(params.product, params.imageFile);
  }
}

/// Parameters for the [AddProduct] use case.
class AddProductParams {
  /// The product to be added.
  final Product product;

  /// The image file associated with the product.
  final File imageFile;

  /// Creates an instance of [AddProductParams] with the required [product] and [imageFile].
  AddProductParams({required this.product, required this.imageFile});
}
