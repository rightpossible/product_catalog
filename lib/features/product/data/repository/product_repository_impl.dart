import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/network/connection_checker.dart';
import 'package:product_catalog/features/product/data/datasources/local_datasource.dart';
import 'package:product_catalog/features/product/data/models/product_model.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  ProductRepositoryImpl(this.localDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, void>> addProduct(Product product) async {
    try {
      await localDataSource.addProduct(ProductModel.fromEntity(product));
      return right(null);
    } catch (e) {
      print(e);
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Product>>> filterProductsByCategory(String category) {
    // TODO: implement filterProductsByCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Product>>> filterProductsByPriceRange(double min, double max) {
    // TODO: implement filterProductsByPriceRange
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() {
    // TODO: implement getAllProducts
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }
}