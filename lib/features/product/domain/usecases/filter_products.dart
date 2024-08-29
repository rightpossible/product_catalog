import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/usecase/usecase.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

class FilterProducts extends UseCase<Stream<List<Product>>, FilterProductsParams> {
  final ProductRepository repository;

  FilterProducts(this.repository);

  @override
  Future<Either<Failure, Stream<List<Product> >>> call(
      FilterProductsParams params) async {
    return await repository.filterProducts(
        params.category, params.min, params.max);
  }
}

class FilterProductsParams {
  final String category;
  final double min;
  final double max;

  FilterProductsParams(
      {required this.category, required this.min, required this.max});
}
