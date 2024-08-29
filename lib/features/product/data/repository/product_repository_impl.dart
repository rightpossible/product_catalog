import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/network/connection_checker.dart';
import 'package:product_catalog/features/product/data/datasources/local_datasource.dart';
import 'package:product_catalog/features/product/data/datasources/remote_datasource.dart';
import 'package:product_catalog/features/product/data/models/product_model.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(
      this.localDataSource, this.connectionChecker, this.remoteDataSource);

  @override
  Future<Either<Failure, ProductModel>> addProduct(
      Product product, File imageFile) async {
    try {
      if (await connectionChecker.isConnected) {
        final productImageUrl =
            await remoteDataSource.uploadImage(imageFile.path);
        final productModel = ProductModel.fromEntity(product);

        final productModelWithImage =
            productModel.copyWith(imageUrl: productImageUrl);

        await remoteDataSource.addProduct(productModelWithImage);
        return Right(productModelWithImage);
      } else {
        return Left(Failure(message: 'No internet connection'));
      }
      // return Left(Failure(message: 'some thing went wrong'));
    } catch (e) {
      print(e);
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(Product product) async {
    try {
      final isDeleted = await remoteDataSource.deleteProduct(product.id);
      if (isDeleted) {
        await remoteDataSource.deleteImage(product.imageUrl);
        return const Right(null);
      } else {
        return Left(Failure(message: 'Failed to delete product'));
      }
    } catch (e) {
      print('Error deleting product: $e'); // Debug print statement
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> filterProductsByCategory(
      String category) async {
    try {
      if (await connectionChecker.isConnected) {
        final products =
            await remoteDataSource.filterProductsByCategory(category);
        return Right(products);
      } else {
        return Left(Failure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> filterProductsByPriceRange(
      double min, double max) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Stream<List<Product>>>> getAllProducts() async {
    try {
      if (await connectionChecker.isConnected) {
        final products = remoteDataSource.getAllProducts();
        return Right(products);
      } else {
        return Left(Failure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      if (await connectionChecker.isConnected) {
        final product = await remoteDataSource.getProductById(id);
        return Right(product);
      } else {
        return Left(Failure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    try {
      if (await connectionChecker.isConnected) {
        final productModel = ProductModel.fromEntity(product);
        await remoteDataSource.updateProduct(productModel);
        return Right(productModel);
      } else {
        return Left(Failure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String localImageUrl) async {
    try {
      if (await connectionChecker.isConnected) {
        return Right(await remoteDataSource.uploadImage(localImageUrl));
      } else {
        return Left(Failure(message: 'No internet connection, pls try again'));
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Stream<List<Product>>>> filterProducts(
      String? category, double minPrice, double maxPrice) async {
    try {
      if (await connectionChecker.isConnected) {
        final products =
            await remoteDataSource.filterProducts(category, minPrice, maxPrice);
        return Right(products);
      } else {
        return Left(Failure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
