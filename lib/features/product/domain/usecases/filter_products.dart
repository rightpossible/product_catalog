import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/usecase/usecase.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

/// Use case for filtering products based on category and price range.
class FilterProducts extends UseCase<Stream<List<Product>>, FilterProductsParams> {
  /// The repository responsible for product-related operations.
  final ProductRepository repository;

  /// Creates an instance of [FilterProducts] with the given [repository].
  FilterProducts(this.repository);

  /// Executes the use case to filter products.
  ///
  /// Takes [FilterProductsParams] as input and returns a [Future] that resolves to
  /// an [Either] containing either a [Failure] or a [Stream] of filtered [Product] lists.
  @override
  Future<Either<Failure, Stream<List<Product>>>> call(
      FilterProductsParams params) async {
    return await repository.filterProducts(
        params.category, params.min, params.max);
  }
}

/// Parameters for the [FilterProducts] use case.
class FilterProductsParams {
  /// The category to filter products by.
  final String category;

  /// The minimum price for the filter range.
  final double min;

  /// The maximum price for the filter range.
  final double max;

  /// Creates an instance of [FilterProductsParams] with the required [category], [min], and [max] values.
  FilterProductsParams(
      {required this.category, required this.min, required this.max});
}
