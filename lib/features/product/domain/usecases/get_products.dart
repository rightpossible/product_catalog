import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/usecase/usecase.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

/// Use case for retrieving all products from the catalog.
class GetAllProducts extends UseCase<Stream<List<Product>>, NoParams> {
  /// The repository responsible for product-related operations.
  final ProductRepository repository;

  /// Creates an instance of [GetAllProducts] with the given [repository].
  GetAllProducts(this.repository);

  /// Executes the use case to retrieve all products.
  ///
  /// Takes [NoParams] as input and returns a [Future] that resolves to
  /// an [Either] containing either a [Failure] or a [Stream] of [Product] lists.
  @override
  Future<Either<Failure, Stream<List<Product>>>> call(NoParams params) async {
    return await repository.getAllProducts();
  }
}

/// Represents an empty parameter set for use cases that don't require input.
class NoParams {}
