import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, Stream<List<Product>>>> getAllProducts();
  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, Product>> addProduct(Product product, File imageFile);
  Future<Either<Failure, Product>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(String id);
  Future<Either<Failure, List<Product>>> filterProductsByCategory(
      String category);
  Future<Either<Failure, List<Product>>> filterProductsByPriceRange(
      double min, double max);
  Future<Either<Failure, String>> uploadImage(String localImageUrl);
}
