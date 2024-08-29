import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/network/connection_checker.dart';
import 'package:product_catalog/features/product/data/datasources/local_datasource.dart';
import 'package:product_catalog/features/product/data/datasources/remote_datasource.dart';
import 'package:product_catalog/features/product/data/models/product_model.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

/// Implementation of the [ProductRepository] interface.
///
/// This class provides concrete implementations for all the methods
/// defined in the [ProductRepository] interface. It handles both local
/// and remote data sources, and manages network connectivity checks.
class ProductRepositoryImpl implements ProductRepository {
  /// Local data source for product operations.
  final ProductLocalDataSource localDataSource;

  /// Utility to check network connectivity.
  final ConnectionChecker connectionChecker;

  /// Remote data source for product operations.
  final ProductRemoteDataSource remoteDataSource;

  /// Constructs a [ProductRepositoryImpl] with the required dependencies.
  ///
  /// @param localDataSource The local data source for product operations.
  /// @param connectionChecker Utility to check network connectivity.
  /// @param remoteDataSource The remote data source for product operations.
  ProductRepositoryImpl(
      this.localDataSource, this.connectionChecker, this.remoteDataSource);

  /// Adds a new product to the repository.
  ///
  /// @param product The product to be added.
  /// @param imageFile The image file associated with the product.
  /// @return A [Future] that resolves to an [Either] containing either a [Failure] or a [ProductModel].
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
    } catch (e) {
      print(e);
      return Left(Failure(message: e.toString()));
    }
  }

  /// Deletes a product from the repository.
  ///
  /// @param product The product to be deleted.
  /// @return A [Future] that resolves to an [Either] containing either a [Failure] or void.
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

  /// Filters products by category.
  ///
  /// @param category The category to filter by.
  /// @return A [Future] that resolves to an [Either] containing either a [Failure] or a list of [Product]s.
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

  /// Filters products by price range.
  ///
  /// @param min The minimum price.
  /// @param max The maximum price.
  /// @return A [Future] that resolves to an [Either] containing either a [Failure] or a list of [Product]s.
  @override
  Future<Either<Failure, List<Product>>> filterProductsByPriceRange(
      double min, double max) {
    throw UnimplementedError();
  }

  /// Retrieves all products from the repository.
  ///
  /// @return A [Future] that resolves to an [Either] containing either a [Failure] or a [Stream] of [List<Product>].
  @override
  Future<Either<Failure, Stream<List<Product>>>> getAllProducts() async {
    try {
      print('Attempting to get all products'); // Debug print statement
      if (await connectionChecker.isConnected) {
        print('Connected to the internet'); // Debug print statement
        // Fetch data from remote data source
        final remoteProducts = remoteDataSource.getAllProducts();

        print('Clearing local database'); // Debug print statement
        // Clear the local database
        await localDataSource.clearProducts();

        print('Saving new data locally'); // Debug print statement
        // Save new data locally
        remoteProducts.listen((products) async {
          for (var product in products) {
            await localDataSource.addProduct(product);
          }
        });

        print('Returning remote products'); // Debug print statement
        return Right(remoteProducts);
      } else {
        print(
            'No internet connection, fetching local products'); // Debug print statement
        // Fetch data from local data source when offline
        final localProducts = localDataSource.getProducts();
        return Right(localProducts);
      }
    } catch (e) {
      print('Error in getAllProducts: $e'); // Debug print statement
      return Left(Failure(message: e.toString()));
    }
  }

  /// Retrieves a product by its ID.
  ///
  /// @param id The ID of the product to retrieve.
  /// @return A [Future] that resolves to an [Either] containing either a [Failure] or a [Product].
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

  /// Updates an existing product in the repository.
  ///
  /// @param product The updated product information.
  /// @return A [Future] that resolves to an [Either] containing either a [Failure] or the updated [Product].
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

  /// Uploads an image to the repository.
  ///
  /// @param localImageUrl The local URL of the image to be uploaded.
  /// @return A [Future] that resolves to an [Either] containing either a [Failure] or the remote URL of the uploaded image.
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

  /// Filters products based on category and price range.
  ///
  /// @param category The category to filter by (optional).
  /// @param minPrice The minimum price for the filter.
  /// @param maxPrice The maximum price for the filter.
  /// @return A [Future] that resolves to an [Either] containing either a [Failure] or a [Stream] of [List<Product>].
  @override
  Future<Either<Failure, Stream<List<Product>>>> filterProducts(
      String? category, double minPrice, double maxPrice) async {
    try {
      if (await connectionChecker.isConnected) {
        final products =
            remoteDataSource.filterProducts(category, minPrice, maxPrice);
        return Right(products);
      } else {
        final products =
            localDataSource.filterProducts(category, minPrice, maxPrice);
        return Right(products);
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
