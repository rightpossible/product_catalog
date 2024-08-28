import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_catalog/core/constant/database_string.dart';
import 'package:product_catalog/features/product/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box box;
  ProductLocalDataSourceImpl({required this.box});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      return box.get(DatabaseString.productTable) as List<ProductModel>;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    try {
      final products = await getProducts();
      products.add(product);
      await box.put(DatabaseString.productTable, products);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final products = await getProducts();
      products.removeWhere((product) => product.id == id);
      await box.put(DatabaseString.productTable, products);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final products = await getProducts();
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      final products = await getProducts();
      final index = products.indexWhere((product) => product.id == product.id);
      if (index != -1) {
        products[index] = product;
        await box.put(DatabaseString.productTable, products);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
