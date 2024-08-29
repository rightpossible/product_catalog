import 'package:drift/drift.dart';
import 'package:product_catalog/core/database/tables.dart';
import 'package:product_catalog/core/errors/exception.dart';
import 'package:product_catalog/core/utils/image_utils.dart';
import 'package:product_catalog/features/product/data/models/product_model.dart';

/// Abstract class defining the contract for local data operations related to products.
abstract class ProductLocalDataSource {
  /// Retrieves a stream of all products from the local database.
  Stream<List<ProductModel>> getProducts();

  /// Adds a new product to the local database.
  Future<void> addProduct(ProductModel product);

  /// Filters products based on category, minimum price, and maximum price.
  Stream<List<ProductModel>> filterProducts(
      String? category, double minPrice, double maxPrice);

  /// Searches for products based on a query string.
  Future<List<ProductModel>> searchProducts(String query);

  /// Clears all products from the local database.
  Future<void> clearProducts();
}

/// Implementation of [ProductLocalDataSource] using Drift database.
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final AppDatabase database;

  ProductLocalDataSourceImpl({required this.database});

  @override
  Future<void> addProduct(ProductModel product) async {
    try {
      String? localImagePath;
      if (product.imageUrl.startsWith('http')) {
        localImagePath =
            await ImageUtils.downloadAndSaveImage(product.imageUrl);
      }
      await database.into(database.products).insert(ProductsCompanion.insert(
            category: product.category,
            description: product.description,
            id: product.id,
            imageUrl: product.imageUrl,
            name: product.name,
            price: product.price,
            localImageUrl: Value(localImagePath),
          ));
    } catch (e) {
      print('Error in addProduct: $e');
      throw LocalException('Failed to add product: ${e.toString()}');
    }
  }

  @override
  Stream<List<ProductModel>> filterProducts(
      String? category, double minPrice, double maxPrice) {
    try {
      return database.select(database.products).watch().map((rows) {
        return rows
            .where((row) =>
                (category == null || row.category == category) &&
                row.price >= minPrice &&
                row.price <= maxPrice)
            .map((row) => ProductModel.fromJson(row.toJson()))
            .toList();
      });
    } catch (e) {
      print(e);
      throw LocalException(e.toString());
    }
  }

  @override
  Stream<List<ProductModel>> getProducts() {
    try {
      return database.select(database.products).watch().map((rows) {
        return rows.map((row) => ProductModel.fromJson(row.toJson())).toList();
      });
    } catch (e) {
      print(e);
      throw LocalException(e.toString());
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final results = await (database.select(database.products)
            ..where((tbl) =>
                tbl.name.like('%$query%') | tbl.description.like('%$query%')))
          .get();

      print('Search results: $results');
      return results.map((row) => ProductModel.fromJson(row.toJson())).toList();
    } catch (e) {
      print('Error searching products: $e');
      throw LocalException(e.toString());
    }
  }

  @override
  Future<void> clearProducts() async {
    try {
      print('Starting to clear products from local database');
      await database.delete(database.products).go();
      print('Successfully cleared products from local database');
    } catch (e) {
      print('Error clearing products from local database: $e');
      throw LocalException('Failed to clear products: ${e.toString()}');
    }
  }
}
