
import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/usecase/usecase.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

/// Use case for updating an existing product in the catalog.
class UpdateProduct extends UseCase<Product, UpdateProductParams> {
  /// The repository responsible for product-related operations.
  final ProductRepository repository;

  /// Creates an instance of [UpdateProduct] with the given [repository].
  UpdateProduct(this.repository);

  /// Executes the use case to update a product.
  ///
  /// Takes [UpdateProductParams] as input and returns a [Future] that resolves to
  /// an [Either] containing either a [Failure] or the updated [Product].
  @override
  Future<Either<Failure, Product>> call(UpdateProductParams params) async {
    return await repository.updateProduct(params.product);
  }
}

/// Parameters for the [UpdateProduct] use case.
class UpdateProductParams {
  /// The product to be updated.
  final Product product;

  /// Creates an instance of [UpdateProductParams] with the required [product].
  UpdateProductParams({required this.product});
}
