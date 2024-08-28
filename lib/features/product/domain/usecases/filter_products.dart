import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/usecase/usecase.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

class FilterProducts extends UseCase<List<Product>, FilterProductsParams> {
  final ProductRepository repository;

  FilterProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(FilterProductsParams params) async {
    return await repository.filterProductsByCategory(params.category);
  }

  Future<Either<Failure, List<Product>>> byPriceRange(double min, double max) async {
    return await repository.filterProductsByPriceRange(min, max);
  }
}

class FilterProductsParams {
  final String category;
  final double min;
  final double max;

  FilterProductsParams({required this.category, required this.min, required this.max});
}