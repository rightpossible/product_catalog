import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/usecase/usecase.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

/// Use case for deleting a product from the catalog.
class DeleteProduct extends UseCase<void, DeleteProductParams> {
  /// The repository responsible for product-related operations.
  final ProductRepository repository;

  /// Creates an instance of [DeleteProduct] with the given [repository].
  DeleteProduct(this.repository);

  /// Executes the use case to delete a product.
  ///
  /// Takes [DeleteProductParams] as input and returns a [Future] that resolves to
  /// an [Either] containing either a [Failure] or void if the deletion was successful.
  @override
  Future<Either<Failure, void>> call(DeleteProductParams params) async {
    return await repository.deleteProduct(params.product);
  }
}

/// Parameters for the [DeleteProduct] use case.
class DeleteProductParams {
  /// The product to be deleted.
  final Product product;

  /// Creates an instance of [DeleteProductParams] with the required [product].
  DeleteProductParams({required this.product});
}